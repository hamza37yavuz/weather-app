import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherService {
  final String apiKey = "2a6c82882ab9ee89026cf9a0115d36ad";
  final String apiUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String forecastUrl = "https://api.openweathermap.org/data/2.5/forecast";

  // Dereceyi yön isimlerine çeviren fonksiyon
  String _getWindDirection(int degree) {
    if (degree >= 337.5 || degree < 22.5) return "North";
    if (degree >= 22.5 && degree < 67.5) return "Northeast";
    if (degree >= 67.5 && degree < 112.5) return "East";
    if (degree >= 112.5 && degree < 157.5) return "Southeast";
    if (degree >= 157.5 && degree < 202.5) return "South";
    if (degree >= 202.5 && degree < 247.5) return "Southwest";
    if (degree >= 247.5 && degree < 292.5) return "West";
    if (degree >= 292.5 && degree < 337.5) return "Northwest";
    return "Unknown";
  }

  // Anlık hava durumu verisi
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse("$apiUrl?q=$city&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "temperature": "${(data['main']['temp']).ceil()} °C",
          "feels_like": "${(data['main']['feels_like']).ceil()} °C",
          "description": data['weather'][0]['description'],
          "country": data['sys']['country'],
          "humidity": "${data['main']['humidity']}%",
          "windSpeed": "${data['wind']['speed']} m/s",
          "windDirection": _getWindDirection(data['wind']['deg']),
          "pressure": "${data['main']['pressure']} hPa",
          "sunRise": DateTime.fromMillisecondsSinceEpoch(
              (data['sys']['sunrise'] + data['timezone']) * 1000,
              isUtc: true)
              .toUtc()
              .toString()
              .substring(11, 16), // HH:mm
          "sunSet": DateTime.fromMillisecondsSinceEpoch(
              (data['sys']['sunset'] + data['timezone']) * 1000,
              isUtc: true)
              .toUtc()
              .toString()
              .substring(11, 16), // HH:mm
          "icon": data['weather'][0]['icon'],
        };
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather: $e");
    }
  }

  // 3 Günlük Hava Durumu Tahmini
  Future<List<Map<String, String>>> fetchForecast(String city) async {
    final url = Uri.parse("$forecastUrl?q=$city&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List forecastList = data['list'];

        // Her günün öğlen saatini (12:00) filtreleyerek 3 günlük tahmin oluşturma
        List<Map<String, String>> dailyForecast = [];
        for (var forecast in forecastList) {
          String dateTime = forecast['dt_txt']; // "2024-12-11 12:00:00"
          if (dateTime.contains("12:00:00")) {
            DateTime date = DateTime.parse(dateTime); // Tarih nesnesine dönüştür
            String dayName = DateFormat('EEEE').format(date); // Günün adını al
            dayName = "${dayName[0].toUpperCase()}${dayName.substring(1)}"; // İlk harfi büyük yap

            dailyForecast.add({
              "date": dayName, // Gün adı
              "temperature": "${(forecast['main']['temp']).ceil()} °C",
              "icon": forecast['weather'][0]['icon'],
              "description": forecast['weather'][0]['description'],
            });
          }
        }
        return dailyForecast.take(3).toList(); // İlk 3 günü al
      } else {
        throw Exception("Failed to load forecast data");
      }
    } catch (e) {
      throw Exception("Error fetching forecast: $e");
    }
  }
}
