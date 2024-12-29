# Flutter Weather App 🌤️

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



This **Flutter Weather App** provides users with real-time weather information and a 3-day forecast for any city. The app features a modern, user-friendly interface, allowing users to easily check weather updates and plan their day effectively.

## Features
- **Real-Time Weather Updates**: Displays current temperature, humidity, wind speed, and weather conditions.
- **3-Day Weather Forecast**: A visually appealing horizontal scrollable section for future weather predictions.
- **Error Handling**: Displays user-friendly error messages for invalid city names.
- **Responsive Design**: Works seamlessly across devices with different screen sizes.
- **Nginx Deployment**: Built for Flutter Web and can be deployed using Nginx for optimal performance.

## Assets
We used weather-related assets (icons and images) from the repository:  
[WeatherApp-Flutter by MasteerRui](https://github.com/MasteerRui/WeatherApp-Flutter).

## Technologies Used
- **Flutter**: For building the app's cross-platform UI.
- **OpenWeather API**: To fetch real-time weather data.
- **Dart**: For programming the app's functionality.
- **Docker**: To containerize the app and make it ready for deployment.

## Screenshots
[Include relevant screenshots showcasing your app's interface and features.]

## Installation
### Prerequisites
- Flutter SDK installed ([Get Flutter](https://flutter.dev/docs/get-started/install)).
- OpenWeather API Key ([Get API Key](https://openweathermap.org/api)).

### Steps
1. Clone this repository:
   ```bash
   git clone https://github.com/your-repo-name/weather_app.git
   cd weather_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

4. For Flutter Web deployment:
   ```bash
   flutter build web
   ```

5. Use Docker to run the web app with Nginx:
   ```
   bash
   docker build -t flutter-weather-app .
   docker run -p 8080:80 flutter-weather-app
   ```
   Open your browser at `http://localhost:8080`.

## Contributing
We welcome contributions to improve the app! Fork the repository, make your changes, and submit a pull request.

## Authors
This project was developed collaboratively by:
- [Muhammed Nihat Aydın](https://github.com/Nihat-AYDIN)
- [Muhammet Hamza Yavuz](https://github.com/hamza37yavuz)

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Acknowledgments
- Special thanks to the OpenWeather API team for providing reliable weather data services.
- Thanks to [MasteerRui's WeatherApp-Flutter repository](https://github.com/MasteerRui/WeatherApp-Flutter) for the assets we used in this project.
