import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioExceptions implements Exception {
  late String errorMessage;

  DioExceptions.fromDioError(DioException dioError) {
    debugPrint  ("_handleStatus f ${dioError.toString()}");  

    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorMessage = 'Request to the server was cancelled.';
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timed out.';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receiving timeout occurred.';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Request send timeout.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(dioError.response?.statusCode, dioError.response?.data);
        break;
      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          errorMessage = 'No Internet.';
        } else {
          errorMessage = 'Unexpected error occurred.';
        }
        break;
      default:
        errorMessage = 'Something went wrong';
        break;
    }
  }

  String _handleStatusCode(int? statusCode, dynamic data) {
    
    switch (statusCode) {

      case 400:
        return data?['message']?.toString() ?? 'Bad request.';
      case 401:
        return data?['message'] ?? 'Authentication failed.';
      case 403:
        return data?['message'] ?? 'The authenticated user is not allowed to access the specified API endpoint.';
      case 404:
        return 'Not found';
      case 405:
        return data?['message'] ?? 'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
      case 415:
        return data?['message'] ?? 'Unsupported media type. The requested content type or version number is invalid.';
      case 422:
        return data?['message'] ?? 'Data validation failed.';
      case 429:
        return data?['message'] ?? 'Too many requests.';
      case 500:
        return data?['message'] ?? 'Internal server error.';
      default:
        return 'Oops, something went wrong!';
    }
  }

  @override
  String toString() => errorMessage;
}
