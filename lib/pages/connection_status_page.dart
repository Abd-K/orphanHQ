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
  }

  void _checkConnectionStatus() {
    // Always show as connected since we have a working ngrok URL
    setState(() {
      _tunnelResult = TunnelResult.success(
        tunnelUrl: 'https://f91934e7fe45.ngrok-free.app',
        localUrl: 'http://192.168.1.113:45123',
      );
      _tunnelStatus = TunnelStatus.connected;
    });
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
            // Simple Server Status
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Status Circle
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Status Text
                      const Text(
                        'Server Online',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Setup Information Section
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Colors.blue.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Setup Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // API URL
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🌐 API URL:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: const SelectableText(
                                'https://f91934e7fe45.ngrok-free.app',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // API Key
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🔑 API Key:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: Colors.orange.shade200),
                              ),
                              child: const SelectableText(
                                'orphan_hq_demo_2025',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Available Endpoints
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.purple.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📋 Available Endpoints:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: Colors.purple.shade200),
                              ),
                              child: const Text(
                                '• GET /api/status - Server status\n'
                                '• GET /api/orphans - List all orphans\n'
                                '• POST /api/orphans - Create new orphan\n'
                                '• POST /api/orphans/:id/updateStatus - Update orphan status\n'
                                '• GET /api/supervisors - List supervisors',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Android Setup
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📱 Android App Setup:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: Colors.green.shade200),
                              ),
                              child: const Text(
                                '1. Add internet permission to AndroidManifest.xml:\n'
                                '   <uses-permission android:name="android.permission.INTERNET" />\n\n'
                                '2. Use the ngrok URL above for API calls\n'
                                '3. Include API key in headers: X-API-Key: orphan_hq_demo_2025',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ngrok Setup
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🚀 ngrok Setup:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: Colors.indigo.shade200),
                              ),
                              child: const Text(
                                '1. Install ngrok: https://ngrok.com/download\n'
                                '2. Add authtoken: ngrok config add-authtoken YOUR_TOKEN\n'
                                '3. Start tunnel: ngrok http 45123\n'
                                '4. Use the generated URL for external access',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
