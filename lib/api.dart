import 'dart:convert';
import 'package:app_favoritos_youtube/models/video.dart';
import 'package:http/http.dart' as http;

const API_KEY = "AIzaSyB358JLlHJYQAtrOC8_4fOowQLZUsMyuSc";

class Api {
  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;

    http.Response response = await http.get(
      Uri.parse(
          "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"),
    );

    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(
      Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken",
      ),
    );

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body)['items'];
      var token = jsonDecode(response.body)['nextPageToken'];

      _nextToken = token;

      List<Video> videos =
          decoded.map<Video>((map) => Video.fromJson(map)).toList();

      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
