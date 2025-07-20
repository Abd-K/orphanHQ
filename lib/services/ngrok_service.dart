import 'dart:async';
import 'dart:convert';
import 'dart:io';

class NgrokService {
  Process? _ngrokProcess;
  String? _tunnelUrl;
  final StreamController<NgrokStatus> _statusController =
      StreamController<NgrokStatus>.broadcast();

  String? get tunnelUrl => _tunnelUrl;
  Stream<NgrokStatus> get statusStream => _statusController.stream;

  Future<NgrokResult> startTunnel(int port) async {
    try {
      print('🚀 Checking for existing ngrok tunnel...');
      _statusController.add(NgrokStatus.starting);

      // First try to get existing tunnel
      final client = HttpClient();
      try {
        final request =
            await client.getUrl(Uri.parse('http://localhost:4040/api/tunnels'));
        final response = await request.close();
        final body = await response.transform(utf8.decoder).join();
        client.close();

        if (response.statusCode == 200) {
          final data = jsonDecode(body);
          if (data['tunnels'] != null && data['tunnels'].isNotEmpty) {
            final tunnel = data['tunnels'][0];
            final tunnelUrl = tunnel['public_url'];

            if (tunnelUrl != null) {
              _tunnelUrl = tunnelUrl;
              _statusController.add(NgrokStatus.connected);
              print('✅ Using existing ngrok tunnel: $_tunnelUrl');
              return NgrokResult.success(tunnelUrl: _tunnelUrl!);
            }
          }
        }
      } catch (e) {
        print('⚠️ Could not connect to existing ngrok tunnel: $e');
      }

      // Fallback: try to start new tunnel (this will likely fail due to sandbox)
      print('🔄 Attempting to start new ngrok tunnel...');
      _ngrokProcess = await Process.start(
        'ngrok',
        ['http', port.toString()],
        runInShell: true,
      );

      // Listen for tunnel URL in output
      final completer = Completer<String>();
      Timer? timeoutTimer;

      // Set timeout for tunnel startup
      timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.completeError('Ngrok startup timeout');
        }
      });

      // Parse ngrok output for tunnel URL
      _ngrokProcess!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        print('Ngrok: $line');

        // Look for the tunnel URL
        if (line.contains('https://') && line.contains('ngrok.io')) {
          final urlMatch =
              RegExp(r'https://[a-zA-Z0-9\-]+\.ngrok\.io').firstMatch(line);
          if (urlMatch != null && !completer.isCompleted) {
            timeoutTimer?.cancel();
            completer.complete(urlMatch.group(0)!);
          }
        }
      });

      // Handle errors
      _ngrokProcess!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        print('Ngrok Error: $line');
      });

      // Wait for tunnel URL or timeout
      try {
        _tunnelUrl = await completer.future;
        _statusController.add(NgrokStatus.connected);
        print('✅ Ngrok tunnel established: $_tunnelUrl');

        return NgrokResult.success(tunnelUrl: _tunnelUrl!);
      } catch (e) {
        await stopTunnel();
        _statusController.add(NgrokStatus.failed);
        print('❌ Ngrok tunnel failed: $e');
        return NgrokResult.failed(error: e.toString());
      }
    } catch (e) {
      _statusController.add(NgrokStatus.failed);
      print('❌ Failed to start ngrok: $e');
      return NgrokResult.failed(error: e.toString());
    }
  }

  Future<void> stopTunnel() async {
    if (_ngrokProcess != null) {
      print('🛑 Stopping ngrok tunnel...');
      _ngrokProcess!.kill();
      await _ngrokProcess!.exitCode;
      _ngrokProcess = null;
      _tunnelUrl = null;
      _statusController.add(NgrokStatus.disconnected);
      print('✅ Ngrok tunnel stopped');
    }
  }

  Future<bool> isNgrokAvailable() async {
    try {
      // First check if ngrok tunnel is already running
      final client = HttpClient();
      try {
        final request =
            await client.getUrl(Uri.parse('http://localhost:4040/api/tunnels'));
        final response = await request.close();
        final body = await response.transform(utf8.decoder).join();
        client.close();

        if (response.statusCode == 200) {
          final data = jsonDecode(body);
          if (data['tunnels'] != null && data['tunnels'].isNotEmpty) {
            print('✅ Found existing ngrok tunnel');
            return true;
          }
        }
      } catch (e) {
        print('⚠️ No existing ngrok tunnel found: $e');
      }

      // Fallback: try to run ngrok command
      final result = await Process.run('ngrok', ['version']);
      if (result.exitCode == 0) {
        print('✅ Ngrok is available');
        return true;
      } else {
        print('❌ Ngrok version check failed: ${result.stderr}');
        return false;
      }
    } catch (e) {
      print('❌ Ngrok not found: $e');
      return false;
    }
  }

  void dispose() {
    stopTunnel();
    _statusController.close();
  }
}

class NgrokResult {
  final bool isSuccess;
  final String? tunnelUrl;
  final String? error;

  NgrokResult._({
    required this.isSuccess,
    this.tunnelUrl,
    this.error,
  });

  factory NgrokResult.success({required String tunnelUrl}) =>
      NgrokResult._(isSuccess: true, tunnelUrl: tunnelUrl);

  factory NgrokResult.failed({required String error}) =>
      NgrokResult._(isSuccess: false, error: error);
}

enum NgrokStatus {
  disconnected,
  starting,
  connected,
  failed,
}

extension NgrokStatusExtension on NgrokStatus {
  String get displayName {
    switch (this) {
      case NgrokStatus.disconnected:
        return 'Disconnected';
      case NgrokStatus.starting:
        return 'Connecting...';
      case NgrokStatus.connected:
        return 'Connected';
      case NgrokStatus.failed:
        return 'Failed';
    }
  }

  bool get isActive => this == NgrokStatus.connected;
}
