import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:file_picker/file_picker.dart';
import '../services/qr_code_service.dart';
import '../database.dart';

class QRCodeWidget extends StatelessWidget {
  final String orphanId;
  final String qrData;
  final double size;
  final bool showBorder;
  final VoidCallback? onTap;
  final bool showDownloadButton;

  const QRCodeWidget({
    super.key,
    required this.orphanId,
    required this.qrData,
    this.size = 150.0,
    this.showBorder = true,
    this.onTap,
    this.showDownloadButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap ?? () => _showQRCodeDialog(context),
      child: Container(
        width: size,
        height: size,
        decoration: showBorder
            ? BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        )
            : null,
        child: ClipRRect(
          borderRadius:
          showBorder ? BorderRadius.circular(7) : BorderRadius.zero,
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
          ),
        ),
      ),
    );
  }

  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => QRCodeDialog(
        orphanId: orphanId,
        qrData: qrData,
        showDownloadButton: showDownloadButton,
      ),
    );
  }
}

class QRCodeDialog extends StatelessWidget {
  final String orphanId;
  final String qrData;
  final bool showDownloadButton;
  final GlobalKey _qrKey = GlobalKey();

  QRCodeDialog({
    super.key,
    required this.orphanId,
    required this.qrData,
    this.showDownloadButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final qrDataMap = QRCodeService.decodeQRData(qrData);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'QR Code',
                  style: theme.textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RepaintBoundary(
              key: _qrKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 350,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
              ),
            ),
            if (qrDataMap != null) ...[
              const SizedBox(height: 16),
              _buildQRDataInfo(context, qrDataMap),
            ],
            if (showDownloadButton) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _downloadQRCode(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _shareQRCode(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQRDataInfo(
      BuildContext context, Map<String, dynamic> qrDataMap) {
    final theme = Theme.of(context);
    final name = qrDataMap['name'] as Map<String, dynamic>?;
    final fullName = name?['full'] as String? ?? 'Unknown';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QR Code Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Name', fullName),
          if (qrDataMap['status'] != null)
            _buildInfoRow(
                'Status', qrDataMap['status'].toString().toUpperCase()),
          if (qrDataMap['age'] != null)
            _buildInfoRow('Age', '${qrDataMap['age']} years'),
          if (qrDataMap['qr_generated'] != null)
            _buildInfoRow('Generated', _formatDate(qrDataMap['qr_generated'])),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return isoString;
    }
  }

  void _downloadQRCode(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
      _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save QR Code',
        fileName: 'orphan_qr_${orphanId}.png',
        type: FileType.custom,
        allowedExtensions: ['png'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsBytes(pngBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code saved to $outputFile')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Save cancelled')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving QR Code: $e')),
      );
    }
  }

  void _shareQRCode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }
}