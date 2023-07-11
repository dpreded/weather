import 'dart:convert';
import 'dart:developer';
import 'package:weather/constants/api_key.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import "package:http/http.dart" as http;
import 'package:weather/logic/models/weathermodel.dart';

class CallToApi {
  //callback function
//void callbackDispatcher() {
  //Workmanager().executeTask((task, inputData) async {
  //if (defaultTargetPlatform == TargetPlatform.android) {
  //GeolocatorAndroid.registerWith();
  //} else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
  // GeolocatorApple.registerWith();
  //} else if (defaultTargetPlatform == TargetPlatform.linux) {
  //  GeolocatorLinux.registerWith();
  // }
  Future<WeatherModel> callWeatherAPi(bool current, String cityName) async {
    try {
      Position currentPosition = await getCurrentPosition();

      if (current) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude);

        Placemark place = placemarks[0];
        cityName = place.locality!;
      }

      var url = Uri.https('api.weatherapi.com', '/v1/current.json',
          {"key": apiKey, 'q': cityName});
      final http.Response response = await http.get(url);
      log(response.body.toString());
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        return WeatherModel.fromMap(decodedJson);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
