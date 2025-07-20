import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:drift/drift.dart' as drift;
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/services/tunnel_service.dart';
import 'package:orphan_hq/services/network_info_service.dart';
import 'package:orphan_hq/services/ngrok_service.dart';
import 'package:uuid/uuid.dart';

class LocalApiServer {
  HttpServer? _server;
  final OrphanRepository _orphanRepository;
  final SupervisorRepository _supervisorRepository;
  final TunnelService _tunnelService = TunnelService();
  final NgrokService _ngrokService = NgrokService();
  TunnelResult? _tunnelResult;

  // Simple API key for basic security
  static const String _apiKey = 'orphan_hq_demo_2025';
  static const int _port = 45123;

  LocalApiServer({
    required OrphanRepository orphanRepository,
    required SupervisorRepository supervisorRepository,
  })  : _orphanRepository = orphanRepository,
        _supervisorRepository = supervisorRepository;

  TunnelService get tunnelService => _tunnelService;
  TunnelResult? get tunnelResult => _tunnelResult;

  // Manual method to set ngrok URL
  void setManualNgrokUrl(String ngrokUrl) {
    if (ngrokUrl.isNotEmpty) {
      _tunnelResult = TunnelResult.success(
        tunnelUrl: ngrokUrl,
        localUrl: 'http://192.168.1.113:$_port',
      );
      print('✅ Manual ngrok URL set: $ngrokUrl');
    }
  }

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
      print('🌐 Starting internet tunnel...');

      // Manual ngrok integration (since macOS blocks network access)
      print('🌐 Manual ngrok integration...');
      print('📋 If you have ngrok running, use this URL:');
      print('   https://f91934e7fe45.ngrok-free.app');
      print('');
      print('📋 To start ngrok manually:');
      print('   ngrok http 45123');
      print('');

      // Try ngrok first (most reliable for demos)
      if (await _ngrokService.isNgrokAvailable()) {
        print('🚀 Trying ngrok tunnel...');
        final ngrokResult = await _ngrokService.startTunnel(_port);

        if (ngrokResult.isSuccess) {
          _tunnelResult = TunnelResult.success(
            tunnelUrl: ngrokResult.tunnelUrl!,
            localUrl: localUrl,
          );
          print('✅ Ngrok tunnel established: ${_tunnelResult!.tunnelUrl}');
          print('🌍 This URL is accessible from anywhere in the world!');
          print('🔒 HTTPS included automatically!');
        } else {
          print('⚠️ Ngrok failed, trying UPnP: ${ngrokResult.error}');
          _tunnelResult = await _tunnelService.startTunnel(localUrl, _port);
        }
      } else {
        print('⚠️ Ngrok not available, trying UPnP...');
        _tunnelResult = await _tunnelService.startTunnel(localUrl, _port);
      }

      if (_tunnelResult!.hasInternetAccess) {
        print('✅ Internet tunnel established: ${_tunnelResult!.tunnelUrl}');
      } else {
        print('⚠️ Internet tunnel failed, using local-only mode');
        print('   Error: ${_tunnelResult!.error}');
      }

      print('');
      print('Public API endpoints:');
      print('  GET  /api/status          - Server status');
      print('  POST /api/orphans         - Create new orphan');
      print('  POST /api/orphans/:id/updateStatus - Update orphan status');
      print('  GET  /api/supervisors/:id - Get supervisor details');
      print('');
      print('Internal endpoints (hidden from UI):');
      print('  GET  /api/orphans         - List all orphans');
      print('  GET  /api/orphans/:id     - Get orphan details');
      print('  GET  /api/supervisors     - List all supervisors');
      print('');

