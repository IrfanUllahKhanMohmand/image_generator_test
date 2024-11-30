import 'package:image_generator_test/domain/repositories/image_repository.dart';

import '../datasources/unsplash_remote_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final UnsplashRemoteDataSource remoteDataSource;

  ImageRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<String>> fetchImages(String query) async {
    return await remoteDataSource.fetchImages(query);
  }
}
