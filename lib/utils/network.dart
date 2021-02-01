import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  // Singleton
  static Network _instance = new Network.internal();
  Network.internal();
  factory Network() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, {Map headers}) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = Utf8Decoder().convert(response.bodyBytes);
      final int statusCode = response.statusCode;
      final bool intercepted = _interceptor(statusCode);
      if (!intercepted) {
        if (statusCode < 100 || statusCode == 400 || statusCode > 401) {
          throw new Exception(_decoder.convert(res));
        }
        return _decoder.convert(res);
      }
    }).catchError((onError) {
      return '{}';
    });
  }

  Future<void> delete(String url, {Map headers}) {
    return http.delete(url, headers: headers).then((http.Response response) {
      final String res = Utf8Decoder().convert(response.bodyBytes);
      final int statusCode = response.statusCode;
      final bool intercepted = _interceptor(statusCode);
      if (!intercepted){
        if (statusCode < 100 || statusCode == 400 || statusCode > 401) {
          throw new Exception(_decoder.convert(res));
        }
        return _decoder.convert(res);
      }
    }).catchError((onError) {
      return '{}';
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http.post(url, body: body, headers: headers, encoding: encoding).then((http.Response response) {
      final String res = Utf8Decoder().convert(response.bodyBytes);
      final int statusCode = response.statusCode;
      final bool intercepted = _interceptor(statusCode);
      if (!intercepted){
        if (statusCode < 100 || statusCode == 400 || statusCode > 401) {
          throw new Exception(_decoder.convert(res));
        }
        return _decoder.convert(res);
      }
    }).catchError((onError) {
      return '{}';
    });
  }

  bool _interceptor(int statusCode) {
    if (statusCode == 401) {
      return true;
    } else {
      return false;
    }
  }
}