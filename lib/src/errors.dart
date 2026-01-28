class LiteEmbeddingsException implements Exception {
  final String message;
  final Object? cause;

  LiteEmbeddingsException(this.message, {this.cause});

  @override
  String toString() =>
      cause == null ? 'LiteEmbeddingsException: $message' : 'LiteEmbeddingsException: $message (cause: $cause)';
}

class LiteEmbeddingsApiException extends LiteEmbeddingsException {
  final int statusCode;
  final Object? error;
  final String? rawBody;

  LiteEmbeddingsApiException({
    required this.statusCode,
    required String message,
    this.error,
    this.rawBody,
  }) : super(message);

  @override
  String toString() {
    final buffer = StringBuffer('LiteEmbeddingsApiException($statusCode): $message');
    if (error != null) {
      buffer.write(' error=$error');
    }
    if (rawBody != null && rawBody!.isNotEmpty) {
      buffer.write(' body=$rawBody');
    }
    return buffer.toString();
  }
}

class LiteEmbeddingsClientException extends LiteEmbeddingsException {
  LiteEmbeddingsClientException(String message, {Object? cause})
      : super(message, cause: cause);
}
