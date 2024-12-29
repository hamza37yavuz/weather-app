import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherDetailPage extends StatefulWidget {
  final String city;

  const WeatherDetailPage({Key? key, required this.city}) : super(key: key);

  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  final WeatherService weatherService = WeatherService();
  Map<String, String> weatherData = {};
  List<Map<String, String>> forecastData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      final weather = await weatherService.fetchWeather(widget.city);
      final forecast = await weatherService.fetchForecast(widget.city);
      setState(() {
        weatherData = weather.cast<String, String>();
        forecastData = forecast;
        isLoading = false;
      });
    } catch (e) {
      // Hata durumunda yükleme ekranını aktif bırak ve kullanıcıyı ana ekrana döndür
      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Hata"),
            content: Text("Geçersiz şehir adı! Lütfen tekrar deneyin."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Hata mesajını kapat
                  Navigator.pop(context); // İlk sayfaya dön
                },
                child: Text("Tamam"),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white, // Yükleme sırasında boş ekran göster
        body: Center(
          child: CircularProgressIndicator(), // Yükleme animasyonu
        ),
      );
    }

    String backgroundImage = weatherData['icon'] != null
        ? "assets/images/${weatherData['icon']}.jpeg"
        : "assets/images/default.png";

    return Scaffold(
      body: Stack(
        children: [
          // Arka Plan Resmi
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Geri Dönüş Oku
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Önceki sayfaya dön
                        },
                      ),
                    ],
                  ),
                ),
                // Hava Durumu Bilgileri
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Hava Durumu İkonu
                      Image.asset(
                        weatherData['icon'] != null
                            ? 'assets/icons/${weatherData['icon']}.png'
                            : 'assets/icons/default_icon.png',
                        width: 120,
                        height: 120,
                      ),
                      SizedBox(height: 10),
                      // Şehir Adı
                      Text(
                        "${widget.city}",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      // Sıcaklık ve Açıklama
                      Text(
                        "${weatherData['temperature'] ?? '-'} | ${weatherData['description'] ?? '-'}",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 120),
                      // 3 Günlük Tahmin
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15), // Köşeleri yuvarla
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Buzlu cam efekti
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15), // Hafif şeffaf beyaz arka plan
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2), // Hafif beyaz çerçeve
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: forecastData.map((forecast) {
                                  return Column(
                                    children: [
                                      // Hava durumu ikonu
                                      Image.asset(
                                        'assets/icons/${forecast['icon'] ?? 'default_icon'}.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(height: 5),
                                      // Tarih
                                      Text(
                                        forecast['date'] ?? '-',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      // Sıcaklık
                                      Text(
                                        forecast['temperature'] ?? '-',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      // Açıklama
                                      Text(
                                        forecast['description'] ?? '-',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Ana Grid Bilgileri
                SliverPadding(
                  padding: EdgeInsets.all(12),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.6, // Küçük grid boyutu
                    children: [
                      _glassBox("Feels Like", weatherData['feels_like'] ?? "-", Icons.thermostat_outlined),
                      _glassBox(
                        "Wind",
                        "${weatherData['windSpeed'] ?? "-"} | ${weatherData['windDirection'] ?? "-"}",
                        Icons.air_outlined,
                      ),
                      _glassBox("Humidity", weatherData['humidity'] ?? "-", Icons.water_drop_outlined),
                      _glassBox("Pressure", weatherData['pressure'] ?? "-", Icons.speed_outlined),
                      _glassBox("Sunrise", weatherData['sunRise'] ?? "-", Icons.wb_twilight),
                      _glassBox("Sunset", weatherData['sunSet'] ?? "-", Icons.nightlight_round_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassBox(String label, String value, IconData icon) {
    return ClipRRect( // Blur efekti kutu kenarlarını düzgün hale getirir
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Bulanıklık efekti
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15), // Şeffaf beyaz renk
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2), // Hafif beyaz çerçeve
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: Colors.white),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
