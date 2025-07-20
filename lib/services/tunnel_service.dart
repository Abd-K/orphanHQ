import 'dart:async';
import 'dart:convert';
import 'dart:io';

class TunnelService {
  Process? _tunnelProcess;
  String? _tunnelUrl;
  String? _localUrl;
  final StreamController<TunnelStatus> _statusController =
      StreamController<TunnelStatus>.broadcast();

  String? get tunnelUrl => _tunnelUrl;
  String? get localUrl => _localUrl;
  Stream<TunnelStatus> get statusStream => _statusController.stream;

  Future<TunnelResult> startTunnel(String localUrl, int port) async {
    _localUrl = localUrl;

    try {
      print('🌐 Starting Cloudflare tunnel...');
      _statusController.add(TunnelStatus.starting);

      // Start cloudflared tunnel
      _tunnelProcess = await Process.start(
        'cloudflared',
        ['tunnel', '--url', 'http://localhost:$port'],
        runInShell: true,
      );

      // Listen for tunnel URL in output
      final completer = Completer<String>();
      Timer? timeoutTimer;

      // Set timeout for tunnel startup
      timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.completeError('Tunnel startup timeout');
        }
      });

      // Parse cloudflared output for tunnel URL
      _tunnelProcess!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        print('Cloudflared: $line');

        // Look for the tunnel URL in various formats
        if (line.contains('trycloudflare.com') ||
            line.contains('.cfargotunnel.com')) {
          final urlMatch = RegExp(
                  r'https://[a-zA-Z0-9\-]+\.(trycloudflare\.com|cfargotunnel\.com)')
              .firstMatch(line);
          if (urlMatch != null && !completer.isCompleted) {
            timeoutTimer?.cancel();
            completer.complete(urlMatch.group(0)!);
          }
        }
      });

      // Handle errors
      _tunnelProcess!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        print('Cloudflared Error: $line');
        if (line.contains('failed') || line.contains('error')) {
          if (!completer.isCompleted) {
            timeoutTimer?.cancel();
            completer.completeError('Tunnel error: $line');
          }
        }
      });

      // Wait for tunnel URL or timeout
      try {
        _tunnelUrl = await completer.future;
        _statusController.add(TunnelStatus.connected);

        print('✅ Tunnel established: $_tunnelUrl');

        return TunnelResult.success(
          tunnelUrl: _tunnelUrl!,
          localUrl: _localUrl!,
        );
      } catch (e) {
        await stopTunnel();
        _statusController.add(TunnelStatus.failed);

        // Fallback to local-only mode
        print('⚠️ Tunnel failed, using local-only mode: $e');
        return TunnelResult.localOnly(
          localUrl: _localUrl!,
          error: e.toString(),
        );
      }
    } catch (e) {
      _statusController.add(TunnelStatus.failed);
      print('❌ Failed to start tunnel: $e');

      return TunnelResult.localOnly(
        localUrl: _localUrl!,
        error: e.toString(),
      );
    }
  }

  Future<void> stopTunnel() async {
    if (_tunnelProcess != null) {
      print('🛑 Stopping tunnel...');
      _tunnelProcess!.kill();
      await _tunnelProcess!.exitCode;
      _tunnelProcess = null;
      _tunnelUrl = null;
      _statusController.add(TunnelStatus.disconnected);
      print('✅ Tunnel stopped');
    }
  }

  Future<bool> isCloudflaredAvailable() async {
    try {
      final result = await Process.run('cloudflared', ['--version']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    stopTunnel();
    _statusController.close();
  }
}

class TunnelResult {
  final bool isSuccess;
  final String? tunnelUrl;
  final String localUrl;
  final String? error;

  TunnelResult._({
    required this.isSuccess,
    this.tunnelUrl,
    required this.localUrl,
    this.error,
  });

  factory TunnelResult.success({
    required String tunnelUrl,
    required String localUrl,
  }) =>
      TunnelResult._(
        isSuccess: true,
        tunnelUrl: tunnelUrl,
        localUrl: localUrl,
      );

  factory TunnelResult.localOnly({
    required String localUrl,
    required String error,
  }) =>
      TunnelResult._(
        isSuccess: false,
        localUrl: localUrl,
        error: error,
      );

  bool get hasInternetAccess => isSuccess && tunnelUrl != null;
  String get primaryUrl => tunnelUrl ?? localUrl;
}

enum TunnelStatus {
  disconnected,
  starting,
  connected,
  failed,
}

extension TunnelStatusExtension on TunnelStatus {
  String get displayName {
    switch (this) {
      case TunnelStatus.disconnected:
        return 'Disconnected';
      case TunnelStatus.starting:
        return 'Connecting...';
      case TunnelStatus.connected:
        return 'Connected';
      case TunnelStatus.failed:
        return 'Failed';
    }
  }

  bool get isActive => this == TunnelStatus.connected;
}
