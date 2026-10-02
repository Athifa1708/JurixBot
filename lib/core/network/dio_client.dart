import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'package:flutter/foundation.dart';

// Helper to check if we are on Android without crashing on Web
bool get _isAndroid {
  try {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  } catch (e) {
    return false;
  }
}

class DioClient {
  static String get _baseUrl {
    if (!kDebugMode) return 'https://api.jurixbot.com/api/v1';
    // Use 10.0.2.2 for Android emulator, localhost for Windows/Web/Mac
    if (_isAndroid) return 'http://10.0.2.2:8000/api/v1';
    return 'http://localhost:8000/api/v1';
  }

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
}
