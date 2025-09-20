import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

/// Service for submitting registration data to the admin system
class RegistrationSubmissionService {
  static const String _baseUrl = 'http://localhost:3000/api'; // Backend API URL
  late final Dio _dio;

  RegistrationSubmissionService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add logging interceptor for development
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  /// Submit service provider registration
  Future<Map<String, dynamic>> submitRegistration({
    required Map<String, dynamic> registrationData,
    Map<String, File>? documents,
  }) async {
    try {
      // Prepare form data for multipart request
      final formData = FormData();

      // Add registration data as JSON
      formData.fields.add(MapEntry(
        'registrationData',
        jsonEncode(_prepareRegistrationData(registrationData)),
      ));

      // Add document files
      if (documents != null) {
        for (final entry in documents.entries) {
          final file = entry.value;
          final fieldName = entry.key;
          
          if (await file.exists()) {
            final fileName = file.path.split('/').last;
            final mimeType = _getMimeType(fileName);
            
            formData.files.add(MapEntry(
              fieldName,
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType.parse(mimeType),
              ),
            ));
          }
        }
      }

      debugPrint('Submitting registration to: $_baseUrl/service-provider/register');
      
      final response = await _dio.post(
        '/service-provider/register',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Registration submitted successfully');
        return {
          'success': true,
          'data': response.data,
          'message': 'Registration submitted successfully',
        };
      } else {
        throw Exception('Registration submission failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioException during registration submission: ${e.message}');
      
      String errorMessage = 'Registration submission failed';
      
      if (e.response != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic> && responseData['message'] != null) {
          errorMessage = responseData['message'];
        } else {
          errorMessage = 'Server error: ${e.response!.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      } else {
        errorMessage = 'Network error. Please check your connection.';
      }

      return {
        'success': false,
        'error': errorMessage,
        'details': e.toString(),
      };
    } catch (e) {
      debugPrint('Unexpected error during registration submission: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
        'details': e.toString(),
      };
    }
  }

  /// Check registration status
  Future<Map<String, dynamic>> checkRegistrationStatus(String registrationId) async {
    try {
      final response = await _dio.get('/service-provider/registration/$registrationId/status');
      
      return {
        'success': true,
        'data': response.data,
      };
    } on DioException catch (e) {
      debugPrint('Error checking registration status: ${e.message}');
      return {
        'success': false,
        'error': 'Failed to check registration status',
        'details': e.toString(),
      };
    }
  }

  /// Update registration with additional information
  Future<Map<String, dynamic>> updateRegistration({
    required String registrationId,
    required Map<String, dynamic> updateData,
    Map<String, File>? additionalDocuments,
  }) async {
    try {
      final formData = FormData();

      // Add update data as JSON
      formData.fields.add(MapEntry(
        'updateData',
        jsonEncode(updateData),
      ));

      // Add additional document files
      if (additionalDocuments != null) {
        for (final entry in additionalDocuments.entries) {
          final file = entry.value;
          final fieldName = entry.key;
          
          if (await file.exists()) {
            final fileName = file.path.split('/').last;
            final mimeType = _getMimeType(fileName);
            
            formData.files.add(MapEntry(
              fieldName,
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType.parse(mimeType),
              ),
            ));
          }
        }
      }

      final response = await _dio.patch(
        '/service-provider/registration/$registrationId',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return {
        'success': true,
        'data': response.data,
        'message': 'Registration updated successfully',
      };
    } on DioException catch (e) {
      debugPrint('Error updating registration: ${e.message}');
      return {
        'success': false,
        'error': 'Failed to update registration',
        'details': e.toString(),
      };
    }
  }

  /// Prepare registration data for submission
  Map<String, dynamic> _prepareRegistrationData(Map<String, dynamic> rawData) {
    return {
      'id': _generateRegistrationId(),
      'email': rawData['email'] ?? '',
      'firstName': rawData['firstName'] ?? '',
      'lastName': rawData['lastName'] ?? '',
      'phoneNumber': rawData['phoneNumber'] ?? '',
      'serviceType': rawData['serviceType'] ?? '',
      'businessName': rawData['businessName'] ?? '',
      'businessDescription': rawData['businessDescription'] ?? '',
      'businessAddress': rawData['businessAddress'] ?? '',
      'county': rawData['county'] ?? '',
      'subCounty': rawData['subCounty'] ?? '',
      'ward': rawData['ward'] ?? '',
      'hasBusinessLicense': rawData['hasBusinessLicense'] ?? false,
      'isRegisteredBusiness': rawData['isRegisteredBusiness'] ?? false,
      'businessLicense': rawData['businessLicense'],
      'taxPin': rawData['taxPin'],
      'status': 'pending',
      'submittedAt': DateTime.now().toIso8601String(),
      'additionalData': {
        'platform': 'service_provider_app',
        'version': '1.0.0',
        'submissionMethod': 'mobile_app',
        ...?rawData['additionalData'],
      },
    };
  }

  /// Generate unique registration ID
  String _generateRegistrationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'SP${timestamp}$random';
  }

  /// Get MIME type for file
  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  /// Test connection to backend
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Connection test failed: $e');
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _dio.close();
  }
}
