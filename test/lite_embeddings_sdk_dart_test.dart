import 'package:lite_embeddings_sdk_dart/lite_embeddings_sdk_dart.dart';
import 'package:test/test.dart';

void main() {
  test('VersionInfo JSON round-trip', () {
    final info = VersionInfo(version: '0.3.1');
    final json = info.toJson();
    final decoded = VersionInfo.fromJson(json);
    expect(decoded.version, '0.3.1');
  });
}
