# Orphan HQ Desktop API Guide

## Overview
Your Flutter desktop app now includes a built-in HTTP server that provides REST API endpoints for your Android app to access orphan and supervisor data.

## Server Details
- **Port**: 45123
- **Protocol**: HTTP
- **Binding**: 0.0.0.0 (accessible from other devices on the same network)
- **Authentication**: API Key required

## Getting Started

### 1. Find Your Desktop IP Address
On macOS, run in terminal:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Look for something like `inet 192.168.1.100` - this is your desktop's IP address.

### 2. API Key
The API key is: `orphan_hq_demo_2025`

Include it in requests either as:
- Header: `X-API-Key: orphan_hq_demo_2025`
- Query parameter: `?api_key=orphan_hq_demo_2025`

## Available Endpoints

### Server Status
```
GET http://YOUR_DESKTOP_IP:45123/api/status
```
Returns server status and available endpoints.

### Orphans
```
GET http://YOUR_DESKTOP_IP:45123/api/orphans
```
Returns all orphans with comprehensive data.

```
GET http://YOUR_DESKTOP_IP:45123/api/orphans/{orphan_id}
```
Returns detailed information for a specific orphan.

### Supervisors
```
GET http://YOUR_DESKTOP_IP:45123/api/supervisors
```
Returns all supervisors.

```
GET http://YOUR_DESKTOP_IP:45123/api/supervisors/{supervisor_id}
```
Returns detailed information for a specific supervisor including assigned orphans.

## Response Format

All successful responses follow this format:
```json
{
  "success": true,
  "count": 10,  // For list endpoints
  "data": {...} // Actual data
}
```

Error responses:
```json
{
  "error": "Error Type",
  "message": "Detailed error message"
}
```

## Sample Orphan Data Structure
```json
{
  "id": "1234567890",
  "name": {
    "first": "Ahmad",
    "father": "Mohammed",
    "grandfather": "Ali",
    "family": "Al-Rashid",
    "full": "Ahmad Mohammed Ali Al-Rashid"
  },
  "gender": "male",
  "date_of_birth": "2010-05-15T00:00:00.000Z",
  "age": 14,
  "status": "active",
  "supervisor_id": "sup_123",
  "last_updated": "2025-01-08T10:30:00.000Z",
  "father": {
    "name": "Mohammed Ali Al-Rashid",
    "date_of_death": "2020-03-10T00:00:00.000Z",
    "cause_of_death": "Illness",
    "occupation": "Teacher"
  },
  "mother": {
    "name": "Fatima Al-Zahra",
    "alive": false,
    "date_of_death": "2021-01-15T00:00:00.000Z",
    "cause_of_death": "Accident",
    "occupation": "Nurse"
  },
  "guardian": {
    "name": "Uncle Ahmad",
    "relationship": "Uncle"
  },
  "education": {
    "level": "primary",
    "school_name": "Al-Noor Primary School",
    "grade": "Grade 8"
  },
  "health": {
    "status": "good",
    "medical_conditions": null,
    "medications": null,
    "needs_medical_support": false
  },
  "accommodation": {
    "type": "family_home",
    "address": "123 Main Street, City",
    "needs_housing_support": false
  },
  "islamic_education": {
    "quran_memorization": "5 Juz",
    "attends_islamic_school": true,
    "level": "Intermediate"
  },
  "personal": {
    "hobbies": "Reading, Soccer",
    "skills": "Math, Arabic",
    "aspirations": "Become a doctor",
    "number_of_siblings": 2,
    "siblings_details": "Sister 12, Brother 8"
  },
  "additional_notes": "Excellent student",
  "urgent_needs": null,
  "has_documents": true
}
```

## Android Implementation Example (Kotlin)

### 1. Add Internet Permission
```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
```

### 2. Network Config (for HTTP in production)
```xml
<!-- android:networkSecurityConfig="@xml/network_security_config" -->
<!-- res/xml/network_security_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="false">192.168.1.100</domain>
    </domain-config>
</network-security-config>
```

### 3. API Service Example
```kotlin
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Path

interface OrphanApiService {
    @GET("api/status")
    suspend fun getStatus(
        @Header("X-API-Key") apiKey: String = "orphan_hq_demo_2025"
    ): Response<ApiResponse<ServerStatus>>
    
    @GET("api/orphans")
    suspend fun getOrphans(
        @Header("X-API-Key") apiKey: String = "orphan_hq_demo_2025"
    ): Response<ApiResponse<List<Orphan>>>
    
    @GET("api/orphans/{id}")
    suspend fun getOrphan(
        @Path("id") orphanId: String,
        @Header("X-API-Key") apiKey: String = "orphan_hq_demo_2025"
    ): Response<ApiResponse<Orphan>>
}

data class ApiResponse<T>(
    val success: Boolean,
    val count: Int? = null,
    val data: T
)
```

### 4. Usage Example
```kotlin
class OrphanRepository {
    private val apiService = OrphanApiService.create("http://192.168.1.100:45123/")
    
    suspend fun fetchOrphans(): List<Orphan>? {
        return try {
            val response = apiService.getOrphans()
            if (response.isSuccessful) {
                response.body()?.data
            } else {
                null
            }
        } catch (e: Exception) {
            Log.e("API", "Failed to fetch orphans", e)
            null
        }
    }
}
```

## Security Notes

⚠️ **For Demo/Development Only**
- This setup uses HTTP (not HTTPS) for simplicity
- API key is hardcoded for demo purposes
- Server binds to 0.0.0.0 (accessible from any device on network)

📋 **For Production Use, Consider:**
- HTTPS with proper SSL certificates
- JWT or OAuth for authentication
- IP whitelisting or VPN
- Rate limiting
- Input validation and sanitization

## Testing

### Using curl
```bash
# Test server status
curl -H "X-API-Key: orphan_hq_demo_2025" http://192.168.1.100:45123/api/status

# Get all orphans
curl -H "X-API-Key: orphan_hq_demo_2025" http://192.168.1.100:45123/api/orphans

# Get specific orphan
curl -H "X-API-Key: orphan_hq_demo_2025" http://192.168.1.100:45123/api/orphans/ORPHAN_ID_HERE
```

### Using Browser
Navigate to: `http://192.168.1.100:45123/api/status?api_key=orphan_hq_demo_2025`

## Troubleshooting

1. **Connection refused**: Ensure desktop app is running and server started successfully
2. **401 Unauthorized**: Check API key is included correctly
3. **Network error**: Verify IP address and that both devices are on same network
4. **Empty data**: Ensure you have orphans/supervisors in your desktop database

## Server Logs

The desktop app console will show:
- Server startup messages
- Request logs
- Error messages

Look for: `🚀 API Server running on http://0.0.0.0:45123` 