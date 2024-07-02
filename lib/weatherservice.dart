import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String apiKey = 'a6e6c96fb4b547b953a0c2b2f935413b';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey'));

    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

void main() async {
  WeatherService weatherService = WeatherService();

  try {
    var weatherData = await weatherService.fetchWeather('London');
    print(weatherData);
  } catch (e) {
    print(e);
  }
}
