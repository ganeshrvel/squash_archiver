import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/network_404_api_error.dart';
import 'package:squash_archiver/common/api_client/interceptors/api_raw_error_message_interceptor.dart';
import 'package:squash_archiver/common/api_client/interceptors/network_404_error_interceptor.dart';
import 'package:squash_archiver/common/exceptions/bad_network_exception.dart';
import 'package:squash_archiver/common/exceptions/dio_exception.dart';
import 'package:squash_archiver/common/exceptions/internal_server_exception.dart';
import 'package:squash_archiver/common/exceptions/network_404_exception.dart';
import 'package:squash_archiver/common/exceptions/user_unauthenticated_exception.dart';
import 'package:squash_archiver/utils/error_handling/handle_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/api_client/api_errors/api_response_error.dart';
import 'package:squash_archiver/common/api_client/api_errors/bad_network_api_error.dart';
import 'package:squash_archiver/common/api_client/api_errors/internal_server_api_error.dart';
import 'package:squash_archiver/common/api_client/api_errors/unauthorized_api_error.dart';
import 'package:squash_archiver/common/api_client/interceptors/api_error_message_interceptor.dart';
import 'package:squash_archiver/common/api_client/interceptors/header_interceptor.dart';
import 'package:squash_archiver/common/api_client/interceptors/bad_network_error_interceptor.dart';
import 'package:squash_archiver/common/api_client/interceptors/internal_server_error_interceptor.dart';
import 'package:squash_archiver/common/api_client/interceptors/unauthorized_interceptor.dart';
import 'package:squash_archiver/common/exceptions/api_error_message_exceptions.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum _allowedDioMethods {
  GET,
  POST,
  PUT,
  DELETE,
}

@lazySingleton
class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = env.config.apiBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30).inMilliseconds;
    dio.options.receiveTimeout = const Duration(seconds: 30).inMilliseconds;

    // maintain the order in which the intercepts are added
    // DONOT change the order of intercepts
    dio.interceptors.add(HeaderInterceptor());
    dio.interceptors.add(Network404Interceptor());

    if (env.config.logApiClient) {
      dio.interceptors.add(ApiRawErrorMessageInterceptor());

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
    dio.interceptors.add(ApiErrorMessageInterceptor());
    dio.interceptors.add(InternalServerErrorInterceptor());
  }

  Future<Response> post(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic> queryParameters,
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
    Map<String, dynamic> queryParameters,
  }) async {
    return _processData(
      _allowedDioMethods.PUT,
      path,
      data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    return _processData(
      _allowedDioMethods.DELETE,
      path,
      null,
      queryParameters: queryParameters,
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic> queryParameters,
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
    Map<String, dynamic> data, {
    Map<String, dynamic> queryParameters,
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
            queryParameters: queryParameters,
          );

        case _allowedDioMethods.GET:
        default:
          return await dio.get(
            path,
            queryParameters: queryParameters,
          );
      }
    } on Network404Error catch (e, stackTrace) {
      _exception = Network404Exception(
        errorMessage: e.errorMessage,
        apiUrl: e.apiUrl,
        stackTrace: stackTrace,
      );
    } on BadNetworkApiError catch (e, stackTrace) {
      _exception = BadNetworkException(
        error: e,
        stackTrace: stackTrace,
      );
    } on InternalServerApiError catch (e, stackTrace) {
      _exception = InternalServerException(
        error: e,
        stackTrace: stackTrace,
      );
    } on UnauthorizedApiError {
      _exception = UserUnauthenticatedException();
    } on ApiResponseError catch (e, stackTrace) {
      _exception = ApiErrorMessageException(
        errorMessage: e.errorMessage,
        stackTrace: stackTrace,
      );
    } on DioError catch (e, stackTrace) {
      _exception = DioException(
        error: e,
        stackTrace: stackTrace,
      );
    }

    handleException(_exception, allowLogging: true, stackTrace: null);

    throw _exception;
  }
}
