// import 'dart:js_interop';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'api_manager.dart';
import 'api_constants.dart';
import 'models/request_models.dart';
import 'models/response_models.dart';
import 'models/approval_models.dart';
import 'models/lookup_models.dart' as lookup;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final ApiManager _apiManager = ApiManager();
  Dio get _dio => _apiManager.dio;

  /// Get MediaType from file extension
  MediaType _getMediaTypeFromFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'doc':
        return MediaType('application', 'msword');
      case 'docx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case 'xls':
        return MediaType('application', 'vnd.ms-excel');
      case 'xlsx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      case 'txt':
        return MediaType('text', 'plain');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  // ==================== AUTHENTICATION APIs ====================

  /// Login using email and password
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.accountLogin,
        data: request.toJson(),
      );
      return ApiResponse<LoginResponse>(
        success: true,
        data: LoginResponse.fromJson(response.data),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Login using pincode and device ID
  Future<ApiResponse<LoginResponse>> loginUsingPincode(
    LoginUsingPincodeRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.accountLoginUsingPincode,
        queryParameters: {'pincode': request.pincode},
        data: '',
      );

      // Handle the response structure based on the API response format
      if (response.data != null) {
        // Check if the response has the expected structure
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;

          // If the response has 'status' and 'data' fields, parse it directly
          if (responseData.containsKey('status') &&
              responseData.containsKey('data')) {
            final status = responseData['status'];
            final statusCode = status is int ? status : int.tryParse(status?.toString() ?? '200') ?? 200;
            return ApiResponse<LoginResponse>(
              success: statusCode == 200,
              data: LoginResponse.fromJson(responseData),
              statusCode: statusCode,
            );
          } else {
            // If it's a direct data response, wrap it
            return ApiResponse<LoginResponse>(
              success: true,
              data: LoginResponse.fromJson({
                'status': 200,
                'data': responseData,
              }),
              statusCode: response.statusCode,
            );
          }
        }
      }

      // Fallback to original parsing
      return ApiResponse<LoginResponse>(
        success: true,
        data: LoginResponse.fromJson(response.data),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Reset password
  Future<ApiResponse<Map<String, dynamic>>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      final response = await _dio.put(
        ApiConstants.accountResetPassword,
        data: request.toJson(),
      );
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Forgot password - sends reset link to email
  Future<ApiResponse<Map<String, dynamic>>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    try {
      print( ApiConstants.baseUrl +
          ApiConstants.accountForgotPassword);
      final response = await _dio.post(
        ApiConstants.accountForgotPassword,
        data: request.toJson(),
      );

      print(response.statusCode);
      print(response.statusMessage);
      print(response.extra);
      print(response.headers.map);
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Delete account
  Future<ApiResponse<Map<String, dynamic>>> deleteAccount() async {
    try {
      final response = await _dio.delete(ApiConstants.accountDelete);
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }


  /// Get push notifications with pagination
  Future<PaginatedApiResponse<List<NotificationItem>>> getPushNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.notification,
        queryParameters: {
          ApiConstants.typeParam: ApiConstants.pushType,
          'CurrentPage': page,
          'PerPage': perPage,
        },
      );

      // Handle the nested response structure
      if (response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if response has the expected structure
        if (responseData.containsKey('status') &&
            responseData.containsKey('data')) {
          final notificationData = NotificationData.fromJson(
            responseData['data'],
          );
          final items = notificationData.items ?? [];
          final meta = notificationData.meta;

          // Handle status as either String or int
          final status = responseData['status'];
          final isSuccess = status == 200 || status == '200';

          return PaginatedApiResponse<List<NotificationItem>>(
            success: isSuccess,
            data: items,
            meta: meta != null
                ? SubmissionMeta(
                    currentPage: meta.currentPage,
                    perPage: meta.perPage,
                    totalCount: meta.totalCount,
                    pageCount: meta.pageCount,
                  )
                : null,
            statusCode: response.statusCode,
          );
        } else {
          // Fallback for direct list response
          return PaginatedApiResponse<List<NotificationItem>>(
            success: true,
            data: (response.data as List)
                .map((item) => NotificationItem.fromJson(item))
                .toList(),
            statusCode: response.statusCode,
          );
        }
      }

      return PaginatedApiResponse<List<NotificationItem>>(
        success: false,
        data: [],
        error: 'No data received',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return PaginatedApiResponse<List<NotificationItem>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Mark notification as read
  Future<ApiResponse<bool>> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.notification}/$notificationId/read',
      );

      return ApiResponse<bool>(
        success: response.statusCode == 200,
        data: response.statusCode == 200,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<bool>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== SUBMISSIONS APIs ====================

  // ==================== LOOKUP APIs ====================

  /// Get all departments
  Future<ApiResponse<List<lookup.Department>>> getDepartments() async {
    try {
      final response = await _dio.get(ApiConstants.departments);
      final departmentResponse =
          lookup.LookupResponse<lookup.Department>.fromJson(
            response.data,
            (json) => lookup.Department.fromJson(json),
          );

      if (departmentResponse.status == 200 && departmentResponse.data != null) {
        return ApiResponse<List<lookup.Department>>(
          success: true,
          data: departmentResponse.data!.items ?? [],
          statusCode: departmentResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.Department>>(
          success: false,
          error: 'Failed to load departments',
          statusCode: departmentResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.Department>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get all units
  Future<ApiResponse<List<lookup.Unit>>> getUnits() async {
    try {
      final response = await _dio.get(ApiConstants.units);
      final unitResponse = lookup.LookupResponse<lookup.Unit>.fromJson(
        response.data,
        (json) => lookup.Unit.fromJson(json),
      );

      if (unitResponse.status == 200 && unitResponse.data != null) {
        return ApiResponse<List<lookup.Unit>>(
          success: true,
          data: unitResponse.data!.items ?? [],
          statusCode: unitResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.Unit>>(
          success: false,
          error: 'Failed to load units',
          statusCode: unitResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.Unit>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get all approvers
  Future<ApiResponse<List<lookup.Approver>>> getApprovers() async {
    try {
      final response = await _dio.get(ApiConstants.approvers);
      final approverResponse = lookup.LookupResponse<lookup.Approver>.fromJson(
        response.data,
        (json) => lookup.Approver.fromJson(json),
      );

      if (approverResponse.status == 200 && approverResponse.data != null) {
        return ApiResponse<List<lookup.Approver>>(
          success: true,
          data: approverResponse.data!.items ?? [],
          statusCode: approverResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.Approver>>(
          success: false,
          error: 'Failed to load approvers',
          statusCode: approverResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.Approver>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get all shifts
  Future<ApiResponse<List<lookup.Shift>>> getShifts() async {
    try {
      final response = await _dio.get(ApiConstants.shifts);
      final shiftResponse = lookup.LookupResponse<lookup.Shift>.fromJson(
        response.data,
        (json) => lookup.Shift.fromJson(json),
      );

      if (shiftResponse.status == 200 && shiftResponse.data != null) {
        return ApiResponse<List<lookup.Shift>>(
          success: true,
          data: shiftResponse.data!.items ?? [],
          statusCode: shiftResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.Shift>>(
          success: false,
          error: 'Failed to load shifts',
          statusCode: shiftResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.Shift>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get all permit types
  Future<ApiResponse<List<lookup.PermitType>>> getPermitTypes() async {
    try {
      final response = await _dio.get(ApiConstants.permitTypes);
      final permitTypeResponse =
          lookup.LookupResponse<lookup.PermitType>.fromJson(
            response.data,
            (json) => lookup.PermitType.fromJson(json),
          );

      if (permitTypeResponse.status == 200 && permitTypeResponse.data != null) {
        return ApiResponse<List<lookup.PermitType>>(
          success: true,
          data: permitTypeResponse.data!.items ?? [],
          statusCode: permitTypeResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.PermitType>>(
          success: false,
          error: 'Failed to load permit types',
          statusCode: permitTypeResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.PermitType>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get all companies
  Future<ApiResponse<List<lookup.Company>>> getCompanies() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.companies}?${ApiConstants.disablePaginationParam}=${ApiConstants.disablePaginationTrue}',
      );
      final companyResponse = lookup.LookupResponse<lookup.Company>.fromJson(
        response.data,
        (json) => lookup.Company.fromJson(json),
      );

      if (companyResponse.status == 200 && companyResponse.data != null) {
        return ApiResponse<List<lookup.Company>>(
          success: true,
          data: companyResponse.data!.items ?? [],
          statusCode: companyResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.Company>>(
          success: false,
          error: 'Failed to load companies',
          statusCode: companyResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.Company>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get all delay types
  Future<ApiResponse<List<lookup.DelayType>>> getDelayTypes() async {
    try {
      final response = await _dio.get(ApiConstants.delayTypes);
      final delayTypeResponse =
          lookup.LookupResponse<lookup.DelayType>.fromJson(
            response.data,
            (json) => lookup.DelayType.fromJson(json),
          );

      if (delayTypeResponse.status == 200 && delayTypeResponse.data != null) {
        return ApiResponse<List<lookup.DelayType>>(
          success: true,
          data: delayTypeResponse.data!.items ?? [],
          statusCode: delayTypeResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.DelayType>>(
          success: false,
          error: 'Failed to load delay types',
          statusCode: delayTypeResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.DelayType>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get TWR numeric values
  Future<ApiResponse<List<lookup.TWRNumericValue>>>
  getTWRNumericValues() async {
    try {
      final response = await _dio.get(ApiConstants.twrNumericValues);
      final twrResponse =
          lookup.LookupResponse<lookup.TWRNumericValue>.fromJson(
            response.data,
            (json) => lookup.TWRNumericValue.fromJson(json),
          );

      if (twrResponse.status == 200 && twrResponse.data != null) {
        return ApiResponse<List<lookup.TWRNumericValue>>(
          success: true,
          data: twrResponse.data!.items ?? [],
          statusCode: twrResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.TWRNumericValue>>(
          success: false,
          error: 'Failed to load TWR numeric values',
          statusCode: twrResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.TWRNumericValue>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get TWR alphabetic values
  Future<ApiResponse<List<lookup.TWRAlphabeticValue>>>
  getTWRAlphabeticValues() async {
    try {
      final response = await _dio.get(ApiConstants.twrAlphabeticValues);
      final twrResponse =
          lookup.LookupResponse<lookup.TWRAlphabeticValue>.fromJson(
            response.data,
            (json) => lookup.TWRAlphabeticValue.fromJson(json),
          );

      if (twrResponse.status == 200 && twrResponse.data != null) {
        return ApiResponse<List<lookup.TWRAlphabeticValue>>(
          success: true,
          data: twrResponse.data!.items ?? [],
          statusCode: twrResponse.status,
        );
      } else {
        return ApiResponse<List<lookup.TWRAlphabeticValue>>(
          success: false,
          error: 'Failed to load TWR alphabetic values',
          statusCode: twrResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<lookup.TWRAlphabeticValue>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }


  /// Dynamic approve/reject for any API endpoint
  Future<ApiResponse<Map<String, dynamic>>> approveReject(
    String apiUrl,
    String id,
    String status,
    ApproveRejectRequest request,
  ) async {
    try {
      final response = await _dio.put(
        '/$apiUrl/$id/$status',
        data: request.toJson(),
      );
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== SPECIFIC APPROVE/REJECT APIs ====================

  /// Approve TOT Log with comment
  Future<ApiResponse<Map<String, dynamic>>> approveTOTLog(
    int id,
    String comment,
  ) async {
    try {
      final response = await _dio.put(
        '/TOTLog/$id/Approved',
        queryParameters: comment.isNotEmpty ? {'comment': comment} : null,
      );
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Reject TOT Log with comment
  Future<ApiResponse<Map<String, dynamic>>> rejectTOTLog(
    int id,
    String comment,
  ) async {
    try {
      final response = await _dio.put(
        '/TOTLog/$id/Rejected',
        queryParameters: comment.isNotEmpty ? {'comment': comment} : null,
      );
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Approve Override Log with comment
  Future<ApiResponse<Map<String, dynamic>>> approveOverrideLog(
    int id,
    String comment,
  ) async {
    try {
      final response = await _dio.put(
        '/OverrideLog/$id/Approved',
        queryParameters: comment.isNotEmpty ? {'comment': comment} : null,
      );
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Reject Override Log with comment
  Future<ApiResponse<Map<String, dynamic>>> rejectOverrideLog(
    int id,
    String comment,
  ) async {
    try {
      final response = await _dio.put(
        '/OverrideLog/$id/Rejected',
        queryParameters: comment.isNotEmpty ? {'comment': comment} : null,
      );
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Approve WRR Log with comment
  Future<ApiResponse<Map<String, dynamic>>> approveWRRLog(
    int id,
    String comment,
  ) async {
    try {
      final response = await _dio.put(
        '/WRRLog/$id/Approved',
        queryParameters: comment.isNotEmpty ? {'comment': comment} : null,
      );
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Reject WRR Log with comment
  Future<ApiResponse<Map<String, dynamic>>> rejectWRRLog(
    int id,
    String comment,
  ) async {
    try {
      final response = await _dio.put(
        '/WRRLog/$id/Rejected',
        queryParameters: comment.isNotEmpty ? {'comment': comment} : null,
      );
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== FOLDER APIs ====================


  /// Get pending approvals
  Future<ApiResponse<List<ApprovalItem>>> getPendingApprovals() async {
    try {
      final response = await _dio.get(ApiConstants.approval);

      // Parse the response structure
      final approvalResponse = ApprovalResponse.fromJson(response.data);

      if (approvalResponse.status == 200 && approvalResponse.data != null) {
        return ApiResponse<List<ApprovalItem>>(
          success: true,
          data: approvalResponse.data!.items ?? [],
          statusCode: approvalResponse.status,
        );
      } else {
        return ApiResponse<List<ApprovalItem>>(
          success: false,
          error: 'Failed to load pending approvals',
          statusCode: approvalResponse.status,
        );
      }
    } on DioException catch (e) {
      return ApiResponse<List<ApprovalItem>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== OVERRIDE CATEGORIES API ====================

  /// Get override categories
  Future<ApiResponse<List<lookup.OverrideCategory>>>
  getOverrideCategories() async {
    try {
      final response = await _dio.get(ApiConstants.overrideCategories);

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        final items = data['data']['items'] as List<dynamic>;
        final categories = items
            .map((item) => lookup.OverrideCategory.fromJson(item))
            .toList();

        return ApiResponse<List<lookup.OverrideCategory>>(
          data: categories,
          success: true,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<lookup.OverrideCategory>>(
        data: null,
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<lookup.OverrideCategory>>(
        data: null,
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== CRAFT SKILLS API ====================

  /// Get craft skills by company ID
  Future<ApiResponse<List<lookup.CraftSkill>>> getCraftSkillsByCompany(
    int companyId,
  ) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.craftSkills}?Company.Id=$companyId',
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        final items = data['data']['items'] as List<dynamic>;
        final craftSkills = items
            .map((item) => lookup.CraftSkill.fromJson(item))
            .toList();

        return ApiResponse<List<lookup.CraftSkill>>(
          data: craftSkills,
          success: true,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<lookup.CraftSkill>>(
        data: null,
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<lookup.CraftSkill>>(
        data: null,
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== ROD TYPES API ====================

  /// Get rod types
  Future<ApiResponse<List<lookup.RodType>>> getRodTypes() async {
    try {
      final response = await _dio.get(ApiConstants.rodTypes);

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        final items = data['data']['items'] as List<dynamic>;
        final rodTypes = items
            .map((item) => lookup.RodType.fromJson(item))
            .toList();

        return ApiResponse<List<lookup.RodType>>(
          data: rodTypes,
          success: true,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<lookup.RodType>>(
        data: null,
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<lookup.RodType>>(
        data: null,
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== WELD METHODS API ====================

  /// Get weld methods
  Future<ApiResponse<List<lookup.WeldMethod>>> getWeldMethods() async {
    try {
      final response = await _dio.get(ApiConstants.weldMethods);

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        final items = data['data']['items'] as List<dynamic>;
        final weldMethods = items
            .map((item) => lookup.WeldMethod.fromJson(item))
            .toList();

        return ApiResponse<List<lookup.WeldMethod>>(
          data: weldMethods,
          success: true,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<lookup.WeldMethod>>(
        data: null,
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<lookup.WeldMethod>>(
        data: null,
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== LOCATIONS API ====================

  /// Get locations
  Future<ApiResponse<List<lookup.Location>>> getLocations() async {
    try {
      final response = await _dio.get(ApiConstants.locations);

      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        final items = data['data']['items'] as List<dynamic>;
        final locations = items
            .map((item) => lookup.Location.fromJson(item))
            .toList();

        return ApiResponse<List<lookup.Location>>(
          data: locations,
          success: true,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<lookup.Location>>(
        data: null,
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<lookup.Location>>(
        data: null,
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }


  // ==================== TRACKING APIs ====================

  /// Get tracking devices
  /// [filters] Optional filter parameters. If null, returns all devices.
  Future<ApiResponse<TrackingResponse>> getTrackingDevices({TrackingFilterParams? filters}) async {
    try {
      final queryParams = filters?.toQueryParams() ?? {};
      final response = await _dio.get(
        ApiConstants.trackingGet,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      
      if (response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        return ApiResponse<TrackingResponse>(
          success: responseData['status'] == 200,
          data: TrackingResponse.fromJson(responseData),
          statusCode: responseData['status'] ?? response.statusCode,
        );
      }
      
      return ApiResponse<TrackingResponse>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<TrackingResponse>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get tracking history by device ID
  Future<ApiResponse<TrackingHistoryResponse>> getTrackingHistory(int deviceId) async {
    try {
      final response = await _dio.get('${ApiConstants.trackingHistory}/$deviceId');
      
      if (response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        return ApiResponse<TrackingHistoryResponse>(
          success: responseData['status'] == 200,
          data: TrackingHistoryResponse.fromJson(responseData),
          statusCode: responseData['status'] ?? response.statusCode,
        );
      }
      
      return ApiResponse<TrackingHistoryResponse>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<TrackingHistoryResponse>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get tracking dashboard statistics
  Future<ApiResponse<TrackingDashboardStats>> getTrackingDashboardStats() async {
    try {
      final response = await _dio.get(ApiConstants.trackingDashboardStats);
      
      if (response.data != null && response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        final dynamic statusValue = responseData['status'] ?? responseData['Status'] ?? response.statusCode;
        final int status =
            statusValue is int ? statusValue : int.tryParse(statusValue?.toString() ?? '') ?? response.statusCode ?? 200;

        final dynamic dataJson = responseData['data'] ?? responseData['Data'];
        if (dataJson is Map<String, dynamic>) {
          final stats = TrackingDashboardStats.fromJson(dataJson);
          return ApiResponse<TrackingDashboardStats>(
            success: status == 200,
            data: stats,
            statusCode: status,
          );
        }

        return ApiResponse<TrackingDashboardStats>(
          success: false,
          error: 'Invalid response format',
          statusCode: status,
        );
      }

      return ApiResponse<TrackingDashboardStats>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<TrackingDashboardStats>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get map data for tracking devices
  Future<ApiResponse<List<MapDevice>>> getMapData() async {
    try {
      final response = await _dio.get(ApiConstants.trackingGetMapData);
      
      if (response.data != null) {
        List<MapDevice> mapDevices = [];
        
        if (response.data is List) {
          mapDevices = (response.data as List)
              .map((item) => MapDevice.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final dynamic dataJson = responseData['data'] ?? responseData['Data'];
          if (dataJson is List) {
            mapDevices = (dataJson as List)
                .map((item) => MapDevice.fromJson(item as Map<String, dynamic>))
                .toList();
          }
        }
        
        return ApiResponse<List<MapDevice>>(
          success: response.statusCode == 200,
          data: mapDevices,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<MapDevice>>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<MapDevice>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Update tracking device using PUT with multipart/form-data
  Future<ApiResponse<Map<String, dynamic>>> updateTrackingDevice(
    TrackingUpdateRequest request,
  ) async {
    try {
      final formDataMap = request.toFormData();
      print('📤 Tracking PUT Request Data:');
      print('  - ConditionId: ${request.conditionId}');
      print('  - FormData fields: $formDataMap');
      final formData = FormData.fromMap(formDataMap);
      
      // Add photo file if present
      if (request.photo != null) {
        final file = request.photo!;
        final fileName = file.path.split('/').last;
        final contentType = _getMediaTypeFromFile(file);
        
        formData.files.add(
          MapEntry(
            'Photo',
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
              contentType: contentType,
            ),
          ),
        );
      }
      
      final response = await _dio.put(
        ApiConstants.trackingPut,
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 120), // 2 minutes for file uploads
          sendTimeout: const Duration(seconds: 120),
        ),
      );
      
      return ApiResponse<Map<String, dynamic>>(
        success: response.statusCode == 200 || response.statusCode == 204,
        data: response.data is Map<String, dynamic> 
            ? response.data as Map<String, dynamic>
            : {'status': response.statusCode},
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: _extractServerErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Return tracking device using POST with multipart/form-data
  Future<ApiResponse<Map<String, dynamic>>> returnTrackingDevice(
    int deviceId,
    TrackingReturnRequest request,
  ) async {
    try {
      final formData = FormData.fromMap(request.toFormData());
      
      // Add multiple photo files if present
      if (request.photos != null && request.photos!.isNotEmpty) {
        for (var file in request.photos!) {
          final fileName = file.path.split('/').last;
          final contentType = _getMediaTypeFromFile(file);
          
          formData.files.add(
            MapEntry(
              'Photos',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: contentType,
              ),
            ),
          );
        }
      }
      print(formData);
      final response = await _dio.post(
        '${ApiConstants.trackingReturn}/$deviceId',
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 120), // 2 minutes for file uploads
          sendTimeout: const Duration(seconds: 120),
        ),
      );
      
      return ApiResponse<Map<String, dynamic>>(
        success: response.statusCode == 200 || response.statusCode == 201,
        data: response.data is Map<String, dynamic> 
            ? response.data as Map<String, dynamic>
            : {'status': response.statusCode},
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Assign tracking device using POST with multipart/form-data
  Future<ApiResponse<Map<String, dynamic>>> assignTrackingDevice(
    int deviceId,
    TrackingAssignRequest request,
  ) async {
    try {
      final formData = FormData.fromMap(request.toFormData());
      
      // Add multiple photo files if present
      if (request.photos != null && request.photos!.isNotEmpty) {
        for (var file in request.photos!) {
          final fileName = file.path.split('/').last;
          final contentType = _getMediaTypeFromFile(file);
          
          formData.files.add(
            MapEntry(
              'Photos',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: contentType,
              ),
            ),
          );
        }
      }
      print(formData.fields);
      formData.fields.map((b){return print(b);});

      final response = await _dio.post(
        '${ApiConstants.trackingAssign}/$deviceId',
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 120), // 2 minutes for file uploads
          sendTimeout: const Duration(seconds: 120),
        ),
      );
      
      return ApiResponse<Map<String, dynamic>>(
        success: response.statusCode == 200 || response.statusCode == 201,
        data: response.data is Map<String, dynamic> 
            ? response.data as Map<String, dynamic>
            : {'status': response.statusCode},
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Create tracking using POST with multipart/form-data
  Future<ApiResponse<Map<String, dynamic>>> createTracking(
    TrackingCreateRequest request,
  ) async {
    try {
      final formDataMap = request.toFormData();
      print('📤 Tracking POST Request Data:');
      print('  - ConditionId: ${request.conditionId}');
      print('  - FormData fields: $formDataMap');
      final formData = FormData.fromMap(formDataMap);
      
      // Add photo file if present
      if (request.photo != null) {
        final file = request.photo!;
        final fileName = file.path.split('/').last;
        final contentType = _getMediaTypeFromFile(file);
        
        formData.files.add(
          MapEntry(
            'Photo',
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
              contentType: contentType,
            ),
          ),
        );
      }
     print(formData);
      print(formData.fields);
       print(formData.files);
      final response = await _dio.post(
        ApiConstants.trackingPost,
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 120), // 2 minutes for file uploads
          sendTimeout: const Duration(seconds: 120),
        ),
      );
      
      return ApiResponse<Map<String, dynamic>>(
        success: response.statusCode == 200 || response.statusCode == 201,
        data: response.data is Map<String, dynamic> 
            ? response.data as Map<String, dynamic>
            : {'status': response.statusCode},

        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: _extractServerErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Extract a human‑friendly error message from server validation responses.
  /// Example server payload:
  /// {
  ///   "errors": {
  ///     "TagMaster.Id": [
  ///       "This Velavu Tag ID is already assigned to another tracking device."
  ///     ]
  ///   },
  ///   "title": "One or more validation errors occurred.",
  ///   "status": 400
  /// }
  ///
  /// For such payloads we want to surface only the inner message
  /// (e.g. "This Velavu Tag ID is already assigned to another tracking device.")
  /// and hide the dynamic key like "TagMaster.Id".
  String _extractServerErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final errors = data['errors'];

      if (errors is Map) {
        for (final value in errors.values) {
          // Most ASP.NET-style validation errors are a list of strings
          if (value is List && value.isNotEmpty) {
            final first = value.first;
            if (first is String && first.trim().isNotEmpty) {
              return first.trim();
            }
          }
          // Fallback if a single string was provided
          if (value is String && value.trim().isNotEmpty) {
            return value.trim();
          }
        }
      }

      // If there is no "errors" map but a message/title, try to use that
      if (data['message'] is String && (data['message'] as String).trim().isNotEmpty) {
        return (data['message'] as String).trim();
      }
      if (data['title'] is String && (data['title'] as String).trim().isNotEmpty) {
        return (data['title'] as String).trim();
      }
    }

    // Fallback to the generic Dio error message extension
    return e.errorMessage;
  }

  /// Get manufacturers
  Future<ApiResponse<List<DropdownItem>>> getManufacturers() async {
    try {
      final response = await _dio.get(ApiConstants.manufacturerGet);
      if (response.data is List) {
        final data = (response.data as List)
            .map((item) => DropdownItem.fromJson(item))
            .toList();
        return ApiResponse<List<DropdownItem>>(
          success: true,
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get conditions
  Future<ApiResponse<List<DropdownItem>>> getConditions() async {
    try {
      final response = await _dio.get(ApiConstants.conditionGet);
      print('🔍 Conditions API Response Type: ${response.data.runtimeType}');
      print('🔍 Conditions API Response Data: ${response.data}');
      
      if (response.data is List) {
        final data = (response.data as List)
            .map((item) {
              print('🔍 Parsing condition item: $item');
              return DropdownItem.fromJson(item);
            })
            .toList();
        print('✅ Successfully parsed ${data.length} conditions');
        return ApiResponse<List<DropdownItem>>(
          success: true,
          data: data,
          statusCode: response.statusCode,
        );
      }
      print('❌ Conditions response is not a List. Type: ${response.data.runtimeType}');
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: 'Invalid response format: Expected List, got ${response.data.runtimeType}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      print('❌ DioException in getConditions: ${e.message}');
      print('❌ Error type: ${e.type}');
      print('❌ Response data: ${e.response?.data}');
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      print('❌ Unexpected error in getConditions: $e');
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: 'Unexpected error: $e',
        statusCode: null,
      );
    }
  }

  /// Get suppliers
  Future<ApiResponse<List<DropdownItem>>> getSuppliers() async {
    try {
      final response = await _dio.get(ApiConstants.supplierGet);
      if (response.data is List) {
        final data = (response.data as List)
            .map((item) => DropdownItem.fromJson(item))
            .toList();
        return ApiResponse<List<DropdownItem>>(
          success: true,
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get equipment
  Future<ApiResponse<List<DropdownItem>>> getEquipment() async {
    try {
      final response = await _dio.get(ApiConstants.equipmentGet);
      if (response.data is List) {
        final data = (response.data as List)
            .map((item) => DropdownItem.fromJson(item))
            .toList();
        return ApiResponse<List<DropdownItem>>(
          success: true,
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get equipment descriptions
  Future<ApiResponse<List<DropdownItem>>> getEquipmentDescriptions() async {
    try {
      final response = await _dio.get(ApiConstants.equipmentDescriptionGet);
      if (response.data is List) {
        final data = (response.data as List)
            .map((item) => DropdownItem.fromJson(item))
            .toList();
        return ApiResponse<List<DropdownItem>>(
          success: true,
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get tag masters (Velavu Tag IDs)
  Future<ApiResponse<List<DropdownItem>>> getTagMasters() async {
    try {
      final response = await _dio.get(ApiConstants.tagMasterGet);
      if (response.data is List) {
        final data = (response.data as List)
            .map((item) => DropdownItem.fromJson(item))
            .toList();
        return ApiResponse<List<DropdownItem>>(
          success: true,
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: 'Invalid response format',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<List<DropdownItem>>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get company information
  Future<ApiResponse<Select2Response>> getCompanyInformation() async {
    try {
      final response = await _dio.get(ApiConstants.trackingCompanyInformation);
      return ApiResponse<Select2Response>(
        success: true,
        data: Select2Response.fromJson(response.data),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Select2Response>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get company contacts
  Future<ApiResponse<Select2Response>> getCompanyContacts(int companyId) async {
    try {
      final response = await _dio.get(
        ApiConstants.trackingGetCompanyContacts,
        queryParameters: {'companyId': companyId},
      );
      return ApiResponse<Select2Response>(
        success: true,
        data: Select2Response.fromJson(response.data),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<Select2Response>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ==================== UPDATE STATUS API ====================

  /// Check update status
  Future<ApiResponse<UpdateStatusResponse>> checkUpdateStatus() async {
    try {
      final response = await _dio.get(ApiConstants.updateStatus);
      
      // Handle the response structure based on the API response format
      if (response.data != null && response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        
        // If the response has 'status' and 'data' fields, parse it directly
        if (responseData.containsKey('status') && responseData.containsKey('data')) {
          return ApiResponse<UpdateStatusResponse>(
            success: responseData['status'] == 200,
            data: UpdateStatusResponse.fromJson(responseData),
            statusCode: responseData['status'],
          );
        }
      }
      
      // Fallback to original parsing
      return ApiResponse<UpdateStatusResponse>(
        success: true,
        data: UpdateStatusResponse.fromJson(response.data),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse<UpdateStatusResponse>(
        success: false,
        error: e.errorMessage,
        statusCode: e.response?.statusCode,
      );
    }
  }
}
