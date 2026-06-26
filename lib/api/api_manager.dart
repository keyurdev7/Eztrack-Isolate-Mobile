import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;
  ApiManager._internal() {
    _initialize();
  }

  late Dio _dio;
  String? _authToken;

  void _initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);

    // Load saved token asynchronously
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('auth_token');
      print('🔑 Auth token loaded: ${_authToken != null ? "Present" : "Not found"}');
    } catch (e) {
      print('❌ Error loading auth token: $e');
    }
  }

  Future<String> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('auth_token');
      print('🔑 Auth token loaded: ${_authToken != null ? "Present" : "Not found"}');
      return _authToken.toString();
    } catch (e) {

      print('❌ Error loading auth token: $e');
      return  "";
    }
  }

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Dio get dio => _dio;
  String? get authToken => _authToken;
}

// Auth Interceptor to add Bearer token to requests
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final apiManager = ApiManager();
    
    // Ensure token is loaded
    if (apiManager.authToken == null) {
      await apiManager._loadAuthToken();
    }
    
    if (apiManager.authToken != null) {
      options.headers[ApiConstants.authorizationHeader] = 
          '${ApiConstants.bearerPrefix}${apiManager.authToken}';
      final token = apiManager.authToken!;
      final displayToken = token.length > 20 ? token.substring(0, 20) : token;
      print('🔑 Bearer token added to request: $displayToken...');
    } else {
      print('⚠️ No auth token available for request');
    }
    
    handler.next(options);
  }
}

// Logging Interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    if (options.data != null) {
      print('Data: ${options.data}');
      log(options.data.toString());
    }
    if (options.queryParameters.isNotEmpty) {
      print('Query Parameters: ${options.queryParameters}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('Data: ${response.data}');
    log(response.data.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Error: ${err.message}');
    if (err.response?.data != null) {
      print('Error Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}

// Error Interceptor to handle common errors
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Connection timeout. Please check your internet connection.',
          type: err.type,
        );
        break;
      case DioExceptionType.badResponse:
        // For 400 validation errors we want to KEEP the original
        // server payload so our errorMessage extractor can read
        // the detailed message (e.g. Velavu Tag ID already assigned).
        if (err.response?.statusCode == 403) {
          err = DioException(
            requestOptions: err.requestOptions,
            error: 'Access forbidden. You don\'t have permission to access this resource.',
            type: err.type,
          );
        } else if (err.response?.statusCode == 404) {
          err = DioException(
            requestOptions: err.requestOptions,
            error: 'Resource not found.',
            type: err.type,
          );
        } else if (err.response?.statusCode == 500) {
          err = DioException(
            requestOptions: err.requestOptions,
            error: 'Internal server error. Please try again later.',
            type: err.type,
          );
        }
        break;
      case DioExceptionType.cancel:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Request was cancelled.',
          type: err.type,
        );
        break;
      case DioExceptionType.connectionError:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'No internet connection. Please check your network.',
          type: err.type,
        );
        break;
      case DioExceptionType.badCertificate:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Certificate error. Please contact support.',
          type: err.type,
        );
        break;
      case DioExceptionType.unknown:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Unknown error occurred. Please try again.',
          type: err.type,
        );
        break;
    }
    handler.next(err);
  }
}

// Extension for easier error handling
extension DioExceptionExtension on DioException {
  String get errorMessage {
    // 1) Prefer server-side validation messages if present
    final data = response?.data;
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

      // If no "errors" map, fall back to message/title if available
      final msg = data['message'];
      if (msg is String && msg.trim().isNotEmpty) {
        return msg.trim();
      }
      final title = data['title'];
      if (title is String && title.trim().isNotEmpty) {
        return title.trim();
      }
    }

    // 2) Fall back to the error string set by interceptors, if any
    if (error is String) {
      return error as String;
    }

    // 3) Final generic fallback
    return 'An unexpected error occurred. Please try again.';
  }
}

