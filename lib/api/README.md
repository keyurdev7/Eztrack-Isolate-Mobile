# Torrance App API Manager

A comprehensive API manager built with Dio for the Torrance App, providing easy-to-use methods for all API endpoints.

## Features

- ✅ Complete API coverage for all Torrance App endpoints
- ✅ Automatic authentication token management
- ✅ Request/Response models for type safety
- ✅ Error handling with custom interceptors
- ✅ Logging for debugging
- ✅ File upload support for multipart requests
- ✅ Easy-to-use service methods

## Setup

1. **Add Dio dependency** (already added to pubspec.yaml):
   ```yaml
   dependencies:
     dio: ^5.4.0
   ```

2. **Initialize API Manager** in your main.dart:
   ```dart
   import 'package:eztrack_rental/api/api.dart';
   
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     // Initialize API Manager
     ApiManager().initialize();
     
     runApp(MyApp());
   }
   ```

## Usage

### Basic Usage

```dart
import 'package:eztrack_rental/api/api.dart';

// Get API service instance
final apiService = ApiService();

// Example: Login
final loginRequest = LoginRequest(
  email: 'user@example.com',
  password: 'password123',
);

final response = await apiService.login(loginRequest);

if (response.success && response.data != null) {
  // Save auth token
  await ApiManager().setAuthToken(response.data!.token ?? '');
  print('Login successful!');
} else {
  print('Login failed: ${response.error}');
}
```

### Authentication APIs

```dart
// Login with email/password
final loginResponse = await apiService.login(LoginRequest(
  email: 'fjosh@pbf.com',
  password: '2018',
));

// Login with pincode
final pincodeResponse = await apiService.loginUsingPincode(LoginUsingPincodeRequest(
  pincode: '7095',
  deviceId: 'iphone13',
));

// Reset password
final resetResponse = await apiService.resetPassword(ResetPasswordRequest(
  oldPassword: 'oldPassword',
  newPassword: 'newPassword',
));

// Employee signup
final signupResponse = await apiService.employeeSignup(EmployeeSignupRequest(
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@company.com',
  // ... other fields
));
```

### Data Retrieval APIs

```dart
// Get lookup data
final departments = await apiService.getDepartments();
final units = await apiService.getUnits();
final shifts = await apiService.getShifts();
final companies = await apiService.getCompanies();

// Get logs
final totLogs = await apiService.getTOTLogs();
final wrrLogs = await apiService.getWRRLogs();
final overrideLogs = await apiService.getOverrideLogs();
final fcoLogs = await apiService.getFCOLogs();

// Get specific log by ID
final totLog = await apiService.getTOTLogById('123');

// Get notifications
final notifications = await apiService.getPushNotifications();

// Get dashboard data
final charts = await apiService.getTOTCharts();
```

### Create/Update APIs

```dart
// Create TOT Log
final totRequest = TOTLogRequest(
  employeeId: 'EMP001',
  departmentId: 'DEPT001',
  description: 'Sample TOT log',
  status: 'Pending',
);
final createResponse = await apiService.createTOTLog(totRequest);

// Update TOT Log
final updateRequest = TOTLogRequest(
  id: '123',
  employeeId: 'EMP001',
  description: 'Updated description',
  status: 'In Progress',
);
final updateResponse = await apiService.updateTOTLog(updateRequest);
```

### File Upload APIs

```dart
// Create Override Log with file
final overrideRequest = OverrideLogRequest(
  employeeId: 'EMP001',
  description: 'Override with file',
);
final filePath = '/path/to/file.pdf';
final response = await apiService.createOverrideLog(overrideRequest, filePath);

// Create FCO Log with file
final fcoRequest = FCOLogRequest(
  employeeId: 'EMP001',
  description: 'FCO with file',
);
final fcoResponse = await apiService.createFCOLog(fcoRequest, filePath);
```

### Approve/Reject APIs

```dart
// Approve FCO Log
final approveRequest = ApproveRejectRequest(
  comment: 'Approved after review',
  reason: 'All requirements met',
);
final approveResponse = await apiService.approveFCOLog(approveRequest);

// Generic approve/reject
final genericResponse = await apiService.approveReject(
  'TOTLog',  // API endpoint
  '123',     // ID
  'Approved', // Status
  approveRequest,
);
```

## API Structure

```
lib/api/
├── api.dart                    # Main export file
├── api_constants.dart          # API endpoints and constants
├── api_manager.dart           # Dio configuration and interceptors
├── api_service.dart           # All API service methods
├── api_example_usage.dart     # Complete usage examples
└── models/
    ├── request_models.dart    # Request data models
    └── response_models.dart   # Response data models
```

## Error Handling

All API methods return an `ApiResponse<T>` object with:

```dart
class ApiResponse<T> {
  final bool success;        // Whether the request was successful
  final String? message;     // Success message
  final T? data;           // Response data
  final String? error;      // Error message
  final int? statusCode;    // HTTP status code
}
```

Example error handling:

```dart
final response = await apiService.getTOTLogs();

if (response.success) {
  // Handle success
  final logs = response.data;
  print('Loaded ${logs?.length} logs');
} else {
  // Handle error
  print('Error: ${response.error}');
  print('Status Code: ${response.statusCode}');
}
```

## Authentication

The API manager automatically handles authentication tokens:

- Tokens are automatically added to requests via interceptors
- Tokens are saved to SharedPreferences
- Tokens are cleared on 401 errors
- Use `ApiManager().setAuthToken(token)` to set tokens
- Use `ApiManager().clearAuthToken()` to clear tokens

## Complete Example

See `api_example_usage.dart` for comprehensive examples of all API calls, including:

- Authentication flows
- Data retrieval
- CRUD operations
- File uploads
- Approve/reject workflows
- Complete workflow examples

## Testing

You can test the API by using the `ApiExampleWidget`:

```dart
import 'package:eztrack_rental/api/api.dart';

// In your app
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ApiExampleWidget()),
);
```

This provides a UI to test all API endpoints with example data.

## Notes

- All API calls are asynchronous and return `Future<ApiResponse<T>>`
- File uploads use multipart/form-data
- The base URL is configured in `api_constants.dart`
- All endpoints from the Postman collection are implemented
- Request/Response models provide type safety
- Error handling is built-in with custom interceptors

