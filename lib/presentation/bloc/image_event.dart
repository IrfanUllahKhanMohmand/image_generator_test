abstract class ImageEvent {}

class FetchImagesEvent extends ImageEvent {
  final String query;

  FetchImagesEvent(this.query);
}
