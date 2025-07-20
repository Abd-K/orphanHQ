import 'dart:io';

class NetworkInfoService {
  static Future<String?> getLocalIPAddress() async {
    try {
      // Get all network interfaces
      final interfaces = await NetworkInterface.list();

      // Look for WiFi or Ethernet interface
      for (final interface in interfaces) {
        if (interface.name
                .toLowerCase()
                .contains('en') || // macOS/Linux WiFi/Ethernet
            interface.name.toLowerCase().contains('wifi') ||
            interface.name.toLowerCase().contains('ethernet')) {
          for (final addr in interface.addresses) {
            if (addr.type == InternetAddressType.IPv4 &&
                    !addr.isLoopback &&
                    addr.address.startsWith('192.168.') ||
                addr.address.startsWith('10.') ||
                addr.address.startsWith('172.')) {
              return addr.address;
            }
          }
        }
      }

      // Fallback: return any non-loopback IPv4 address
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }

      return null;
    } catch (e) {
      print('Error getting IP address: $e');
      return null;
    }
  }

  static String formatConnectionInfo(String? ipAddress, int port) {
    if (ipAddress == null) {
      return 'Unable to determine IP address.\nPlease check your network connection.';
    }

    return '''
🌐 Server Running!

For Android app connection:
📱 IP Address: $ipAddress
🔌 Port: $port
🔑 API Key: orphan_hq_demo_2025

Full URL: http://$ipAddress:$port

📋 Instructions for Android users:
1. Make sure your Android device is on the same WiFi network
2. Use the IP address above in your Android app settings
3. Include the API key when making requests

⚠️  Both devices must be on the same WiFi network
''';
  }
}
