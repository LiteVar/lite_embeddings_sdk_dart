# Lite Embeddings Dart SDK Client

这是 `lite_embeddings_dart_server` 的 Dart 客户端 SDK，用于创建、查询和管理向量化文档，适用于 Dart / Flutter 应用。

## 功能
- 覆盖全部服务端接口（文档、分段、批量查询、多文档查询）。
- 请求/响应模型类型清晰，易于使用。
- 支持 Bearer Token 鉴权。
- 依赖精简（仅 `package:http`）。

## 快速开始

在 `pubspec.yaml` 中加入依赖（或使用 `dart pub add lite_embeddings_sdk_dart`）：

```yaml
dependencies:
  lite_embeddings_sdk_dart: ^1.0.0
```

先启动服务端（默认：`http://localhost:9537/api`）。

## 使用示例

```dart
import 'package:lite_embeddings_sdk_dart/lite_embeddings_sdk_dart.dart';

Future<void> main() async {
  final client = LiteEmbeddingsClient(
    baseUrl: 'http://localhost:9537',
    apiPathPrefix: '/api',
    bearerToken: 'YOUR_TOKEN', // 可选
  );

  try {
    final version = await client.getVersion();
    print('server version: ${version.version}');
  } finally {
    await client.close();
  }
}
```

### 通过文本创建文档

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

### 查询文档

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

## 配置说明
- `baseUrl`: 服务端地址（如 `http://localhost:9537`）。
- `apiPathPrefix`: API 前缀（默认 `/api`）。
- `bearerToken`: 可选鉴权 token，会自动追加 `Authorization: Bearer <token>`。
- `defaultHeaders`: 自定义请求头；如果包含 `Authorization`，会覆盖 `bearerToken`。

## 错误处理
- `LiteEmbeddingsApiException`: 非 2xx 响应，包含状态码与可选 JSON 体。
- `LiteEmbeddingsClientException`: JSON 解析失败或响应格式异常。

## 开发命令
- 运行测试：`dart test`
- 格式化代码：`dart format .`
- 静态分析：`dart analyze`
