import 'package:dio/dio.dart';

class UnsplashRemoteDataSource {
  final Dio dio;
  final String unsplashApiKey = 'your_api_key_here';

  UnsplashRemoteDataSource(this.dio);

  Future<List<String>> fetchImages(String query) async {
    try {
      final response = await dio.get(
        'https://api.unsplash.com/search/photos',
        queryParameters: {'query': query, 'per_page': 10},
        options:
            Options(headers: {'Authorization': 'Client-ID $unsplashApiKey'}),
      );
      final List results = response.data['results'];
      return results.map((e) => e['urls']['small'] as String).toList();
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }
}
