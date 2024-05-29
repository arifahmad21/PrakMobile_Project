import 'dart:convert';
import 'base_network.dart';
import 'package:http/http.dart' as http;

class ListAlbumNya {
  String apiKey = "03ff3627306c97ba67d1cc4eeba9b1e9";
  static ListAlbumNya instance = ListAlbumNya();
  Future<List<dynamic>> loadAlbums()async{
    const String fullUrl = 'https://jsonplaceholder.typicode.com/albums';
    final responseAlbums = await http.get(Uri.parse(fullUrl));
    final body = responseAlbums.body;
    if (body.isNotEmpty) {
      return json.decode(body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<Map<String, dynamic>> loadCurrentWeather(double? latitude, double? longitude) {
    return BaseNetwork.get("weather?lat=$latitude&lon=$longitude&appid=$apiKey");
  }
  Future<List<dynamic>> loadPhotosWithIdAlbums(int? idAlbums)async {
    String fullUrl = "https://jsonplaceholder.typicode.com/photos?albumId=$idAlbums";
    final responsePhotos = await http.get(Uri.parse(fullUrl));
    final body = responsePhotos.body;
    if (body.isNotEmpty) {
      return json.decode(body);
    } else {
      throw Exception('Failed to load data');
    }
    // return BaseNetwork.get("https://jsonplaceholder.typicode.com/photos?albumId=$idAlbums");
  }
}