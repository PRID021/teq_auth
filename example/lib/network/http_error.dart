import 'package:dio/dio.dart';
import 'package:teq_flutter_core/teq_flutter_core.dart';

class AppHttpError extends HttpError {
  final int? code;
  String message;
  Map? body;

  AppHttpError({this.code, this.message = '', this.body});

  @override
  void handleError(e) {
    String defaultError = 'Server error, please try again!';

    String message = defaultError;
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          message = 'Connect timeout, cannot connect to server!';
          break;
        case DioExceptionType.unknown:
          message = e.error?.toString() ?? defaultError;
          break;
        default:
          break;
      }
      final data = e.response?.data;
      if (data != null && data is Map) {
        if (data.containsKey("message") && data["message"] is String) {
          message = data["message"];
        } else if (data.containsKey("errors") && data["errors"] is String) {
          message = data["errors"];
        }
      }
      throw HttpError(
        code: e.response?.statusCode,
        message: message,
      );
    } else {
      //Sentry.captureException("HttpError: code: 999, message: $message");
      throw HttpError(
        code: 999,
        message: message,
      );
    }
  }
}
