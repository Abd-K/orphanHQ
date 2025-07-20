import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../database.dart';

class QRCodeService {
  static const String _qrCodesDir = 'qr_codes';

  /// Generates a QR code for an orphan and saves it to local storage
  static Future<String?> generateAndSaveQRCode(Orphan orphan) async {
    try {
      // Create QR code data
      final qrData = createQRData(orphan);

      // Save to file
      final filePath = await _saveQRCodeData(qrData, orphan.orphanId);

      return filePath;
    } catch (e) {
      print('Error generating QR code for orphan ${orphan.orphanId}: $e');
      return null;
    }
  }

  /// Creates QR code data as JSON string
  static String createQRData(Orphan orphan) {
    final data = {
      'orphan_id': orphan.orphanId,
      'name': {
        'first': orphan.firstName,
        'father': orphan.fatherName,
        'grandfather': orphan.grandfatherName,
        'family': orphan.familyName,
        'full':
            '${orphan.firstName} ${orphan.fatherName} ${orphan.grandfatherName} ${orphan.familyName}'
                .trim(),
      },
      'status': orphan.status.toString().split('.').last,
      'date_of_birth': orphan.dateOfBirth.toIso8601String(),
      'age': DateTime.now().difference(orphan.dateOfBirth).inDays ~/ 365,
      'last_updated': orphan.lastUpdated.toIso8601String(),
      'supervisor_id': orphan.supervisorId,
      'emergency_contact': {
        'supervisor_phone': orphan.currentPhoneNumber,
        'location': orphan.currentCity,
      },
      'qr_generated': DateTime.now().toIso8601String(),
    };

    return jsonEncode(data);
  }

  /// Saves QR code data to local storage
  static Future<String> _saveQRCodeData(String qrData, String orphanId) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final qrCodesDir = Directory(p.join(appDocDir.path, _qrCodesDir));

    if (!await qrCodesDir.exists()) {
      await qrCodesDir.create(recursive: true);
    }

    final fileName = 'qr_${orphanId}.json';
    final filePath = p.join(qrCodesDir.path, fileName);
    final file = File(filePath);

    await file.writeAsString(qrData);

    return filePath;
  }

  /// Retrieves QR code data file for an orphan
  static Future<String?> getQRCodeData(String orphanId) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final qrCodesDir = Directory(p.join(appDocDir.path, _qrCodesDir));
      final fileName = 'qr_${orphanId}.json';
      final filePath = p.join(qrCodesDir.path, fileName);
      final file = File(filePath);

      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      print('Error retrieving QR code data for orphan $orphanId: $e');
      return null;
    }
  }

  /// Deletes QR code file for an orphan
  static Future<bool> deleteQRCodeFile(String orphanId) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final qrCodesDir = Directory(p.join(appDocDir.path, _qrCodesDir));
      final fileName = 'qr_${orphanId}.json';
      final filePath = p.join(qrCodesDir.path, fileName);
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting QR code file for orphan $orphanId: $e');
      return false;
    }
  }

  /// Creates a QR code widget for display
  static Widget createQRCodeWidget(String data, {double size = 300.0}) {
    // Increased from 200.0 to 300.0
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      errorCorrectionLevel: QrErrorCorrectLevel
          .H, // Changed from M to H for better error correction
    );
  }

  /// Decodes QR code data from JSON string
  static Map<String, dynamic>? decodeQRData(String qrData) {
    try {
      return jsonDecode(qrData) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding QR data: $e');
      return null;
    }
  }
}
