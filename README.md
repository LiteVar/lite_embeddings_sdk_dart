# Lite Embeddings Dart SDK Client

A lightweight Dart client for the `lite_embeddings_dart_server` HTTP API. Use it to create, query, and manage vectorized documents from Dart or Flutter apps.

## Features
- Full coverage of server endpoints (docs, segments, batch and multi-doc queries).
- Simple, typed request/response models.
- Optional Bearer token authentication.
- Small dependency footprint (`package:http`).

## Getting Started

Add the dependency to your `pubspec.yaml` (or use `dart pub add lite_embeddings_sdk_dart`).

```yaml
dependencies:
  lite_embeddings_sdk_dart: ^1.0.0
```

Start the server first (default: `http://localhost:9537/api`).

## Usage

```dart
import 'package:lite_embeddings_sdk_dart/lite_embeddings_sdk_dart.dart';

Future<void> main() async {
  final client = LiteEmbeddingsClient(
    baseUrl: 'http://localhost:9537',
    apiPathPrefix: '/api',
    bearerToken: 'YOUR_TOKEN', // optional
  );

  try {
    final version = await client.getVersion();
    print('server version: ${version.version}');
  } finally {
    await client.close();
  }
}
```

### Create docs by text

```dart
final request = CreateDocsTextRequest(
  docsName: 'notes.md',
  text: 'A\n<!--SEPARATOR-->\nB',
  separator: '<!--SEPARATOR-->',
  llmConfig: LLMConfig(
    baseUrl: 'https://api.openai.com/v1',
    apiKey: 'sk-xxxx',
    model: 'text-embedding-3-small',
  ),
);

final result = await client.createDocsByText(request);
print(result.docsId);
```

### Query docs

```dart
final result = await client.queryDocs(
  QueryRequest(
    docsId: 'your-doc-id',
    queryText: 'What is this about?',
    nResults: 3,
    llmConfig: LLMConfig(
      baseUrl: 'https://api.openai.com/v1',
      apiKey: 'sk-xxxx',
      model: 'text-embedding-3-small',
    ),
  ),
);
print(result.segmentResultList.length);
```

## Configuration
- `baseUrl`: Server base URL (e.g., `http://localhost:9537`).
- `apiPathPrefix`: API prefix (default: `/api`).
- `bearerToken`: Optional token for `Authorization: Bearer <token>`.
- `defaultHeaders`: Provide custom headers; `Authorization` overrides `bearerToken` if present.

## Error Handling
- `LiteEmbeddingsApiException`: Non-2xx responses, with status code and optional JSON body.
- `LiteEmbeddingsClientException`: JSON parse errors or unexpected response shapes.

## Development
- Run tests: `dart test`
- Format code: `dart format .`
- Analyze: `dart analyze`
