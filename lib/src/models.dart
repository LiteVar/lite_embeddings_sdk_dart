typedef JsonMap = Map<String, dynamic>;

class VersionInfo {
  final String version;

  VersionInfo({required this.version});

  factory VersionInfo.fromJson(JsonMap json) {
    return VersionInfo(version: json['version'] as String);
  }

  JsonMap toJson() => {'version': version};
}

class LLMConfig {
  final String baseUrl;
  final String? apiKey;
  final String model;

  LLMConfig({required this.baseUrl, required this.apiKey, required this.model});

  factory LLMConfig.fromJson(JsonMap json) {
    return LLMConfig(
      baseUrl: json['baseUrl'] as String,
      apiKey: json['apiKey'] as String?,
      model: json['model'] as String,
    );
  }

  JsonMap toJson() => {'baseUrl': baseUrl, 'apiKey': apiKey, 'model': model};
}

class TokenUsage {
  final int promptToken;
  final int totalToken;

  TokenUsage({required this.promptToken, required this.totalToken});

  factory TokenUsage.fromJson(JsonMap json) {
    return TokenUsage(
      promptToken: (json['promptToken'] as num).toInt(),
      totalToken: (json['totalToken'] as num).toInt(),
    );
  }

  JsonMap toJson() => {'promptToken': promptToken, 'totalToken': totalToken};
}

class DocsId {
  final String docsId;

  DocsId({required this.docsId});

  factory DocsId.fromJson(JsonMap json) {
    return DocsId(docsId: json['docsId'] as String);
  }

  JsonMap toJson() => {'docsId': docsId};
}

class DocsInfo extends DocsId {
  final String docsName;

  DocsInfo({required super.docsId, required this.docsName});

  factory DocsInfo.fromJson(JsonMap json) {
    return DocsInfo(
      docsId: json['docsId'] as String,
      docsName: json['docsName'] as String,
    );
  }

  @override
  JsonMap toJson() => {'docsId': docsId, 'docsName': docsName};
}

class CreateDocsTextRequest {
  final String docsName;
  final String text;
  final String separator;
  final Map<String, dynamic>? metadata;
  final LLMConfig llmConfig;

  CreateDocsTextRequest({
    required this.docsName,
    required this.text,
    required this.separator,
    required this.llmConfig,
    this.metadata,
  });

  JsonMap toJson() => {
    'docsName': docsName,
    'text': text,
    'separator': separator,
    'metadata': metadata,
    'llmConfig': llmConfig.toJson(),
  };
}

class Segment {
  final String text;
  final Map<String, dynamic>? metadata;

  Segment({required this.text, this.metadata});

  factory Segment.fromJson(JsonMap json) {
    return Segment(
      text: json['text'] as String,
      metadata: (json['metadata'] as Map?)?.cast<String, dynamic>(),
    );
  }

  JsonMap toJson() => {'text': text, 'metadata': metadata};
}

class SegmentInfo extends Segment {
  final String segmentId;

  SegmentInfo({required this.segmentId, required super.text, super.metadata});

