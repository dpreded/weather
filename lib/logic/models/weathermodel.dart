import "dart:convert";

class WeatherModel {
  final String temp;
  final String city;
  final String desc;

  WeatherModel.fromMap(Map<String, dynamic> json)
      : temp = json['current']['temp_c'].toString(),
        city = json['location']['name'].toString(),
        desc = json['current']['condition']['text'].toString();
}
