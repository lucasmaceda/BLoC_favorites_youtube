import 'package:app_favoritos_youtube/bloc/favorite_bloc.dart';
import 'package:app_favoritos_youtube/bloc/videos_bloc.dart';
import 'package:app_favoritos_youtube/delegates/data_search.dart';
import 'package:app_favoritos_youtube/models/video.dart';
import 'package:app_favoritos_youtube/widget/videos.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'favorites.dart';

final bloc = BlocProvider.getBloc<VideosBloc>();

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset('assets/images/logo.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text('${snapshot.data.length}');
                  else
                    return Container();
                }),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Favorites()),
              );
            },
          ),
          IconButton(
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) bloc.inSearch.add(result);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: bloc.outVideos,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.builder(
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return Videos(snapshot.data[index]);
                  } else if (index > 1) {
                    bloc.inSearch.add(null);

                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          else
            return Container();
        },
      ),
    );
  }
}
