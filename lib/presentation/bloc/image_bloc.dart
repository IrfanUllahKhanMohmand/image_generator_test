import 'package:flutter_bloc/flutter_bloc.dart';
import 'image_event.dart';
import 'image_state.dart';
import '../../domain/usecases/fetch_images_usecase.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final FetchImagesUseCase fetchImagesUseCase;

  ImageBloc(this.fetchImagesUseCase) : super(ImageInitial()) {
    on<FetchImagesEvent>((event, emit) async {
      emit(ImageLoading());
      try {
        final images = await fetchImagesUseCase(event.query);
        emit(ImageLoaded(images));
      } catch (e) {
        emit(ImageError(e.toString()));
      }
    });
  }
}
