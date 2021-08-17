import 'package:app_favoritos_youtube/api.dart';
import 'package:app_favoritos_youtube/bloc/favorite_bloc.dart';
import 'package:app_favoritos_youtube/models/video.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

final bloc = BlocProvider.getBloc<FavoriteBloc>();

class Videos extends StatelessWidget {
  final Video video;

  Videos(this.video);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(video.thumb, fit: BoxFit.cover),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text(
                          video.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          video.channel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: bloc.outFav,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return IconButton(
                        icon: Icon(
                          snapshot.data.containsKey(video.id)
                              ? Icons.star
                              : Icons.star_border,
                        ),
                        color: Colors.white,
                        iconSize: 38,
                        onPressed: () {
                          bloc.toggleFavorite(video);
                        },
                      );
                    else
                      return CircularProgressIndicator();
                  },
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        FlutterYoutube.playYoutubeVideoById(
          apiKey: API_KEY,
          videoId: video.id,
        );
      },
    );
  }
}
