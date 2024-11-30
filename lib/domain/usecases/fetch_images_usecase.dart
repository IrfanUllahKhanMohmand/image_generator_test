import '../repositories/image_repository.dart';

class FetchImagesUseCase {
  final ImageRepository repository;

  FetchImagesUseCase(this.repository);

  Future<List<String>> call(String query) async {
    return await repository.fetchImages(query);
  }
}
