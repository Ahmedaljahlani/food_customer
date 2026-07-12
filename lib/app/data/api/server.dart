// ignore_for_file: depend_on_referenced_packages, prefer_collection_literals, prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../util/api-list.dart';

class Server {
  static String? bearerToken;

  static initClass({String? token}) {
    final box = GetStorage();
    return bearerToken = box.read('token');
  }

  void _logRequest({
    required String method,
    required String? url,
    Map<String, String>? headers,
    String? body,
  }) {
    print('╔══════════════════════════════════════════════════════════');
    print('║  [API REQUEST] $method');
    print('╠══════════════════════════════════════════════════════════');
    print('║  URL     : $url');
    print('║  Headers : $headers');
    if (body != null) {
      print('║  Body    : $body');
    }
    print('╚══════════════════════════════════════════════════════════');
  }

  void _logResponse({
    required String method,
    required String? url,
    dynamic response,
  }) {
    print('╔══════════════════════════════════════════════════════════');
    print('║  [API RESPONSE] $method');
    print('╠══════════════════════════════════════════════════════════');
    print('║  URL     : $url');
    if (response == null) {
      print('║  STATUS  : NULL / ERROR');
    } else if (response is http.Response) {
      print('║  STATUS  : ${response.statusCode}');
      print('║  BODY    : ${response.body}');
    } else if (response is http.StreamedResponse) {
      print('║  STATUS  : ${response.statusCode}');
      print('║  BODY    : [Streamed Response]');
    } else {
      print('║  STATUS  : Unknown');
      print('║  RESPONSE: $response');
    }
    print('╚══════════════════════════════════════════════════════════');
  }

  void _logError({
    required String method,
    required String? url,
    required dynamic error,
  }) {
    print('╔══════════════════════════════════════════════════════════');
    print('║  [API ERROR] $method');
    print('╠══════════════════════════════════════════════════════════');
    print('║  URL     : $url');
    print('║  ERROR   : $error');
    print('╚══════════════════════════════════════════════════════════');
  }

  getRequest({String? endPoint}) async {
    HttpClient client = HttpClient();
    final headers = _getHttpHeaders();
    _logRequest(method: 'GET', url: endPoint, headers: headers);
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final res = await http.get(Uri.parse(endPoint!), headers: headers);
      _logResponse(method: 'GET', url: endPoint, response: res);
      return res;
    } catch (error) {
      _logError(method: 'GET', url: endPoint, error: error);
      return null;
    } finally {
      client.close();
    }
  }

  getRequestWithoutToken({String? endPoint}) async {
    HttpClient client = HttpClient();
    final headers = _getHttpHeadersNotToken();
    _logRequest(method: 'GET (No Token)', url: endPoint, headers: headers);
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final res = await http.get(Uri.parse(endPoint!), headers: headers);
      _logResponse(method: 'GET (No Token)', url: endPoint, response: res);
      return res;
    } catch (error) {
      _logError(method: 'GET (No Token)', url: endPoint, error: error);
      return null;
    } finally {
      client.close();
    }
  }

  getRequestSettings(endPoint) async {
    HttpClient client = HttpClient();
    final url = APIList.baseUrl! + endPoint!;
    final headers = getAuthHeaders();
    _logRequest(method: 'GET (Settings)', url: url, headers: headers);
    try {
      final res = await http.get(Uri.parse(url), headers: headers);
      _logResponse(method: 'GET (Settings)', url: url, response: res);
      return res;
    } catch (error) {
      _logError(method: 'GET (Settings)', url: url, error: error);
      return null;
    } finally {
      client.close();
    }
  }

  postRequest({String? endPoint, String? body}) async {
    HttpClient client = HttpClient();
    final headers = getAuthHeaders();
    _logRequest(method: 'POST', url: endPoint, headers: headers, body: body);
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final res = await http.post(Uri.parse(endPoint!),
          headers: headers, body: body);
      _logResponse(method: 'POST', url: endPoint, response: res);
      return res;
    } catch (error) {
      _logError(method: 'POST', url: endPoint, error: error);
      //  return null;
    } finally {
      client.close();
    }
  }

  postRequestWithToken({String? endPoint, String? body}) async {
    HttpClient client = HttpClient();
    final headers = _getHttpHeaders();
    _logRequest(method: 'POST (With Token)', url: endPoint, headers: headers, body: body);
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final res = await http.post(Uri.parse(endPoint!),
          headers: headers, body: body);
      _logResponse(method: 'POST (With Token)', url: endPoint, response: res);
      return res;
    } catch (error) {
      _logError(method: 'POST (With Token)', url: endPoint, error: error);
      return null;
    } finally {
      client.close();
    }
  }

  putRequest({String? endPoint, String? body}) async {
    HttpClient client = HttpClient();
    final headers = _getHttpHeaders();
    _logRequest(method: 'PUT', url: endPoint, headers: headers, body: body);
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final res = await http.put(Uri.parse(endPoint!),
          headers: headers, body: body);
      _logResponse(method: 'PUT', url: endPoint, response: res);
      return res;
    } catch (error) {
      _logError(method: 'PUT', url: endPoint, error: error);
      return null;
    } finally {
      client.close();
    }
  }

  multipartRequest(endPoint, String? filepath) async {
    Map<String, String> headers = {
      'Authorization': initClass(),
      'x-api-key': APIList.licenseCode.toString(),
      'Content-Type': 'multipart/form-data',
    };
    _logRequest(method: 'MULTIPART POST', url: endPoint, headers: headers, body: 'Filepath: $filepath');

    HttpClient client = HttpClient();
    try {
      var request;
      request = http.MultipartRequest('POST', Uri.parse(endPoint!))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('image', filepath!));
      final res = await request.send();
      _logResponse(method: 'MULTIPART POST', url: endPoint, response: res);
      return res;
    } catch (error) {
      _logError(method: 'MULTIPART POST', url: endPoint, error: error);
      print(error);
      return null;
    } finally {
      client.close();
    }
  }

  deleteRequest({String? endPoint}) async {
    HttpClient client = HttpClient();
    final headers = _getHttpHeaders();
    _logRequest(method: 'DELETE', url: endPoint, headers: headers);
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final res = await http.delete(Uri.parse(endPoint!),
          headers: headers);
      _logResponse(method: 'DELETE', url: endPoint, response: res);
      return res;
    } catch (error) {
      _logError(method: 'DELETE', url: endPoint, error: error);
      return null;
    } finally {
      client.close();
    }
  }

  static Map<String, String> _getHttpHeaders() {
    Map<String, String> headers = Map<String, String>();
    headers['Authorization'] = initClass();
    headers['x-api-key'] = APIList.licenseCode.toString();
    headers['content-type'] = 'application/json';
    return headers;
  }

  static Map<String, String> _getHttpHeadersNotToken() {
    Map<String, String> headers = Map<String, String>();
    headers['x-api-key'] = APIList.licenseCode.toString();
    headers['content-type'] = 'application/json';
    return headers;
  }

  static Map<String, String> getAuthHeaders() {
    Map<String, String> headers = Map<String, String>();
    headers['x-api-key'] = APIList.licenseCode.toString();
    headers['content-type'] = 'application/json';

    return headers;
  }
}
