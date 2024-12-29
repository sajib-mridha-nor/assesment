import 'dart:io';
import 'package:dio/dio.dart' as d;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

 
import '../../services/path_provider.dart';
import 'dio_exception.dart';

const _defaultConnectTimeout = Duration(seconds: 15);
const _defaultReceiveTimeout = Duration(seconds: 15);

class DioClient {
  final String baseUrl;
 d. Dio? _dio;
  final List<d.Interceptor>? interceptors;
  DioClient(
    this.baseUrl,
   d. Dio? dio, {
    this.interceptors,
  }) {
    _dio = dio ?? d.Dio();
    _dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = _defaultConnectTimeout as Duration?
      ..options.receiveTimeout = _defaultReceiveTimeout as Duration?
      ..httpClientAdapter
      ..options.headers["authorization"] =
          "Bearer ${GetStorage().read("token")}";
    if (interceptors?.isNotEmpty ?? false) {
      _dio!.interceptors.addAll(interceptors!);
    }

    _dio!.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: HiveCacheStore(AppPathProvider.path),
          policy: CachePolicy.refreshForceCache,
       hitCacheOnErrorExcept: [401],
         
          maxStale: const Duration(
            days: 7,
          ), //increase number of days for loger cache
          priority: CachePriority.high,
        ),
      ),
    );

    if (kDebugMode) {
      _dio!.interceptors.add(d.LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true));
    }
  }
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
   d. Options? options,
   d. CancelToken? cancelToken,
   d. ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    

      return response.data;
    } on d.DioError catch (err) {
    debugPrint  ("catch  ${err.toString()}");  

      final errorMessage = DioExceptions.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
   d. Options? options,
   d. CancelToken? cancelToken,
   d. ProgressCallback? onSendProgress,
   d. ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on d.DioError catch (err) {
      final errorMessage = DioExceptions.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }
}
