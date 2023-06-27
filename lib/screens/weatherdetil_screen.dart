import 'package:onvocation/custom/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherDetailPage(),
    );
  }
}

class WeatherDetailPage extends StatefulWidget {
  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  String apiKey = "e4b2057dc1c953be9043355664a278ab";
  double latitude = 0.0;
  double longitude = 0.0;
  TextEditingController locationController = TextEditingController();
  List<dynamic> weatherData = [];
  String cityName = '';
  bool isLoading = false;
  FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    await getWeather();
  }

  Future<void> getWeather() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey");
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      if (data['list'] != null) {
        weatherData = data['list'];
        cityName = data['city']['name'];
      } else {
        weatherData = [];
        cityName = '';
      }
      isLoading = false;
    });
  }

  Future<void> searchWeather(String location) async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$apiKey");
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      if (data['list'] != null) {
        weatherData = data['list'];
        cityName = data['city']['name'];
      } else {
        weatherData = [];
        cityName = '';
      }
      isLoading = false;
    });
  }

  Widget weatherIcon(String iconCode) {
    String iconUrl = "http://openweathermap.org/img/w/$iconCode.png";
    return Image.network(
      iconUrl,
      width: 50,
      height: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColor.secondaryColor,
              AppColor.primaryColor,
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: locationController,
                      focusNode: _textFieldFocusNode,
                      onTap: () {
                        setState(() {
                          _textFieldFocusNode.requestFocus();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Cari Cuaca Daerah Sekitar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          borderSide: BorderSide(
                            color: _textFieldFocusNode.hasFocus
                                ? Colors.blue
                                : AppColor.secondaryColor,
                            width: 5.0,
                          ),
                        ),
                        prefixIcon: Icon(Icons.search),
                        filled: true, // Mengaktifkan latar belakang yang diisi
                        fillColor:
                            Colors.grey[200], // Memberikan warna latar belakang
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String location = locationController.text;
                      if (location.isNotEmpty) {
                        searchWeather(location);
                      }
                    },
                    child: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.thirdColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: AppColor.secondaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              CircularProgressIndicator()
            else if (weatherData.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Cuaca Di $cityName',
                        style: TextStyle(
                          color: AppColor.secondaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 370,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.secondaryColor,
                          width: 3,
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) {
                          var forecast = weatherData[index * 1];
                          var dateTime = DateTime.fromMillisecondsSinceEpoch(
                              forecast['dt'] * 1000);
                          var temperature =
                              (forecast['main']['temp'] - 273.15).round();
                          var description =
                              forecast['weather'][0]['description'];
                          var iconCode = forecast['weather'][0]['icon'];

                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  '${dateTime.hour}:00',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                weatherIcon(iconCode),
                              ],
                            ),
                            subtitle: Text(
                              'Temperature: $temperature°C\nDescription: $description',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
