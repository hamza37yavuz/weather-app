import 'package:flutter/material.dart';
import 'weather_detail_page.dart';

class CityInputPage extends StatelessWidget {
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade600,
              Colors.blue.shade300,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Weather App",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 100),
              TextField(
                controller: cityController,
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  hintText: 'Enter City Name',
                  hintStyle: TextStyle(color: Colors.white70),
                  labelText: 'City Name',
                  labelStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.only(left: 28, top: 12, bottom: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.location_city, color: Colors.white70),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    String capitalized = value[0].toUpperCase() + value.substring(1);
                    if (value != capitalized) {
                      cityController.value = cityController.value.copyWith(
                        text: capitalized,
                        selection: TextSelection.collapsed(offset: capitalized.length),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final city = cityController.text;
                  if (city.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherDetailPage(city: city),
                      ),
                    );
                    cityController.text = "";
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Yuvarlak köşeler
                  ),
                  backgroundColor: Colors.white, // Buton arka plan rengi
                  foregroundColor: Colors.blue.shade900, // Buton metin rengi
                  elevation: 5, // Gölge efekti
                ),
                child: Text(
                  "Get Weather",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Search for your city's weather forecast.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