  factory SegmentInfo.fromJson(JsonMap json) {
    return SegmentInfo(
      segmentId: json['segmentId'] as String,
      text: json['text'] as String,
      metadata: (json['metadata'] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  JsonMap toJson() => {
    'segmentId': segmentId,
    'text': text,
    'metadata': metadata,
  };
}

class SegmentResult {
  final String segmentId;
  final String text;
  final Map<String, dynamic>? metadata;
  final double distance;

  SegmentResult({
    required this.segmentId,
    required this.text,
    required this.metadata,
    required this.distance,
  });

  factory SegmentResult.fromJson(JsonMap json) {
    return SegmentResult(
      segmentId: json['segmentId'] as String,
      text: json['text'] as String,
      metadata: (json['metadata'] as Map?)?.cast<String, dynamic>(),
      distance: (json['distance'] as num).toDouble(),
    );
  }

  JsonMap toJson() => {
    'segmentId': segmentId,
    'text': text,
    'metadata': metadata,
    'distance': distance,
  };
}

class CreateDocsRequest {
  final String docsName;
  final List<Segment> segmentList;
  final LLMConfig llmConfig;

  CreateDocsRequest({
    required this.docsName,
    required this.segmentList,
    required this.llmConfig,
  });

  JsonMap toJson() => {
    'docsName': docsName,
    'segmentList': segmentList.map((segment) => segment.toJson()).toList(),
    'llmConfig': llmConfig.toJson(),
  };
}

class CreateDocsResult extends DocsInfo {
  final TokenUsage tokenUsage;

  CreateDocsResult({
    required super.docsId,
    required super.docsName,
    required this.tokenUsage,
  });

  factory CreateDocsResult.fromJson(JsonMap json) {
    return CreateDocsResult(
      docsId: json['docsId'] as String,
      docsName: json['docsName'] as String,
      tokenUsage: TokenUsage.fromJson(json['tokenUsage'] as JsonMap),
    );
  }

  @override
  JsonMap toJson() => {
    'docsId': docsId,
    'docsName': docsName,
    'tokenUsage': tokenUsage.toJson(),
  };
}

class DocsFullInfo extends DocsInfo {
  final List<SegmentInfo> segmentInfoList;

  DocsFullInfo({
    required super.docsId,
    required super.docsName,
    required this.segmentInfoList,
  });

  factory DocsFullInfo.fromJson(JsonMap json) {
    final list = (json['segmentInfoList'] as List)
        .map((item) => SegmentInfo.fromJson(item as JsonMap))
        .toList();
    return DocsFullInfo(
      docsId: json['docsId'] as String,
      docsName: json['docsName'] as String,
      segmentInfoList: list,
    );
  }

  @override
  JsonMap toJson() => {
    'docsId': docsId,
    'docsName': docsName,
    'segmentInfoList': segmentInfoList
        .map((segment) => segment.toJson())
        .toList(),
  };
}

class QueryRequest {
  final String docsId;
  final String queryText;
  final int? nResults;
  final LLMConfig llmConfig;

  QueryRequest({
    required this.docsId,
    required this.queryText,
    required this.llmConfig,
    this.nResults,
  });

  JsonMap toJson() => {
    'docsId': docsId,
    'queryText': queryText,
    if (nResults != null) 'nResults': nResults,
    'llmConfig': llmConfig.toJson(),
  };
}

class BatchQueryRequest {
  final String docsId;
  final List<String> queryTextList;
  final int? nResults;
  final LLMConfig llmConfig;

  BatchQueryRequest({
    required this.docsId,
    required this.queryTextList,
    required this.llmConfig,
    this.nResults,
  });

  JsonMap toJson() => {
    'docsId': docsId,
    'queryTextList': queryTextList,
    if (nResults != null) 'nResults': nResults,
    'llmConfig': llmConfig.toJson(),
  };
}

class QueryResult {
  final String docsId;
  final List<SegmentResult> segmentResultList;
  final TokenUsage tokenUsage;

  QueryResult({
    required this.docsId,
    required this.segmentResultList,
    required this.tokenUsage,
  });

  factory QueryResult.fromJson(JsonMap json) {
    final list = (json['segmentResultList'] as List)
        .map((item) => SegmentResult.fromJson(item as JsonMap))
        .toList();
    return QueryResult(
      docsId: json['docsId'] as String,
      segmentResultList: list,
      tokenUsage: TokenUsage.fromJson(json['tokenUsage'] as JsonMap),
    );
  }

  JsonMap toJson() => {
    'docsId': docsId,
    'segmentResultList': segmentResultList
        .map((segment) => segment.toJson())
        .toList(),
    'tokenUsage': tokenUsage.toJson(),
  };
}

class MultiDocsQueryRequest {
  final List<String> docsIdList;
  final String queryText;
  final int? nResults;
  final bool? removeDuplicates;
  final LLMConfig llmConfig;

  MultiDocsQueryRequest({
    required this.docsIdList,
    required this.queryText,
    required this.llmConfig,
    this.nResults,
    this.removeDuplicates,
  });

  JsonMap toJson() => {
    'docsIdList': docsIdList,
    'queryText': queryText,
    if (nResults != null) 'nResults': nResults,
    if (removeDuplicates != null) 'removeDuplicates': removeDuplicates,
    'llmConfig': llmConfig.toJson(),
  };
}

class MultiDocsQuerySegment {
  final String docsId;
  final SegmentResult segmentResult;

  MultiDocsQuerySegment({required this.docsId, required this.segmentResult});

  factory MultiDocsQuerySegment.fromJson(JsonMap json) {
    return MultiDocsQuerySegment(
      docsId: json['docsId'] as String,
      segmentResult: SegmentResult.fromJson(json['segmentResult'] as JsonMap),
    );
  }

  JsonMap toJson() => {
    'docsId': docsId,
    'segmentResult': segmentResult.toJson(),
  };
}

class MultiDocsQueryResult {
  final List<MultiDocsQuerySegment> segmentResultList;
  final TokenUsage tokenUsage;

  MultiDocsQueryResult({
    required this.segmentResultList,
    required this.tokenUsage,
  });

  factory MultiDocsQueryResult.fromJson(JsonMap json) {
    final list = (json['segmentResultList'] as List)
        .map((item) => MultiDocsQuerySegment.fromJson(item as JsonMap))
        .toList();
    return MultiDocsQueryResult(
      segmentResultList: list,
      tokenUsage: TokenUsage.fromJson(json['tokenUsage'] as JsonMap),
    );
  }

  JsonMap toJson() => {
    'segmentResultList': segmentResultList
        .map((segment) => segment.toJson())
        .toList(),
    'tokenUsage': tokenUsage.toJson(),
  };
}

class InsertSegmentRequest {
  final String docsId;
  final Segment segment;
  final int? index;
  final LLMConfig llmConfig;

  InsertSegmentRequest({
    required this.docsId,
    required this.segment,
    required this.llmConfig,
    this.index,
  });

  JsonMap toJson() => {
    'docsId': docsId,
    'segment': segment.toJson(),
    if (index != null) 'index': index,
    'llmConfig': llmConfig.toJson(),
  };
}

class UpdateSegmentRequest {
  final String docsId;
  final SegmentInfo segment;
  final LLMConfig llmConfig;

  UpdateSegmentRequest({
    required this.docsId,
    required this.segment,
    required this.llmConfig,
  });

  JsonMap toJson() => {
    'docsId': docsId,
    'segment': segment.toJson(),
    'llmConfig': llmConfig.toJson(),
  };
}

class DeleteSegmentRequest {
  final String docsId;
  final String segmentId;

  DeleteSegmentRequest({required this.docsId, required this.segmentId});

  JsonMap toJson() => {'docsId': docsId, 'segmentId': segmentId};
}

class SegmentUpsertResult {
  final String segmentId;
  final TokenUsage tokenUsage;

  SegmentUpsertResult({required this.segmentId, required this.tokenUsage});

  factory SegmentUpsertResult.fromJson(JsonMap json) {
    return SegmentUpsertResult(
      segmentId: json['segmentId'] as String,
      tokenUsage: TokenUsage.fromJson(json['tokenUsage'] as JsonMap),
    );
  }

  JsonMap toJson() => {
    'segmentId': segmentId,
    'tokenUsage': tokenUsage.toJson(),
  };
}

class SegmentId {
  final String segmentId;

  SegmentId({required this.segmentId});

  factory SegmentId.fromJson(JsonMap json) {
    return SegmentId(segmentId: json['segmentId'] as String);
  }

  JsonMap toJson() => {'segmentId': segmentId};
}
