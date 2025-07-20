import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orphan_hq/services/tunnel_service.dart';

class ConnectionInfoWidget extends StatelessWidget {
  final TunnelResult? tunnelResult;
  final TunnelStatus tunnelStatus;
  final VoidCallback? onRetryTunnel;

  const ConnectionInfoWidget({
    super.key,
    this.tunnelResult,
    required this.tunnelStatus,
    this.onRetryTunnel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildConnectionStatus(),
            if (tunnelResult != null) ...[
              const SizedBox(height: 16),
              _buildConnectionDetails(context),
            ],
            const SizedBox(height: 16),
            _buildInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Override status if we have a working ngrok URL
    bool isWorking =
        tunnelResult?.tunnelUrl?.contains('ngrok-free.app') == true;

    return Row(
      children: [
        Icon(
          isWorking ? Icons.check_circle : Icons.cloud,
          size: 28,
          color: isWorking ? Colors.green : _getStatusColor(),
        ),
        const SizedBox(width: 12),
        Text(
          isWorking ? 'API Server Online' : 'API Server Status',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isWorking ? Colors.green : null,
          ),
        ),
        const Spacer(),
        if (tunnelStatus == TunnelStatus.failed && onRetryTunnel != null)
          TextButton.icon(
            onPressed: onRetryTunnel,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
          ),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    // Override status if we have a working ngrok URL
    bool isWorking =
        tunnelResult?.tunnelUrl?.contains('ngrok-free.app') == true;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWorking
            ? Colors.green.withOpacity(0.1)
            : _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isWorking
                ? Colors.green.withOpacity(0.3)
                : _getStatusColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isWorking ? Colors.green : _getStatusColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWorking ? 'Online & Working' : _getStatusTitle(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isWorking ? Colors.green : _getStatusColor(),
                  ),
                ),
                Text(
                  isWorking
                      ? 'API server is accessible from anywhere via ngrok'
                      : (_getStatusSubtitle() ?? ''),
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

  Widget _buildConnectionDetails(BuildContext context) {
    if (tunnelResult == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tunnelResult!.hasInternetAccess) ...[
          _buildUrlSection(
            context,
            title: '🌐 Internet Access URL',
            url: tunnelResult!.tunnelUrl!,
            subtitle: 'Accessible from anywhere in the world',
            isPrimary: true,
          ),
          const SizedBox(height: 12),
        ],
        _buildUrlSection(
          context,
          title: '🏠 Local Network URL',
          url: tunnelResult!.localUrl,
          subtitle: 'Use this URL from devices on the same WiFi network',
          isPrimary: !tunnelResult!.hasInternetAccess,
        ),
        const SizedBox(height: 16),
        _buildApiKeySection(context),
      ],
    );
  }

  Widget _buildUrlSection(
    BuildContext context, {
    required String title,
    required String url,
    required String subtitle,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPrimary ? Colors.blue.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.blue.shade700 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    url,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _copyToClipboard(context, url),
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copy URL',
                style: IconButton.styleFrom(
                  backgroundColor:
                      isPrimary ? Colors.blue.shade100 : Colors.grey.shade100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeySection(BuildContext context) {
    const apiKey = 'orphan_hq_demo_2025';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.key, color: Colors.orange.shade700, size: 18),
              const SizedBox(width: 8),
              Text(
                'API Key',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Include this in your Android app requests',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    apiKey,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _copyToClipboard(context, apiKey),
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copy API Key',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.green.shade700, size: 18),
              const SizedBox(width: 8),
              Text(
                'Android App Setup',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Copy the URL above\n'
            '2. Paste it into your Android app settings\n'
            '3. Include the API key in your requests\n'
            '4. Start using the API!',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (tunnelStatus) {
      case TunnelStatus.connected:
        return Colors.green;
      case TunnelStatus.starting:
        return Colors.orange;
      case TunnelStatus.failed:
        return Colors.red;
      case TunnelStatus.disconnected:
        return Colors.grey;
    }
  }

  String _getStatusTitle() {
    // Override status if we have a working ngrok URL
    bool isWorking =
        tunnelResult?.tunnelUrl?.contains('ngrok-free.app') == true;

    if (isWorking) {
      return 'Online - Internet Access Available';
    }

    switch (tunnelStatus) {
      case TunnelStatus.connected:
        if (tunnelResult?.hasInternetAccess == true) {
          return 'Online - Internet Access Available';
        } else {
          return 'Online - Local Network Only';
        }
      case TunnelStatus.starting:
        return 'Starting Server...';
      case TunnelStatus.failed:
        return 'Server Started - Local Only';
      case TunnelStatus.disconnected:
        return 'Server Offline';
    }
  }

  String? _getStatusSubtitle() {
    // Override status if we have a working ngrok URL
    bool isWorking =
        tunnelResult?.tunnelUrl?.contains('ngrok-free.app') == true;

    if (isWorking) {
      return 'Your API is accessible from anywhere in the world via ngrok';
    }

    switch (tunnelStatus) {
      case TunnelStatus.connected:
        if (tunnelResult?.hasInternetAccess == true) {
          return 'Your API is accessible from anywhere in the world';
        } else {
          return 'Your API is accessible from your local network';
        }
      case TunnelStatus.starting:
        return 'Setting up internet tunnel...';
      case TunnelStatus.failed:
        return 'Internet tunnel failed, but local access works';
      case TunnelStatus.disconnected:
        return 'Server is not running';
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
