import 'package:dio/dio.dart';
import 'package:teq_flutter_core/teq_flutter_core.dart';

import 'network/http_error.dart';
import 'network/http_interceptor.dart';

class Configs {


  static configNetwork() async {
    TeqNetwork.init(
      interceptors: [HttpInterceptor()],
      httpError: AppHttpError(),
      options: BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        baseUrl: DefaultBaseUrl().getUrl(),
      ),
      //    pemFilePath: DefaultBaseUrl().getPemFilePath
    );
  }
}

class DefaultBaseUrl extends BaseUrl {
  @override
  String dev() => 'http://api.offwork.local.exelab.asia/v1';

  @override
  String stg() => 'http://api.ow.teqn.asia/v1';

  @override
  String prod() => 'https://api.offwork.executionlab.asia/v1';

  @override
  String? get getPemFilePath =>
      currentEnvironment == Environment.PROD ? 'asset/offwork.pem' : null;
}
