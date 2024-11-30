import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/unsplash_remote_datasource.dart';
import 'data/repositories/image_repository_impl.dart';
import 'domain/usecases/fetch_images_usecase.dart';
import 'presentation/bloc/image_bloc.dart';
import 'presentation/screens/design_screen.dart';
import 'package:dio/dio.dart';

void main() {
  final dio = Dio();
  final remoteDataSource = UnsplashRemoteDataSource(dio);
  final repository = ImageRepositoryImpl(remoteDataSource);
  final fetchImagesUseCase = FetchImagesUseCase(repository);

  runApp(MyApp(fetchImagesUseCase: fetchImagesUseCase));
}

class MyApp extends StatelessWidget {
  final FetchImagesUseCase fetchImagesUseCase;

  const MyApp({super.key, required this.fetchImagesUseCase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ImageBloc(fetchImagesUseCase),
        child: const DesignScreen(),
      ),
    );
  }
}
