import 'package:app_favoritos_youtube/bloc/favorite_bloc.dart';
import 'package:app_favoritos_youtube/bloc/videos_bloc.dart';
import 'package:app_favoritos_youtube/screens/home.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => VideosBloc()),
        Bloc((i) => FavoriteBloc()),
      ],
      dependencies: [],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: Home(),
      ),
    );
  }
}
