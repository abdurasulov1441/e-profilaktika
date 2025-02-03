import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:profilaktika/app/router.dart';
import 'package:profilaktika/common/utils/constants.dart';

import '../../db/cache.dart';
import '../utils/exceptions.dart';

final class RequestHelper {
  final logger = Logger();
  final baseUrl = '${Constants.serverUrl}';
  final dio = Dio();

  void logMethod(String message) {
    log(message);
  }

  String get _token {
    final token = cache.getString('access_token');
    if (token != null) return token;
    throw UnauthorizedException();
  }

  Future<dynamic> get(
    String path, {
    bool log = false,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        baseUrl + path,
        cancelToken: cancelToken,
      );

      if (log) {
        logger.d([
          'GET',
          path,
          response.statusCode,
          response.statusMessage,
          response.data,
        ]);

        logMethod(jsonEncode(response.data));
      }

      response.data['statusCode'] = response.statusCode;
      return response.data;
    } on DioException catch (e, s) {
      logger.d([
        'GET',
        path,
        e.response?.statusCode,
        e.response?.statusMessage,
        e.response?.data,
        s,
      ]);

      if (e.response?.statusCode == 401) {
        await refreshAccessToken();
        throw UnauthorizedException();
      }

      rethrow;
    } catch (e, s) {
      logger.e([e, s]);
      rethrow;
    }
  }

  Future<dynamic> getWithAuth(
    String path, {
    bool log = false,
    CancelToken? cancelToken,
    String? accessToken,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${accessToken ?? _token}',
      };
      final response = await dio.get(
        baseUrl + path,
        cancelToken: cancelToken,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 401 || response.statusCode == 400) {
        print(response.data);

        await refreshAccessToken();
        return getWithAuth(path);
      }
      if (log) {
        logger.d([
          'GET',
          path,
          accessToken,
          _token,
          response.statusCode,
          response.statusMessage,
          response.data,
        ]);

        logMethod(jsonEncode(response.data));
      }

      response.data['statusCode'] = response.statusCode;
      return response.data;
    } on DioException catch (e, s) {
      logger.d([
        'GET',
        path,
        e.response?.statusCode,
        e.response?.statusMessage,
        e.response?.data,
        s,
      ]);

      if (e.response?.statusCode == 401) {
        await refreshAccessToken();
        return getWithAuth(path);
      }

      rethrow;
    } catch (e, s) {
      logger.e([e, s]);
      rethrow;
    }
  }

  Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    bool log = false,
    CancelToken? cancelToken,
  }) async {
    try {
      const headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await dio.post(
        baseUrl + path,
        cancelToken: cancelToken,
        data: body,
        options: Options(
          headers: headers,
        ),
      );

      if (log) {
        logger.d([
          'POST',
          path,
          body,
          response.statusCode,
          response.statusMessage,
          response.data,
        ]);

        logMethod(jsonEncode(response.data));
      }

      response.data['statusCode'] = response.statusCode;
      return response.data;
    } on DioException catch (e, s) {
      logger.d([
        'POST',
        path,
        body,
        e.response?.statusCode,
        e.response?.statusMessage,
        e.response?.data,
        s,
      ]);

      if (e.response?.statusCode == 401) {
        await refreshAccessToken();
        throw UnauthorizedException();
      }

      throw e.response?.data?['response']?['detail'] ??
          e.response?.data?['message'];
    } catch (e, s) {
      logger.e([e, s]);
      rethrow;
    }
  }

  Future<dynamic> postWithAuth(
    String path,
    Map<String, dynamic> body, {
    bool log = false,
    CancelToken? cancelToken,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };

      final response = await dio.post(
        baseUrl + path,
        cancelToken: cancelToken,
        data: body,
        options: Options(
          headers: headers,
        ),
      );

      if (log) {
        logger.d([
          'POST',
          path,
          body,
          response.statusCode,
          response.statusMessage,
          response.data,
        ]);

        logMethod(jsonEncode(response.data));
      }

      response.data['statusCode'] = response.statusCode;
      return response.data;
    } on DioException catch (e, s) {
      logger.d([
        'POST',
        path,
        body,
        e.response?.statusCode,
        e.response?.statusMessage,
        e.response?.data,
        s,
      ]);

      if (e.response?.statusCode == 401) {
        await refreshAccessToken();
        throw UnauthorizedException();
      }

      throw e.response?.data?['message'];
    } catch (e, s) {
      logger.e([e, s]);
      rethrow;
    }
  }

  Future<dynamic> putWithAuth(
    String path,
    Map<String, dynamic> body, {
    bool log = false,
    CancelToken? cancelToken,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };

      final response = await dio.put(
        baseUrl + path,
        cancelToken: cancelToken,
        data: body,
        options: Options(
          headers: headers,
        ),
      );

      if (log) {
        logger.d([
          'PUT',
          path,
          body,
          response.statusCode,
          response.statusMessage,
          response.data,
        ]);

        logMethod(jsonEncode(response.data));
      }

      response.data['statusCode'] = response.statusCode;
      return response.data;
    } on DioException catch (e, s) {
      logger.d([
        'PUT',
        path,
        body,
        e.response?.statusCode,
        e.response?.statusMessage,
        e.response?.data,
        s,
      ]);

      if (e.response?.statusCode == 401) {
        await refreshAccessToken();
        throw UnauthorizedException();
      }

      throw e.response?.data?['message'];
    } catch (e, s) {
      logger.e([e, s]);
      rethrow;
    }
  }

  Future<dynamic> deleteWithAuth(
    String path, {
    bool log = false,
    CancelToken? cancelToken,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };

      final response = await dio.delete(
        baseUrl + path,
        cancelToken: cancelToken,
        options: Options(
          headers: headers,
        ),
      );

      if (log) {
        logger.d([
          'DELETE',
          path,
          response.statusCode,
          response.statusMessage,
          response.data,
        ]);

        logMethod(jsonEncode(response.data));
      }

      response.data['statusCode'] = response.statusCode;
      return response.data;
    } on DioException catch (e, s) {
      logger.d([
        'DELETE',
        path,
        e.response?.statusCode,
        e.response?.statusMessage,
        e.response?.data,
        s,
      ]);

      if (e.response?.statusCode == 401) {
        await refreshAccessToken();
        throw UnauthorizedException();
      }

      throw e.response?.data?['message'] ?? 'Failed to delete resource';
    } catch (e, s) {
      logger.e([e, s]);
      rethrow;
    }
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = cache.getString('refresh_token');

    if (refreshToken == null) {
      router.go(Routes.loginPage);
      throw UnauthorizedException();
    }

    final url = 'http://10.100.26.2:5000/api/auth/refresh-token';

    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };

    final body = json.encode({
      'refreshToken': refreshToken,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        final parsed = json.decode(utf8.decode(response.bodyBytes));

        final String accessToken = parsed['accessToken'];
        await cache.setString('access_token', accessToken);
        await cache.setString('refresh_token', parsed['refreshToken']);
        print(accessToken);
      } else if (response.statusCode == 401) {
        router.go(Routes.loginPage);
        throw UnauthorizedException();
      } else {
        throw Exception('Failed to refresh token: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during token refresh: $error');
      router.go(Routes.loginPage);
      throw UnauthorizedException();
    }
  }
}

final requestHelper = RequestHelper();
