import 'package:projek_akhir/model/current.dart';
import 'package:projek_akhir/model/weather_forecast.dart';
import 'base_network2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  static Future<List<WeatherForecast>> loadForecast(double latitude, double longitude) async {
    final String url = "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=5";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> forecastDays = data['forecast']['forecastday'];
      print("hasilnya 2: ");
      print(forecastDays);
      return forecastDays.map((json) => WeatherForecast.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}