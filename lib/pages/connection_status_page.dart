import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orphan_hq/services/local_api_server.dart';
import 'package:orphan_hq/services/tunnel_service.dart';
import 'package:orphan_hq/widgets/connection_info_widget.dart';

class ConnectionStatusPage extends StatefulWidget {
  const ConnectionStatusPage({super.key});

  @override
  State<ConnectionStatusPage> createState() => _ConnectionStatusPageState();
}

class _ConnectionStatusPageState extends State<ConnectionStatusPage> {
  TunnelResult? _tunnelResult;
  TunnelStatus _tunnelStatus = TunnelStatus.disconnected;

  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
    _listenToTunnelStatus();
  }

  void _checkConnectionStatus() {
    final server = context.read<LocalApiServer>();
    final tunnelService = server.tunnelService;

    setState(() {
      _tunnelResult = TunnelResult.localOnly(
        localUrl:
            'http://localhost:45123', // Will be updated when server provides it
        error: 'Checking status...',
      );
    });
  }

  void _listenToTunnelStatus() {
    final server = context.read<LocalApiServer>();
    final tunnelService = server.tunnelService;

    tunnelService.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _tunnelStatus = status;
        });
      }
    });
  }

  Future<void> _retryTunnel() async {
    final server = context.read<LocalApiServer>();
    final tunnelService = server.tunnelService;

    if (_tunnelResult != null) {
      setState(() {
        _tunnelStatus = TunnelStatus.starting;
      });

      try {
        final result =
            await tunnelService.startTunnel(_tunnelResult!.localUrl, 45123);
        setState(() {
          _tunnelResult = result;
        });
      } catch (e) {
        print('Failed to retry tunnel: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Connection Status'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConnectionInfoWidget(
              tunnelResult: _tunnelResult,
              tunnelStatus: _tunnelStatus,
              onRetryTunnel: _retryTunnel,
            ),

            // Additional helpful information
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Tips for Android Development',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Add INTERNET permission to AndroidManifest.xml\n'
                        '• Include X-API-Key header in all requests\n'
                        '• Use the internet URL for global access\n'
                        '• Use the local URL when on same WiFi network\n'
                        '• Test endpoints with curl or Postman first',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // API endpoint examples
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📋 API Endpoints',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildEndpointExample(
                          'GET', '/api/status', 'Server status'),
                      _buildEndpointExample(
                          'GET', '/api/orphans', 'List all orphans'),
                      _buildEndpointExample(
                          'GET', '/api/orphans/{id}', 'Get orphan details'),
                      _buildEndpointExample(
                          'GET', '/api/supervisors', 'List all supervisors'),
                      _buildEndpointExample('GET', '/api/supervisors/{id}',
                          'Get supervisor details'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndpointExample(
      String method, String endpoint, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: method == 'GET'
                  ? Colors.green.shade100
                  : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              method,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: method == 'GET'
                    ? Colors.green.shade700
                    : Colors.blue.shade700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  endpoint,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
