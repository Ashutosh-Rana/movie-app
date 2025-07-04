import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'api/api_constant.dart';

@module
abstract class RegisterModule {
  // You can register named preemptive types like follows
  @Named('BaseUrl')
  String get baseUrl => ApiConstant.baseUrl;

  // url here will be injected
  @lazySingleton
  Dio dio(@Named('BaseUrl') String url) => Dio(
    BaseOptions(
      baseUrl: url,
      contentType: Headers.jsonContentType,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ),
  );

  // Providing the directory for the application
  @preResolve
  Future<Directory> applicationDocumentsDirectory() =>
      path_provider.getApplicationDocumentsDirectory();
}