      return _tunnelResult!;
    } catch (e) {
      print('❌ Failed to start API server: $e');
      rethrow;
    }
  }

  Future<void> stop() async {
    await _tunnelService.stopTunnel();
    await _ngrokService.stopTunnel();
    if (_server != null) {
      await _server!.close();
      _server = null;
      print('🛑 API Server stopped');
    }
  }

  // Authentication middleware
  Middleware get _authMiddleware => (Handler innerHandler) {
        return (Request request) async {
          try {
            // Allow OPTIONS requests for CORS preflight
            if (request.method == 'OPTIONS') {
              print('🔓 CORS preflight request - allowing');
              return innerHandler(request);
            }

            // Check for API key in header or query parameter
            final apiKeyHeader = request.headers['x-api-key'];
            final apiKeyQuery = request.url.queryParameters['api_key'];

            if (apiKeyHeader != _apiKey && apiKeyQuery != _apiKey) {
              print(
                  '❌ Authentication failed for ${request.method} ${request.url.path}');
              print('📝 Provided API key header: ${apiKeyHeader ?? 'none'}');
              print('📝 Provided API key query: ${apiKeyQuery ?? 'none'}');
              print('📝 Expected API key: $_apiKey');

              return Response.unauthorized(
                jsonEncode({
                  'error': 'Unauthorized',
                  'message':
                      'Valid API key required. Include in X-API-Key header or api_key query parameter.'
                }),
                headers: {'content-type': 'application/json'},
              );
            }

            print(
                '✅ Authentication successful for ${request.method} ${request.url.path}');
            return innerHandler(request);
          } catch (e, stackTrace) {
            print('❌ Authentication middleware error: $e');
            print('❌ Stack trace: $stackTrace');

            return Response.internalServerError(
              body: jsonEncode({
                'error': 'Authentication Error',
                'message': 'An error occurred during authentication: $e'
              }),
              headers: {'content-type': 'application/json'},
            );
          }
        };
      };

  // Route handler
  Handler get _router => (Request request) async {
        final path = request.url.path;
        final method = request.method;

        print('🔵 $method $path - Request received');
        print('📝 Headers: ${request.headers}');
        print('📝 Query params: ${request.url.queryParameters}');

        try {
          // API Status endpoint
          if (method == 'GET' && path == 'api/status') {
            print('✅ Routing to status endpoint');
            return _handleStatus(request);
          }

          // Orphans endpoints
          if (method == 'GET' && path == 'api/orphans') {
            print('✅ Routing to get orphans endpoint');
            return _handleGetOrphans(request);
          }

          if (method == 'POST' && path == 'api/orphans') {
            print('✅ Routing to create orphan endpoint');
            return _handleCreateOrphan(request);
          }

          if (method == 'GET' && path.startsWith('api/orphans/')) {
            final orphanId = path.substring('api/orphans/'.length);
            print('✅ Routing to get orphan endpoint with ID: $orphanId');
            return _handleGetOrphan(request, orphanId);
          }

          if (method == 'POST' && path.contains('/updateStatus')) {
            // Extract orphan ID from path like "api/orphans/123/updateStatus"
            final pathParts = path.split('/');
            if (pathParts.length == 4 &&
                pathParts[0] == 'api' &&
                pathParts[1] == 'orphans' &&
                pathParts[3] == 'updateStatus') {
              final orphanId = pathParts[2];
              print(
                  '✅ Routing to update orphan status endpoint with ID: $orphanId');
              return _handleUpdateOrphanStatus(request, orphanId);
            }
          }

          // Supervisors endpoints
          if (method == 'GET' && path == 'api/supervisors') {
            print('✅ Routing to get supervisors endpoint');
            return _handleGetSupervisors(request);
          }

          if (method == 'GET' && path.startsWith('api/supervisors/')) {
            final supervisorId = path.substring('api/supervisors/'.length);
            print(
                '✅ Routing to get supervisor endpoint with ID: $supervisorId');
            return _handleGetSupervisor(request, supervisorId);
          }

          // 404 for unknown endpoints
          print('❌ No route found for $method $path');
          return Response.notFound(
            jsonEncode({
              'error': 'Not Found',
              'message': 'Endpoint not found: $method $path'
            }),
            headers: {'content-type': 'application/json'},
          );
        } catch (e, stackTrace) {
          print('❌ API Error in router: $e');
          print('❌ Request details: $method $path');
          print('❌ Stack trace: $stackTrace');

          return Response.internalServerError(
            body: jsonEncode({
              'error': 'Internal Server Error',
              'message': 'An error occurred while processing your request: $e'
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
        'endpoints': {
          'public': [
            'GET /api/status',
            'POST /api/orphans',
            'POST /api/orphans/:id/updateStatus',
            'GET /api/supervisors/:id',
          ],
          'internal': [
            'GET /api/orphans',
            'GET /api/orphans/:id',
            'GET /api/supervisors',
          ]
        }
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

  // Create new orphan
  Future<Response> _handleCreateOrphan(Request request) async {
    try {
      print('🔵 POST /api/orphans - Request received');

      // Read request body
      final body = await request.readAsString();
      print('📝 Request body: $body');

      if (body.isEmpty) {
        print('❌ Error: Empty request body');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Bad Request',
            'message': 'Request body cannot be empty'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Parse JSON
      Map<String, dynamic> jsonData;
      try {
        jsonData = jsonDecode(body) as Map<String, dynamic>;
        print('✅ JSON parsed successfully');
      } catch (e) {
        print('❌ JSON parsing error: $e');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Invalid JSON',
            'message': 'Request body must be valid JSON: $e'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Validate required fields
      final requiredFields = [
        'first_name',
        'father_name',
        'grandfather_name',
        'family_name',
        'date_of_birth',
        'gender'
      ];

      final missingFields = <String>[];
      for (final field in requiredFields) {
        if (!jsonData.containsKey(field) ||
            jsonData[field] == null ||
            jsonData[field].toString().isEmpty) {
          missingFields.add(field);
        }
      }

      if (missingFields.isNotEmpty) {
        print('❌ Missing required fields: $missingFields');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Validation Error',
            'message': 'Missing required fields: ${missingFields.join(', ')}'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      print('✅ Required fields validation passed');

      // Parse date of birth
      DateTime dateOfBirth;
      try {
        dateOfBirth = DateTime.parse(jsonData['date_of_birth']);
        print('✅ Date of birth parsed: $dateOfBirth');
      } catch (e) {
        print('❌ Date parsing error: $e');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Validation Error',
            'message':
                'Invalid date_of_birth format. Use ISO 8601 format (YYYY-MM-DDTHH:mm:ss.sssZ)'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Parse gender
      Gender gender;
      try {
        gender = Gender.values.firstWhere((g) =>
            g.toString().split('.').last ==
            jsonData['gender'].toString().toLowerCase());
        print('✅ Gender parsed: $gender');
      } catch (e) {
        print('❌ Gender parsing error: $e');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Validation Error',
            'message':
                'Invalid gender. Must be one of: ${Gender.values.map((g) => g.toString().split('.').last).join(', ')}'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Parse status (optional, defaults to active)
      OrphanStatus status = OrphanStatus.active;
      if (jsonData.containsKey('status')) {
        try {
          status = OrphanStatus.values.firstWhere((s) =>
              s.toString().split('.').last ==
              jsonData['status'].toString().toLowerCase());
          print('✅ Status parsed: $status');
        } catch (e) {
          print('❌ Status parsing error: $e');
          return Response.badRequest(
            body: jsonEncode({
              'error': 'Validation Error',
              'message':
                  'Invalid status. Must be one of: ${OrphanStatus.values.map((s) => s.toString().split('.').last).join(', ')}'
            }),
            headers: {'content-type': 'application/json'},
          );
        }
      }

      print('✅ All validation passed, creating orphan data...');

      // Generate UUID for orphan
      final orphanUuid = Uuid().v4();
      print('✅ Generated orphan UUID: $orphanUuid');

      // Create orphan data
      final orphanData = OrphansCompanion(
        orphanId: drift.Value(orphanUuid), // Explicitly set the UUID
        firstName: drift.Value(jsonData['first_name']),
        fatherName: drift.Value(jsonData['father_name']),
        grandfatherName: drift.Value(jsonData['grandfather_name']),
        familyName: drift.Value(jsonData['family_name']),
        dateOfBirth: drift.Value(dateOfBirth),
        gender: drift.Value(gender),
        status: drift.Value(status),
        lastUpdated: drift.Value(DateTime.now()),
        supervisorId: jsonData['supervisor_id'] != null
            ? drift.Value(jsonData['supervisor_id'])
            : const drift.Value.absent(),

        // Father details
        fatherFirstName: jsonData['father']?['name'] != null
            ? drift.Value(jsonData['father']['name'])
            : const drift.Value.absent(),
        fatherDateOfDeath: jsonData['father']?['date_of_death'] != null
            ? drift.Value(DateTime.parse(jsonData['father']['date_of_death']))
            : const drift.Value.absent(),
        fatherCauseOfDeath: jsonData['father']?['cause_of_death'] != null
            ? drift.Value(jsonData['father']['cause_of_death'])
            : const drift.Value.absent(),
        fatherWork: jsonData['father']?['occupation'] != null
            ? drift.Value(jsonData['father']['occupation'])
            : const drift.Value.absent(),

        // Mother details
        motherFirstName: jsonData['mother']?['name'] != null
            ? drift.Value(jsonData['mother']['name'])
            : const drift.Value.absent(),
        motherAlive: jsonData['mother']?['alive'] != null
            ? drift.Value(jsonData['mother']['alive'])
            : const drift.Value.absent(),
        motherDateOfDeath: jsonData['mother']?['date_of_death'] != null
            ? drift.Value(DateTime.parse(jsonData['mother']['date_of_death']))
            : const drift.Value.absent(),
        motherCauseOfDeath: jsonData['mother']?['cause_of_death'] != null
            ? drift.Value(jsonData['mother']['cause_of_death'])
            : const drift.Value.absent(),
        motherWork: jsonData['mother']?['occupation'] != null
            ? drift.Value(jsonData['mother']['occupation'])
            : const drift.Value.absent(),

        // Guardian details
        guardianName: jsonData['guardian']?['name'] != null
            ? drift.Value(jsonData['guardian']['name'])
            : const drift.Value.absent(),
        guardianRelationship: jsonData['guardian']?['relationship'] != null
            ? drift.Value(jsonData['guardian']['relationship'])
            : const drift.Value.absent(),

        // Education
        educationLevel: jsonData['education']?['level'] != null
            ? drift.Value(EducationLevel.values.firstWhere((e) =>
                e.toString().split('.').last ==
                jsonData['education']['level'].toString().toLowerCase()))
            : const drift.Value.absent(),
        schoolName: jsonData['education']?['school_name'] != null
            ? drift.Value(jsonData['education']['school_name'])
            : const drift.Value.absent(),
        grade: jsonData['education']?['grade'] != null
            ? drift.Value(jsonData['education']['grade'])
            : const drift.Value.absent(),

        // Health
        healthStatus: jsonData['health']?['status'] != null
            ? drift.Value(HealthStatus.values.firstWhere((h) =>
                h.toString().split('.').last ==
                jsonData['health']['status'].toString().toLowerCase()))
            : const drift.Value.absent(),
        medicalConditions: jsonData['health']?['medical_conditions'] != null
            ? drift.Value(jsonData['health']['medical_conditions'])
            : const drift.Value.absent(),
        medications: jsonData['health']?['medications'] != null
            ? drift.Value(jsonData['health']['medications'])
            : const drift.Value.absent(),
        needsMedicalSupport:
            jsonData['health']?['needs_medical_support'] != null
                ? drift.Value(jsonData['health']['needs_medical_support'])
                : const drift.Value.absent(),

        // Accommodation
        accommodationType: jsonData['accommodation']?['type'] != null
            ? drift.Value(AccommodationType.values.firstWhere((a) =>
                a.toString().split('.').last ==
                jsonData['accommodation']['type'].toString().toLowerCase()))
            : const drift.Value.absent(),
        accommodationAddress: jsonData['accommodation']?['address'] != null
            ? drift.Value(jsonData['accommodation']['address'])
            : const drift.Value.absent(),
        needsHousingSupport: jsonData['accommodation']
                    ?['needs_housing_support'] !=
                null
            ? drift.Value(jsonData['accommodation']['needs_housing_support'])
            : const drift.Value.absent(),

        // Islamic education
        quranMemorization: jsonData['islamic_education']
                    ?['quran_memorization'] !=
                null
            ? drift.Value(jsonData['islamic_education']['quran_memorization'])
            : const drift.Value.absent(),
        attendsIslamicSchool:
            jsonData['islamic_education']?['attends_islamic_school'] != null
                ? drift.Value(
                    jsonData['islamic_education']['attends_islamic_school'])
                : const drift.Value.absent(),
        islamicEducationLevel: jsonData['islamic_education']?['level'] != null
            ? drift.Value(jsonData['islamic_education']['level'])
            : const drift.Value.absent(),

        // Personal details
        hobbies: jsonData['personal']?['hobbies'] != null
            ? drift.Value(jsonData['personal']['hobbies'])
            : const drift.Value.absent(),
        skills: jsonData['personal']?['skills'] != null
            ? drift.Value(jsonData['personal']['skills'])
            : const drift.Value.absent(),
        aspirations: jsonData['personal']?['aspirations'] != null
            ? drift.Value(jsonData['personal']['aspirations'])
            : const drift.Value.absent(),
        numberOfSiblings: jsonData['personal']?['number_of_siblings'] != null
            ? drift.Value(int.parse(
                jsonData['personal']['number_of_siblings'].toString()))
            : const drift.Value.absent(),
        siblingsDetails: jsonData['personal']?['siblings_details'] != null
            ? drift.Value(jsonData['personal']['siblings_details'])
            : const drift.Value.absent(),

        // Additional info
        additionalNotes: jsonData['additional_notes'] != null
            ? drift.Value(jsonData['additional_notes'])
            : const drift.Value.absent(),
        urgentNeeds: jsonData['urgent_needs'] != null
            ? drift.Value(jsonData['urgent_needs'])
            : const drift.Value.absent(),
        qrCodePath:
            const drift.Value.absent(), // QR code generated after creation
      );

      print('✅ Orphan data created successfully');

      // Insert orphan into database
      try {
        final orphanId = await _orphanRepository.createOrphan(orphanData);
        print('✅ Orphan inserted successfully with ID: $orphanId');

        return Response.ok(
          jsonEncode({
            'success': true,
            'message': 'Orphan created successfully',
            'data': {
              'id': orphanId.toString(),
              'orphan_id': orphanUuid,
              'message': 'Orphan created with database ID: $orphanId',
              'qr_code': 'QR code generated automatically'
            },
          }),
          headers: {'content-type': 'application/json'},
        );
      } catch (e, stackTrace) {
        print('❌ Database insertion error: $e');
        print('❌ Error stack trace: $stackTrace');
        return Response.internalServerError(
          body: jsonEncode({
            'error': 'Database Error',
            'message': 'Failed to create orphan: $e'
          }),
          headers: {'content-type': 'application/json'},
        );
      }
    } catch (e, stackTrace) {
      print('❌ Unexpected error in /api/orphans POST: $e');
      print('❌ Stack trace: $stackTrace');
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Internal Server Error',
          'message': 'An unexpected error occurred: $e'
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Update orphan status
  Future<Response> _handleUpdateOrphanStatus(
      Request request, String orphanId) async {
    try {
      print('🔵 POST /api/orphans/$orphanId/updateStatus - Request received');

      // Read request body
      final body = await request.readAsString();
      print('📝 Request body: $body');

      if (body.isEmpty) {
        print('❌ Error: Empty request body');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Bad Request',
            'message': 'Request body cannot be empty'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Parse JSON
      Map<String, dynamic> jsonData;
      try {
        jsonData = jsonDecode(body) as Map<String, dynamic>;
        print('✅ JSON parsed successfully');
      } catch (e) {
        print('❌ JSON parsing error: $e');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Invalid JSON',
            'message': 'Request body must be valid JSON: $e'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Validate status field
      if (!jsonData.containsKey('status') ||
          jsonData['status'] == null ||
          jsonData['status'].toString().isEmpty) {
        print('❌ Error: Missing status field');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Validation Error',
            'message': 'Missing required field: status'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Parse status
      OrphanStatus status;
      try {
        status = OrphanStatus.values.firstWhere((s) =>
            s.toString().split('.').last ==
            jsonData['status'].toString().toLowerCase());
        print('✅ Status parsed: $status');
      } catch (e) {
        print('❌ Status parsing error: $e');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Validation Error',
            'message':
                'Invalid status. Must be one of: ${OrphanStatus.values.map((s) => s.toString().split('.').last).join(', ')}'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Check if orphan exists
      final orphan = await _orphanRepository.getOrphanById(orphanId);
      if (orphan == null) {
        print('❌ Orphan not found: $orphanId');
        return Response.notFound(
          jsonEncode({
            'error': 'Not Found',
            'message': 'Orphan with ID $orphanId not found'
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Update status
      await _orphanRepository.updateOrphanStatus(orphanId, status);
      print('✅ Orphan with ID $orphanId status updated to: $status');

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Orphan status updated successfully',
          'data': {
            'id': orphan.orphanId,
            'orphan_id': orphan.orphanId,
            'status': status.toString().split('.').last,
            'last_updated': DateTime.now().toIso8601String(),
          },
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e, stackTrace) {
      print('❌ Error updating orphan status: $e');
      print('❌ Stack trace: $stackTrace');
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Internal Server Error',
          'message': 'Failed to update orphan status: $e'
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
      'last_status_update': orphan.lastStatusUpdate?.toIso8601String(),

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

      // Islamic Education
      'islamic_education': {
        'quran_memorization': orphan.quranMemorization,
        'attends_islamic_school': orphan.attendsIslamicSchool,
        'level': orphan.islamicEducationLevel,
      },

      // Personal Development
      'personal': {
        'hobbies': orphan.hobbies,
        'skills': orphan.skills,
        'aspirations': orphan.aspirations,
      },

      // Family
      'family': {
        'number_of_siblings': orphan.numberOfSiblings,
        'siblings_details': orphan.siblingsDetails,
      },

      // Additional Information
      'additional': {
        'notes': orphan.additionalNotes,
        'urgent_needs': orphan.urgentNeeds,
        'special_circumstances': orphan.specialCircumstances,
      },

      // Documents
      'documents': {
        'path': orphan.documentsPath,
      },
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
