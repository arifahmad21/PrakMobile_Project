// lib/model/weather_forecast.dart
class WeatherForecast {
  final String date;
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final double totalPrecipMm;
  final String conditionText;
  final String conditionIcon;
  final bool willItRain;

  WeatherForecast({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.totalPrecipMm,
    required this.conditionText,
    required this.conditionIcon,
    required this.willItRain,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['date'],
      maxTempC: json['day']['maxtemp_c'],
      minTempC: json['day']['mintemp_c'],
      avgTempC: json['day']['avgtemp_c'],
      totalPrecipMm: json['day']['totalprecip_mm'],
      conditionText: json['day']['condition']['text'],
      conditionIcon: json['day']['condition']['icon'],
      willItRain: json['day']['daily_will_it_rain'] == 1,
    );
  }
}
