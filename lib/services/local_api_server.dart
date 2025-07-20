import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/services/tunnel_service.dart';
import 'package:orphan_hq/services/network_info_service.dart';

class LocalApiServer {
  HttpServer? _server;
  final OrphanRepository _orphanRepository;
  final SupervisorRepository _supervisorRepository;
  final TunnelService _tunnelService = TunnelService();

  // Simple API key for basic security
  static const String _apiKey = 'orphan_hq_demo_2025';
  static const int _port = 45123;

  LocalApiServer({
    required OrphanRepository orphanRepository,
    required SupervisorRepository supervisorRepository,
  })  : _orphanRepository = orphanRepository,
        _supervisorRepository = supervisorRepository;

  TunnelService get tunnelService => _tunnelService;

  Future<TunnelResult> start() async {
    try {
      final handler = Pipeline()
          .addMiddleware(logRequests())
          .addMiddleware(corsHeaders())
          .addMiddleware(_authMiddleware)
          .addHandler(_router);

      _server = await serve(handler, '0.0.0.0', _port);
      print('🚀 API Server running on http://0.0.0.0:$_port');

      // Get local IP address
      final localIP = await NetworkInfoService.getLocalIPAddress();
      final localUrl = 'http://${localIP ?? 'localhost'}:$_port';

      print('🏠 Local URL: $localUrl');
      print('🔑 API Key: $_apiKey');
      print('');

      // Try to start tunnel for internet access
      TunnelResult tunnelResult;
      if (await _tunnelService.isCloudflaredAvailable()) {
        print('🌐 Starting internet tunnel...');
        tunnelResult = await _tunnelService.startTunnel(localUrl, _port);

        if (tunnelResult.hasInternetAccess) {
          print('✅ Internet tunnel established: ${tunnelResult.tunnelUrl}');
        } else {
          print('⚠️ Internet tunnel failed, using local-only mode');
          print('   Error: ${tunnelResult.error}');
        }
      } else {
        print('⚠️ Cloudflared not available, using local-only mode');
        tunnelResult = TunnelResult.localOnly(
          localUrl: localUrl,
          error: 'Cloudflared not installed',
        );
      }

      print('');
      print('Available endpoints:');
      print('  GET  /api/status          - Server status');
      print('  GET  /api/orphans         - List all orphans');
      print('  GET  /api/orphans/:id     - Get orphan details');
      print('  GET  /api/supervisors     - List all supervisors');
      print('  GET  /api/supervisors/:id - Get supervisor details');
      print('');

      return tunnelResult;
    } catch (e) {
      print('❌ Failed to start API server: $e');
      rethrow;
    }
  }

  Future<void> stop() async {
    await _tunnelService.stopTunnel();
    if (_server != null) {
      await _server!.close();
      _server = null;
      print('🛑 API Server stopped');
    }
  }

  // Authentication middleware
  Middleware get _authMiddleware => (Handler innerHandler) {
        return (Request request) async {
          // Allow OPTIONS requests for CORS preflight
          if (request.method == 'OPTIONS') {
            return innerHandler(request);
          }

          // Check for API key in header or query parameter
          final apiKeyHeader = request.headers['x-api-key'];
          final apiKeyQuery = request.url.queryParameters['api_key'];

          if (apiKeyHeader != _apiKey && apiKeyQuery != _apiKey) {
            return Response.unauthorized(
              jsonEncode({
                'error': 'Unauthorized',
                'message':
                    'Valid API key required. Include in X-API-Key header or api_key query parameter.'
              }),
              headers: {'content-type': 'application/json'},
            );
          }

          return innerHandler(request);
        };
      };

  // Route handler
  Handler get _router => (Request request) async {
        final path = request.url.path;
        final method = request.method;

        try {
          // API Status endpoint
          if (method == 'GET' && path == 'api/status') {
            return _handleStatus(request);
          }

          // Orphans endpoints
          if (method == 'GET' && path == 'api/orphans') {
            return _handleGetOrphans(request);
          }

          if (method == 'GET' && path.startsWith('api/orphans/')) {
            final orphanId = path.substring('api/orphans/'.length);
            return _handleGetOrphan(request, orphanId);
          }

          // Supervisors endpoints
          if (method == 'GET' && path == 'api/supervisors') {
            return _handleGetSupervisors(request);
          }

          if (method == 'GET' && path.startsWith('api/supervisors/')) {
            final supervisorId = path.substring('api/supervisors/'.length);
            return _handleGetSupervisor(request, supervisorId);
          }

          // 404 for unknown endpoints
          return Response.notFound(
            jsonEncode({
              'error': 'Not Found',
              'message': 'Endpoint not found: $method $path'
            }),
            headers: {'content-type': 'application/json'},
          );
        } catch (e, stackTrace) {
          print('❌ API Error: $e');
          print('Stack trace: $stackTrace');

          return Response.internalServerError(
            body: jsonEncode({
              'error': 'Internal Server Error',
              'message': 'An error occurred while processing your request.'
            }),
            headers: {'content-type': 'application/json'},
          );
        }
      };

  // Status endpoint
  Future<Response> _handleStatus(Request request) async {
    return Response.ok(
      jsonEncode({
        'status': 'online',
        'service': 'Orphan HQ API',
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'endpoints': [
          'GET /api/status',
          'GET /api/orphans',
          'GET /api/orphans/:id',
          'GET /api/supervisors',
          'GET /api/supervisors/:id',
        ]
      }),
      headers: {'content-type': 'application/json'},
    );
  }

