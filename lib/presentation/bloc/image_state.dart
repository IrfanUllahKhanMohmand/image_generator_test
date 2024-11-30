abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final List<String> images;

  ImageLoaded(this.images);
}

class ImageError extends ImageState {
  final String message;

  ImageError(this.message);
}
