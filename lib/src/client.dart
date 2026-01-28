import 'dart:convert';

import 'package:http/http.dart' as http;

import 'errors.dart';
import 'models.dart';

class LiteEmbeddingsClient {
  final String baseUrl;
  final String apiPathPrefix;
  final String? bearerToken;
  final http.Client _httpClient;
  final bool _disposeClient;
  final Map<String, String> _defaultHeaders;

  LiteEmbeddingsClient({
    required this.baseUrl,
    this.apiPathPrefix = '/api',
    this.bearerToken,
    http.Client? httpClient,
    Map<String, String>? defaultHeaders,
  })  : _httpClient = httpClient ?? http.Client(),
        _disposeClient = httpClient == null,
        _defaultHeaders = {
          'accept': 'application/json',
          if (defaultHeaders != null) ...defaultHeaders,
        } {
    if (bearerToken != null && !_hasAuthorizationHeader(_defaultHeaders)) {
      _defaultHeaders['Authorization'] = 'Bearer $bearerToken';
    }
  }

  Future<void> close() async {
    if (_disposeClient) {
      _httpClient.close();
    }
  }

  Future<VersionInfo> getVersion() async {
    return _get('/version', VersionInfo.fromJson);
  }

  Future<CreateDocsResult> createDocsByText(CreateDocsTextRequest request) async {
    return _post('/docs/create-by-text', request.toJson(), CreateDocsResult.fromJson);
  }

  Future<CreateDocsResult> createDocs(CreateDocsRequest request) async {
    return _post('/docs/create', request.toJson(), CreateDocsResult.fromJson);
  }

  Future<DocsId> deleteDocs(DocsId request) async {
    return _post('/docs/delete', request.toJson(), DocsId.fromJson);
  }

  Future<List<DocsInfo>> listDocs() async {
    return _getList('/docs/list', DocsInfo.fromJson);
  }

  Future<DocsInfo> renameDocs(DocsInfo request) async {
    return _post('/docs/rename', request.toJson(), DocsInfo.fromJson);
  }

  Future<QueryResult> queryDocs(QueryRequest request) async {
    return _post('/docs/query', request.toJson(), QueryResult.fromJson);
  }

  Future<List<QueryResult>> batchQueryDocs(BatchQueryRequest request) async {
    return _postList('/docs/batch-query', request.toJson(), QueryResult.fromJson);
  }

  Future<MultiDocsQueryResult> multiDocsQuery(MultiDocsQueryRequest request) async {
    return _post('/docs/multi-query', request.toJson(), MultiDocsQueryResult.fromJson);
  }

  Future<DocsFullInfo> listSegments(DocsId request) async {
    return _post('/segment/list', request.toJson(), DocsFullInfo.fromJson);
  }

  Future<SegmentUpsertResult> insertSegment(InsertSegmentRequest request) async {
    return _post('/segment/insert', request.toJson(), SegmentUpsertResult.fromJson);
  }

  Future<SegmentUpsertResult> updateSegment(UpdateSegmentRequest request) async {
    return _post('/segment/update', request.toJson(), SegmentUpsertResult.fromJson);
  }

  Future<SegmentId> deleteSegment(DeleteSegmentRequest request) async {
    return _post('/segment/delete', request.toJson(), SegmentId.fromJson);
  }

  Future<T> _get<T>(String path, T Function(JsonMap) parser) async {
    final response = await _httpClient.get(_buildUri(path), headers: _defaultHeaders);
    return _decodeObject(response, parser);
  }

  Future<List<T>> _getList<T>(String path, T Function(JsonMap) parser) async {
    final response = await _httpClient.get(_buildUri(path), headers: _defaultHeaders);
    return _decodeList(response, parser);
  }

  Future<T> _post<T>(String path, JsonMap payload, T Function(JsonMap) parser) async {
    final response = await _httpClient.post(
      _buildUri(path),
      headers: {
        ..._defaultHeaders,
        'content-type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    return _decodeObject(response, parser);
  }

  Future<List<T>> _postList<T>(
    String path,
    JsonMap payload,
    T Function(JsonMap) parser,
  ) async {
    final response = await _httpClient.post(
      _buildUri(path),
      headers: {
        ..._defaultHeaders,
        'content-type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    return _decodeList(response, parser);
  }

  Uri _buildUri(String endpoint) {
    final base = Uri.parse(baseUrl);
    final segments = <String>[
      ...base.pathSegments.where((segment) => segment.isNotEmpty),
    ];
    if (apiPathPrefix.isNotEmpty) {
      segments.addAll(apiPathPrefix.split('/').where((segment) => segment.isNotEmpty));
    }
    segments.addAll(endpoint.split('/').where((segment) => segment.isNotEmpty));
    return base.replace(pathSegments: segments);
  }

  T _decodeObject<T>(http.Response response, T Function(JsonMap) parser) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _buildApiException(response);
    }
    final body = response.body.trim();
    if (body.isEmpty) {
      throw LiteEmbeddingsClientException('Response body is empty.');
    }
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw LiteEmbeddingsClientException('Expected a JSON object but received ${decoded.runtimeType}.');
      }
      return parser(decoded);
    } catch (error) {
      throw LiteEmbeddingsClientException('Failed to decode JSON response.', cause: error);
    }
  }

  List<T> _decodeList<T>(http.Response response, T Function(JsonMap) parser) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _buildApiException(response);
    }
    final body = response.body.trim();
    if (body.isEmpty) {
      return <T>[];
    }
    try {
      final decoded = jsonDecode(body);
      if (decoded is! List) {
        throw LiteEmbeddingsClientException('Expected a JSON array but received ${decoded.runtimeType}.');
      }
      return decoded.map((item) => parser(item as JsonMap)).toList();
    } catch (error) {
      throw LiteEmbeddingsClientException('Failed to decode JSON response.', cause: error);
    }
  }

  LiteEmbeddingsApiException _buildApiException(http.Response response) {
    final body = response.body.trim();
    if (body.isEmpty) {
      return LiteEmbeddingsApiException(
        statusCode: response.statusCode,
        message: 'Request failed with status ${response.statusCode}.',
      );
    }
    try {
      final decoded = jsonDecode(body);
      return LiteEmbeddingsApiException(
        statusCode: response.statusCode,
        message: 'Request failed with status ${response.statusCode}.',
        error: decoded,
        rawBody: body,
      );
    } catch (_) {
      return LiteEmbeddingsApiException(
        statusCode: response.statusCode,
        message: 'Request failed with status ${response.statusCode}.',
        rawBody: body,
      );
    }
  }

  bool _hasAuthorizationHeader(Map<String, String> headers) {
    return headers.keys.any((key) => key.toLowerCase() == 'authorization');
  }
}
