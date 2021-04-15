import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/network_404_api_error.dart';
import 'package:squash_archiver/common/api_client/interceptors/network_404_error_interceptor.dart';
import 'package:squash_archiver/common/exceptions/bad_network_exception.dart';
import 'package:squash_archiver/common/exceptions/dio_exception.dart';
import 'package:squash_archiver/common/exceptions/internal_server_exception.dart';
import 'package:squash_archiver/common/exceptions/network_404_exception.dart';
import 'package:squash_archiver/common/exceptions/user_unauthenticated_exception.dart';
import 'package:squash_archiver/utils/error_handling/handle_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/api_client/api_errors/bad_network_api_error.dart';
import 'package:squash_archiver/common/api_client/api_errors/internal_server_api_error.dart';
import 'package:squash_archiver/common/api_client/api_errors/unauthorized_api_error.dart';
import 'package:squash_archiver/common/api_client/interceptors/header_interceptor.dart';
import 'package:squash_archiver/common/api_client/interceptors/bad_network_error_interceptor.dart';
import 'package:squash_archiver/common/api_client/interceptors/internal_server_error_interceptor.dart';
import 'package:squash_archiver/common/api_client/interceptors/unauthorized_interceptor.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:squash_archiver/utils/utils/api.dart';

enum _allowedDioMethods {
  GET,
  POST,
  PUT,
  DELETE,
}

@LazySingleton()
class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = env.config.apiBaseUrl!;
    dio.options.connectTimeout = const Duration(seconds: 30).inMilliseconds;
    dio.options.receiveTimeout = const Duration(seconds: 30).inMilliseconds;

    // maintain the order in which the intercepts are added
    // DONOT change the order of intercepts
    dio.interceptors.add(HeaderInterceptor());
    dio.interceptors.add(Network404Interceptor());

    if (env.config.logApiClient) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ));
    }

    dio.interceptors.add(BadNetworkErrorInterceptor());
    dio.interceptors.add(UnauthorizedInterceptor());
    dio.interceptors.add(InternalServerErrorInterceptor());
  }

  Future<Response> post(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _processData(
      _allowedDioMethods.POST,
      path,
      data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> put(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _processData(
      _allowedDioMethods.PUT,
      path,
      data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> delete(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _processData(
      _allowedDioMethods.DELETE,
      path,
      data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _processData(
      _allowedDioMethods.GET,
      path,
      null,
      queryParameters: queryParameters,
    );
  }

  Future<Response> _processData(
    _allowedDioMethods methodType,
    String path,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Exception _exception;

    try {
      switch (methodType) {
        case _allowedDioMethods.POST:
          return await dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
          );

        case _allowedDioMethods.PUT:
          return await dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
          );

        case _allowedDioMethods.DELETE:
          return await dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
          );

        case _allowedDioMethods.GET:
        default:
          return await dio.get(
            path,
            queryParameters: queryParameters,
          );
      }
    } on Network404Error catch (e) {
      _exception = Network404Exception(
        errorMessage: e.errorMessage,
        apiUrl: e.apiUrl,
        statusCode: e.statusCode,
        stackTrace: StackTrace.current,
      );
    } on BadNetworkApiError catch (e) {
      _exception = BadNetworkException(
        error: e,
        stackTrace: StackTrace.current,
        apiUrl: e.apiUrl,
        statusCode: e.statusCode,
      );
    } on InternalServerApiError catch (e) {
      _exception = InternalServerException(
        error: e,
        errorMessage: e.errorMessage,
        stackTrace: StackTrace.current,
        apiUrl: e.apiUrl,
        statusCode: e.statusCode,
      );
    } on UnauthorizedApiError {
      _exception = UserUnauthenticatedException();
    } on DioError catch (dioError) {
      _exception = DioException(
        error: dioError,
        stackTrace: StackTrace.current,
        apiUrl: getApiUrl(dioError),
        statusCode: dioError.response?.statusCode ?? 0,
      );
    }

    handleException(_exception, allowLogging: true, stackTrace: null);

    throw _exception;
  }
}