  // Get all orphans
  Future<Response> _handleGetOrphans(Request request) async {
    try {
      final orphansStream = _orphanRepository.getAllOrphans();
      final orphans = await orphansStream.first;

      // Convert to JSON-friendly format
      final orphansList =
          orphans.map((orphan) => _orphanToJson(orphan)).toList();

      return Response.ok(
        jsonEncode({
          'success': true,
          'count': orphansList.length,
          'data': orphansList,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Database Error',
          'message': 'Failed to fetch orphans: $e'
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Get specific orphan
  Future<Response> _handleGetOrphan(Request request, String orphanId) async {
    try {
      final orphan = await _orphanRepository.getOrphanById(orphanId);

      if (orphan == null) {
        return Response.notFound(
          jsonEncode({
            'error': 'Not Found',
            'message': 'Orphan with ID $orphanId not found'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': _orphanToJson(orphan),
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Database Error',
          'message': 'Failed to fetch orphan: $e'
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Get all supervisors
  Future<Response> _handleGetSupervisors(Request request) async {
    try {
      final supervisors = await _supervisorRepository.getAllSupervisors();

      // Convert to JSON-friendly format
      final supervisorsList = supervisors
          .map((supervisor) => _supervisorToJson(supervisor))
          .toList();

      return Response.ok(
        jsonEncode({
          'success': true,
          'count': supervisorsList.length,
          'data': supervisorsList,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Database Error',
          'message': 'Failed to fetch supervisors: $e'
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Get specific supervisor
  Future<Response> _handleGetSupervisor(
      Request request, String supervisorId) async {
    try {
      final supervisor =
          await _supervisorRepository.getSupervisorById(supervisorId);

      if (supervisor == null) {
        return Response.notFound(
          jsonEncode({
            'error': 'Not Found',
            'message': 'Supervisor with ID $supervisorId not found'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Also get orphans assigned to this supervisor
      final orphansStream =
          _orphanRepository.getOrphansBySupervisor(supervisorId);
      final orphans = await orphansStream.first;
      final orphansList =
          orphans.map((orphan) => _orphanToJson(orphan)).toList();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {
            ..._supervisorToJson(supervisor),
            'assigned_orphans': orphansList,
            'orphan_count': orphansList.length,
          },
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Database Error',
          'message': 'Failed to fetch supervisor: $e'
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Convert Orphan to JSON
  Map<String, dynamic> _orphanToJson(Orphan orphan) {
    return {
      'id': orphan.orphanId,
      'name': {
        'first': orphan.firstName,
        'father': orphan.fatherName,
        'grandfather': orphan.grandfatherName,
        'family': orphan.familyName,
        'full':
            '${orphan.firstName} ${orphan.fatherName} ${orphan.grandfatherName} ${orphan.familyName}',
      },
      'gender': orphan.gender.toString().split('.').last,
      'date_of_birth': orphan.dateOfBirth.toIso8601String(),
      'age': DateTime.now().difference(orphan.dateOfBirth).inDays ~/ 365,
      'status': orphan.status.toString().split('.').last,
      'supervisor_id': orphan.supervisorId,
      'last_updated': orphan.lastUpdated.toIso8601String(),

      // Father details
      'father': {
        'name': orphan.fatherFirstName,
        'date_of_death': orphan.fatherDateOfDeath?.toIso8601String(),
        'cause_of_death': orphan.fatherCauseOfDeath,
        'occupation': orphan.fatherWork,
      },

      // Mother details
      'mother': {
        'name': orphan.motherFirstName,
        'alive': orphan.motherAlive,
        'date_of_death': orphan.motherDateOfDeath?.toIso8601String(),
        'cause_of_death': orphan.motherCauseOfDeath,
        'occupation': orphan.motherWork,
      },

      // Guardian details
      'guardian': {
        'name': orphan.guardianName,
        'relationship': orphan.guardianRelationship,
      },

      // Education
      'education': {
        'level': orphan.educationLevel?.toString().split('.').last,
        'school_name': orphan.schoolName,
        'grade': orphan.grade,
      },

      // Health
      'health': {
        'status': orphan.healthStatus?.toString().split('.').last,
        'medical_conditions': orphan.medicalConditions,
        'medications': orphan.medications,
        'needs_medical_support': orphan.needsMedicalSupport,
      },

      // Accommodation
      'accommodation': {
        'type': orphan.accommodationType?.toString().split('.').last,
        'address': orphan.accommodationAddress,
        'needs_housing_support': orphan.needsHousingSupport,
      },

      // Islamic education
      'islamic_education': {
        'quran_memorization': orphan.quranMemorization,
        'attends_islamic_school': orphan.attendsIslamicSchool,
        'level': orphan.islamicEducationLevel,
      },

      // Personal details
      'personal': {
        'hobbies': orphan.hobbies,
        'skills': orphan.skills,
        'aspirations': orphan.aspirations,
        'number_of_siblings': orphan.numberOfSiblings,
        'siblings_details': orphan.siblingsDetails,
      },

      // Additional info
      'additional_notes': orphan.additionalNotes,
      'urgent_needs': orphan.urgentNeeds,
      'has_documents': orphan.documentsPath != null,
    };
  }

  // Convert Supervisor to JSON
  Map<String, dynamic> _supervisorToJson(Supervisor supervisor) {
    return {
      'id': supervisor.supervisorId,
      'name': {
        'first': supervisor.firstName,
        'family': supervisor.familyName,
        'full': '${supervisor.firstName} ${supervisor.familyName}',
      },
      'email': supervisor.email,
      'phone': supervisor.phoneNumber,
      'date_joined': supervisor.dateJoined.toIso8601String(),
      'years_of_service':
          DateTime.now().difference(supervisor.dateJoined).inDays ~/ 365,
      'position': supervisor.position,
      'organization': supervisor.organization,
      'is_active': supervisor.active,
    };
  }
}
