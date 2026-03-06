import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lite_embeddings_sdk_dart/lite_embeddings_sdk_dart.dart';
import 'package:test/test.dart';

void main() {
  test('VersionInfo JSON round-trip', () {
    final info = VersionInfo(version: '0.3.1');
    final json = info.toJson();
    final decoded = VersionInfo.fromJson(json);
    expect(decoded.version, '0.3.1');
  });

  test('LLMConfig supports null apiKey', () {
    final config = LLMConfig(
      baseUrl: 'https://llm.example.com',
      apiKey: null,
      model: 'text-embedding-3-small',
    );

    final json = config.toJson();
    final decoded = LLMConfig.fromJson(json);

    expect(json['apiKey'], isNull);
    expect(decoded.apiKey, isNull);
  });

  test('client skips Authorization header when bearerToken is null', () async {
    late http.Request capturedRequest;
    final mockClient = MockClient((request) async {
      capturedRequest = request;
      return http.Response(jsonEncode({'version': '1.0.0'}), 200);
    });
    final client = LiteEmbeddingsClient(
      baseUrl: 'https://server.example.com',
      httpClient: mockClient,
    );

    final version = await client.getVersion();

    expect(version.version, '1.0.0');
    expect(capturedRequest.headers.containsKey('Authorization'), isFalse);
  });

  test(
    'client includes Authorization header when bearerToken is provided',
    () async {
      late http.Request capturedRequest;
      final mockClient = MockClient((request) async {
        capturedRequest = request;
        return http.Response(jsonEncode({'version': '1.0.0'}), 200);
      });
      final client = LiteEmbeddingsClient(
        baseUrl: 'https://server.example.com',
        bearerToken: 'secret-token',
        httpClient: mockClient,
      );

      await client.getVersion();

      expect(capturedRequest.headers['Authorization'], 'Bearer secret-token');
    },
  );
}
