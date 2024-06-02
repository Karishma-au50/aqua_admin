import 'dart:convert';
import 'package:dio/dio.dart';
import '../../shared/constant/app_constants.dart';
import '../../shared/utils/log.dart';
import '../exceptions/custom_exceptions.dart';

abstract class BaseApiService {
  static final _options = BaseOptions(
    baseUrl: AppConstants.baseUrl,
    // connectTimeout: AppUrl.connectionTimeout,
    // receiveTimeout: AppUrl.receiveTimeout,
    contentType: "application/json",
    responseType: ResponseType.json,
  );

  // dio instance
  final Dio _dio = Dio(_options);

  // GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
     Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio
        .get(
          url,
          queryParameters: queryParameters,
          data:data,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        )
        .catchError(_getDioException);
  }

  // POST request
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio
        .post(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .catchError(_getDioException);
  }

  // PUT request
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio
        .put(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .catchError(_getDioException);
  }

  // DELETE request
  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio
        .delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        )
        .catchError(_getDioException);
  }

  dynamic _getDioException(error) {
    if (error is DioException) {
      Log.error(
          'DIO ERROR: ${error.type} ENDPOINT: ${error.requestOptions.baseUrl} - ${error.requestOptions.path}');
      switch (error.type) {
        case DioExceptionType.cancel:
          throw RequestCancelledException(
              001, 'Something went wrong. Please try again.');
        case DioExceptionType.connectionTimeout:
          throw RequestTimeoutException(
              408, 'Could not connect to the server.');
        case DioExceptionType.connectionError ||
              DioExceptionType.badCertificate:
          throw DefaultException(
              002, 'Something went wrong. Please try again.');
        case DioExceptionType.receiveTimeout:
          throw ReceiveTimeoutException(
              004, 'Could not connect to the server.');
        case DioExceptionType.sendTimeout:
          throw RequestTimeoutException(
              408, 'Could not connect to the server.');
        case DioExceptionType.unknown:
          final errorMessage = error.response?.data['message'];
          switch (error.response?.statusCode) {
            case 400:
              throw CustomException(400, jsonEncode(error.response?.data), "");
            case 403:
              final message = errorMessage ?? '${error.response?.data}';
              throw UnauthorisedException(error.response?.statusCode, message);
            case 401:
              final message = errorMessage ?? '${error.response?.data}';
              throw UnauthorisedException(error.response?.statusCode, message);
            case 404:
              throw NotFoundException(
                  404, errorMessage ?? error.response?.data.toString());
            case 409:
              throw ConflictException(
                  409, 'Something went wrong. Please try again.');
            case 408:
              throw RequestTimeoutException(
                  408, 'Could not connect to the server.');
            case 431:
              throw CustomException(431, jsonEncode(error.response?.data), "");
            case 500:
              throw InternalServerException(
                  500, 'Something went wrong. Please try again.');
            default:
              throw DefaultException(0002,
                  errorMessage ?? 'Something went wrong. Please try again.');
          }
        case DioExceptionType.badResponse:
          throw FetchDataException(
              000, 'Something went wrong. Please try again.');
      }
    } else {
      throw UnexpectedException(000, 'Something went wrong. Please try again.');
    }
  }
}
