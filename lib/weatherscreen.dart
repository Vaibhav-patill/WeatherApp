import 'package:flutter/material.dart';
import 'weatherservice.dart';
import 'searchbar.dart' as custom;

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  List<String> cities = ['London', 'New York', 'Tokyo', 'Sydney'];
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  bool isSearchResult = false;

  @override
  void initState() {
    super.initState();
    getCitiesWeather();
  }

  Future<void> getWeather(String location) async {
    try {
      var data = await weatherService.fetchWeather(location);
      setState(() {
        weatherData![location] = data;
      });
    } catch (e) {
      print(e);
      setState(() {
        weatherData![location] = null;
      });
    }
  }

  Future<void> getCitiesWeather() async {
    setState(() {
      isLoading = true;
    });
    weatherData = {};
    for (String city in cities) {
      await getWeather(city);
    }
    setState(() {
      isLoading = false;
      isSearchResult = false;
    });
  }

  Future<void> searchWeather(String location) async {
    if (location.isNotEmpty) {
      setState(() {
        isLoading = true;
        weatherData = {};
        isSearchResult = true;
      });
      await getWeather(location);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        leading: isSearchResult
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            getCitiesWeather();
          },
        )
            : null,
      ),
      body: Column(
        children: [
          custom.SearchBar(
            controller: searchController,
            onSearch: searchWeather,
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: weatherData!.length,
              itemBuilder: (context, index) {
                String location = weatherData!.keys.elementAt(index);
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 1.0,
                    ),
                    color: Colors.grey[200]!.withOpacity(0.8),
                  ),
                  child: ListTile(
                    leading: weatherData![location] != null
                        ? WeatherIcon(weatherData![location]!['weather'][0]['main'])
                        : Icon(Icons.error_outline, color: Colors.red),
                    title: Text(
                      location,
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: weatherData![location] != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${(weatherData![location]!['main']['temp'] - 273.15).toStringAsFixed(1)}°C',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              '${weatherData![location]!['weather'][0]['description']}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    )
                        : Text('Failed to load weather data'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getCitiesWeather,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class WeatherIcon extends StatelessWidget {
  final String weatherMain;

  const WeatherIcon(this.weatherMain);

  @override
  Widget build(BuildContext context) {
    switch (weatherMain) {
      case 'Clear':
        return Icon(Icons.sunny, color: Colors.yellow);
      case 'Clouds':
        return Icon(Icons.cloud, color: Colors.grey);
      default:
        return Icon(Icons.wb_sunny, color: Colors.yellow);
    }
  }
}
