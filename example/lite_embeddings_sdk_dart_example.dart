import 'package:lite_embeddings_sdk_dart/lite_embeddings_sdk_dart.dart';

Future<void> main() async {
  final client = LiteEmbeddingsClient(
    baseUrl: 'http://localhost:9537',
    apiPathPrefix: '/api',
    bearerToken: 'YOUR_TOKEN',
  );

  try {
    final version = await client.getVersion();
    print('server version: ${version.version}');
  } finally {
    await client.close();
  }
}
