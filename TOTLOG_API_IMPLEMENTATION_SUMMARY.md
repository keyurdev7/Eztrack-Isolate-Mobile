# TOTLOG API Implementation Summary

## Overview
This document summarizes the implementation of the TOTLOG API endpoints based on the provided JSON specifications for POST and PUT methods.

## Changes Made

### 1. Updated TOTLogRequest Model (`lib/api/models/request_models.dart`)

The `TOTLogRequest` class has been completely updated to match the exact JSON specifications provided:

#### Key Changes:
- **Date Fields**: Added `date` and `startOfWork` as DateTime fields
- **TWR Model**: Updated to use `TWRModelDetailed` with `name`, `numericPart`, `alphabeticPart`, and `text`
- **Man Hours**: Changed from `int` to `double` to support decimal values (0.001)
- **New Fields**: Added all fields from the JSON specifications:
  - `delayDescription`, `workScope`, `timeRequested`, `timeSigned`, `comment`
  - `reasonForRequest`, `equipmentNo`, `hoursDelayed`, `status`
  - `contractor`, `permittingIssue`, `activeStatus`
  - `isArchived` (for PUT method), `id` (for PUT method)

#### Supporting Models Added:
- `TWRModelDetailed`: Detailed TWR model structure
- `TWRPartDetailed`: TWR part with string id and text
- `LookupItemDetailed`: Lookup items with validation fields
- `ApproverDetailed`: Approver with email field
- `EmployeeDetailed`: Employee with email field
- `DelayTypeDetailed`: Delay type with identifier field

### 2. Updated API Service Methods (`lib/api/api_service.dart`)

#### Modified Methods:
- `createTOTLog()`: Now returns `ApiResponse<Map<String, dynamic>>` for raw JSON response
- `updateTOTLog()`: Now returns `ApiResponse<Map<String, dynamic>>` for raw JSON response

Both methods now properly handle the comprehensive JSON structure and return the raw API response.

### 3. Created Usage Examples (`lib/api/totlog_example.dart`)

Comprehensive examples showing:
- How to create a new TOTLOG entry (POST method)
- How to update an existing TOTLOG entry (PUT method)
- How to create minimal TOTLOG entries
- How to handle API responses and errors
- Complete field mapping examples matching the JSON specifications

## API Endpoints

### POST /TOTLOG
Creates a new TOTLOG entry with the comprehensive JSON structure.

**Request Body**: Complete TOTLogRequest object matching the POST JSON specification
**Response**: Raw JSON response from the API

**Key Fields for POST**:
- All fields are optional
- `isArchived` field is NOT included in POST requests
- `id` field is NOT required for POST requests

### PUT /TOTLOG
Updates an existing TOTLOG entry. Requires the `id` field and supports the `isArchived` field.

**Request Body**: Complete TOTLogRequest object with `id` field matching the PUT JSON specification
**Response**: Raw JSON response from the API

**Key Fields for PUT**:
- `id` field is REQUIRED for PUT requests
- `isArchived` field is supported for PUT requests
- `ongoingWorkDelay` field is included in PUT requests
- `manHours` can be decimal (0.001) for PUT requests

## Usage Examples

### Creating a TOTLOG Entry (POST)
```dart
final totLogRequest = TOTLogRequest(
  date: DateTime.now(),
  permitNo: "82169",
  status: "Pending",
  activeStatus: "Active",
  // ... other fields
);

final response = await ApiService().createTOTLog(totLogRequest);
```

### Updating a TOTLOG Entry (PUT)
```dart
final totLogRequest = TOTLogRequest(
  id: 0, // Required for updates
  permitNo: "27176",
  isArchived: true, // Specific to PUT method
  manHours: 0.001, // Decimal value supported
  // ... other fields
);

final response = await ApiService().updateTOTLog(totLogRequest);
```

## Key Differences Between POST and PUT

### POST Method:
- Used for creating new entries
- Does not require `id` field
- Does not support `isArchived` field
- Does not include `ongoingWorkDelay` field
- `manHours` is typically integer (0)

### PUT Method:
- Used for updating existing entries
- Requires `id` field
- Supports `isArchived` field
- Includes `ongoingWorkDelay` field
- `manHours` can be decimal (0.001)

## Error Handling

The API methods return `ApiResponse<Map<String, dynamic>>` objects that include:
- `success`: Boolean indicating if the request was successful
- `data`: Raw response data from the API
- `error`: Error message if the request failed
- `statusCode`: HTTP status code

## Validation

All lookup items include validation fields:
- `isValidationEnabled`: Boolean indicating if validation is enabled
- `errorMessage`: Error message if validation fails
- `name`: Display name of the item
- `id`: Unique identifier

## Files Modified

1. `lib/api/models/request_models.dart` - Updated TOTLogRequest and added new models
2. `lib/api/api_service.dart` - Updated API methods
3. `lib/api/totlog_example.dart` - New comprehensive usage examples
4. `TOTLOG_API_IMPLEMENTATION_SUMMARY.md` - This documentation file

## Notes

1. The implementation exactly matches the provided JSON specifications
2. All new fields are optional, allowing for flexible usage
3. The detailed models provide better type safety and validation
4. Examples are provided for both comprehensive and minimal usage scenarios
5. Error handling follows the existing API service patterns
6. The `manHours` field supports both integer and decimal values as per the specifications
