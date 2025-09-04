class SasResponse {
  final String sasUrl;
  final String blobName;
  final int maxSize;
  SasResponse({required this.sasUrl, required this.blobName, required this.maxSize});
  factory SasResponse.fromJson(Map<String, dynamic> j) =>
      SasResponse(sasUrl: j['sasUrl'], blobName: j['blobName'], maxSize: j['maxSize']);
}

class CreatePostResponse {
  final String id;
  final String status;
  final Map<String, dynamic>? captureResult;
  CreatePostResponse({required this.id, required this.status, this.captureResult});
  factory CreatePostResponse.fromJson(Map<String, dynamic> j) =>
      CreatePostResponse(id: j['id'], status: j['status'], captureResult: j['capture_result']);
}

class PostStatus {
  final String id;
  final String status;
  final String? processedUrl;
  final String? rarity;
  final Map<String, dynamic>? vehicle;
  PostStatus({required this.id, required this.status, this.processedUrl, this.rarity, this.vehicle});
  factory PostStatus.fromJson(Map<String, dynamic> j) =>
      PostStatus(id: j['id'], status: j['status'], processedUrl: j['processed_blob_url'],
          rarity: j['rarity'], vehicle: j['vehicle']);
}
