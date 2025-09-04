import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../env.dart';
import 'models.dart';

class ApiClient {
  final Dio _dio;
  ApiClient(String? accessToken)
      : _dio = Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl, // ex: http://10.0.2.2:8000/v1
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
    headers: accessToken != null ? {'Authorization': 'Bearer $accessToken'} : {},
  ));

  // 1) SAS pour upload direct vers Azure Blob (RAW)
  Future<SasResponse> getSas({required String mime, required int size}) async {
    final res = await _dio.post('/uploads/sas', data: {'mime': mime, 'size': size});
    return SasResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // 2) PUT vers le sasUrl (pas d’auth ici; on sort de l’API)
  Future<void> putToSas(String sasUrl, Uint8List bytes, {required String contentType}) async {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {'x-ms-blob-type': 'BlockBlob', 'Content-Type': contentType},
    ));
    await dio.putUri(Uri.parse(sasUrl), data: Stream.fromIterable([bytes]));
  }

  // 3) Crée le post (enqueue le traitement)
  Future<CreatePostResponse> createPost({required String blobName, required DateTime takenAt, Map<String, dynamic>? gps}) async {
    final res = await _dio.post('/posts', data: {
      'blob_name': blobName,
      'taken_at': takenAt.toUtc().toIso8601String(),
      if (gps != null) 'gps': gps,
    });
    return CreatePostResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // 4) Poll statut du post
  Future<PostStatus> getPost(String postId) async {
    final res = await _dio.get('/posts/$postId');
    return PostStatus.fromJson(res.data as Map<String, dynamic>);
  }

  // Helper: attendre processed (timeout/polling)
  Future<PostStatus> waitProcessed(String postId, {Duration timeout = const Duration(seconds: 30), Duration interval = const Duration(seconds: 2)}) async {
    final start = DateTime.now();
    while (true) {
      final st = await getPost(postId);
      if (st.status.toLowerCase() == 'processed' && st.processedUrl != null) {
        return st;
      }
      if (DateTime.now().difference(start) > timeout) {
        return st; // retourne dernier état (peut encore être pending)
      }
      await Future.delayed(interval);
    }
  }
}
