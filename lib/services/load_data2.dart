import 'package:projek_akhir/model/current.dart';
import 'base_network2.dart';

class WeatherService {
  static const String apiKey = "eae474142e194481807115104241005";

  static Future<CurrentWeather?> loadCurrentWeather(double latitude, double longitude) async {
    final partUrl = "current.json?key=$apiKey&q=$latitude,$longitude";
    final response = await BaseNetwork.get(partUrl);
    
    if (response == null || response.containsKey('error')) {
      throw Exception("Failed to load weather data");
    } else {
      print(response);
      return CurrentWeather.fromJson(response);
    }
  }
}