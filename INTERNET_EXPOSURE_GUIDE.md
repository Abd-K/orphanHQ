# Exposing Orphan HQ API to the Internet

## 🚀 Quick Demo Solution: ngrok

### 1. Install ngrok
```bash
# macOS with Homebrew
brew install ngrok

# Or download from https://ngrok.com/download
```

### 2. Create free ngrok account
- Go to https://ngrok.com/signup
- Get your authtoken from dashboard

### 3. Configure ngrok
```bash
ngrok config add-authtoken YOUR_AUTHTOKEN_HERE
```

### 4. Start your Flutter app first
```bash
flutter run -d macos
# Wait for: 🚀 API Server running on http://0.0.0.0:45123
```

### 5. Expose to internet
```bash
# In a new terminal window
ngrok http 45123
```

You'll get output like:
```
Session Status                online
Account                      your_email@example.com
Version                      3.x.x
Region                       United States (us)
Latency                      ~50ms
Web Interface                http://127.0.0.1:4040
Forwarding                   https://abc123.ngrok-free.app -> http://localhost:45123
```

### 6. Update Android App
Use the ngrok URL in your Android app:
```kotlin
private val apiService = OrphanApiService.create("https://abc123.ngrok-free.app/")
```

**✅ Pros:**
- Works immediately
- HTTPS included
- Free tier available
- Perfect for demos and testing

**⚠️ Cons:**
- URL changes each restart (unless paid plan)
- Rate limits on free tier
- ngrok dependency

---

## 🏠 Router Port Forwarding (Permanent Solution)

### 1. Find your Mac's local IP
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
# Look for something like: inet 192.168.1.100
```

### 2. Configure Router
- Access router admin (usually 192.168.1.1 or 192.168.0.1)
- Find "Port Forwarding" or "Virtual Servers"
- Add rule:
  - **External Port**: 45123
  - **Internal IP**: 192.168.1.100 (your Mac's IP)
  - **Internal Port**: 45123
  - **Protocol**: TCP

### 3. Find your public IP
```bash
curl ifconfig.me
# Returns your public IP like: 203.0.113.45
```

### 4. Update Android App
```kotlin
private val apiService = OrphanApiService.create("http://203.0.113.45:45123/")
```

**✅ Pros:**
- No third-party dependency
- Always same IP/port
- Full control

**⚠️ Cons:**
- Router configuration needed
- No HTTPS (need additional setup)
- IP may change if not static
- Security considerations

---

## ☁️ Cloud Deployment Options

### Option A: Railway
1. Create account at https://railway.app
2. Deploy Flutter web build or containerized server
3. Get permanent HTTPS URL

### Option B: DigitalOcean App Platform
1. Create droplet or app
2. Deploy your API as container
3. Configure domain/SSL

### Option C: Heroku (Free tier discontinued)
1. Alternative: fly.io or render.com
2. Deploy as Docker container

---

## 🔒 Security Considerations

### For Production Deployment:

#### 1. Add HTTPS
```dart
// For production, serve with HTTPS
// Consider using shelf_ssl or reverse proxy (nginx)
```

#### 2. Improve Authentication
```dart
// Replace simple API key with JWT or OAuth
class AuthService {
  static String generateJWT(String userId) {
    // Implement JWT generation
  }
  
  static bool validateJWT(String token) {
    // Implement JWT validation
  }
}
```

#### 3. Rate Limiting
```dart
// Add to your server
class RateLimiter {
  static final Map<String, int> _requests = {};
  
  static bool isAllowed(String clientIP) {
    // Implement rate limiting logic
    return true;
  }
}
```

#### 4. IP Whitelisting
```dart
// Restrict access to known IPs
static const List<String> allowedIPs = [
  '192.168.1.0/24',  // Local network
  '203.0.113.45',    // Specific public IP
];
```

#### 5. Environment Configuration
```dart
class Config {
  static String get apiKey => Platform.environment['API_KEY'] ?? 'default_key';
  static int get port => int.parse(Platform.environment['PORT'] ?? '45123');
  static bool get isProduction => Platform.environment['ENV'] == 'production';
}
```

---

## 📱 Android Network Security Config

For HTTP connections (development), update your Android app:

### res/xml/network_security_config.xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <!-- For ngrok HTTPS - no config needed -->
    
    <!-- For local IP or public IP HTTP -->
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="false">192.168.1.100</domain>
        <domain includeSubdomains="false">203.0.113.45</domain>
        <domain includeSubdomains="true">ngrok-free.app</domain>
    </domain-config>
</network-security-config>
```

### AndroidManifest.xml
```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ... >
```

---

## 🧪 Testing Your Setup

### 1. Test Local Connection
```bash
curl -H "X-API-Key: orphan_hq_demo_2025" http://localhost:45123/api/status
```

### 2. Test Public Connection
```bash
# With ngrok
curl -H "X-API-Key: orphan_hq_demo_2025" https://abc123.ngrok-free.app/api/status

# With port forwarding
curl -H "X-API-Key: orphan_hq_demo_2025" http://YOUR_PUBLIC_IP:45123/api/status
```

### 3. Test from Android Device
Make sure your Android device can reach the endpoint before implementing in your app.

---

## 🚀 Recommended Approach

**For Demo/Development:**
1. **Use ngrok** - Simplest and most reliable
2. Start Flutter app: `flutter run -d macos`
3. Start ngrok: `ngrok http 45123`
4. Use the HTTPS URL in your Android app

**For Production:**
1. **Deploy to cloud** (Railway, DigitalOcean, etc.)
2. **Add proper authentication** (JWT/OAuth)
3. **Enable HTTPS** with SSL certificates
4. **Implement rate limiting** and security measures

---

## 📞 Support URLs

After starting ngrok, you can also access:
- **ngrok Web Interface**: http://127.0.0.1:4040 (shows request logs, replay, etc.)
- **API Status**: https://your-ngrok-url.ngrok-free.app/api/status?api_key=orphan_hq_demo_2025

This makes debugging API calls from your Android app much easier! 