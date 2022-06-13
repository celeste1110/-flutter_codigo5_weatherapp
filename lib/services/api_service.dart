import 'dart:convert';

import 'package:flutter_codigo5_weatherapp/models/weather_model.dart';
import 'package:flutter_codigo5_weatherapp/models/weather_time_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_location_model.dart';
class APIService{
  Future<WeatherModel?> getDataWeather(String cityName)async{
    String path='https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=0974a7ffc1f4e0a6524db47e4b39a07d';
    Uri _uri =Uri.parse(path);
    http.Response response=await http.get(_uri);
    if(response.statusCode==200){
      Map <String,dynamic> myMap=json.decode(response.body);
      WeatherModel weather= WeatherModel.fromJson(myMap);
      // print(weather.weather[0].main);
      return weather;

    }
    return null;

  }
  Future<WeatherModel?> getDataWeatherLocation(Position position) async{
    String path='https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=0974a7ffc1f4e0a6524db47e4b39a07d';
    Uri _uri =Uri.parse(path);
    http.Response response=await http.get(_uri);
    if(response.statusCode==200){
      Map <String,dynamic> myMap=json.decode(response.body);
      WeatherModel weather= WeatherModel.fromJson(myMap);
      // print(weather.weather[0].main);
      return weather;

    }
    return null;

  }
  Future<List<WeatherTimeModel>> getDataWeatherTime(String cityName)async{
    String path='https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=0974a7ffc1f4e0a6524db47e4b39a07d';
    Uri _uri =Uri.parse(path);
    http.Response response=await http.get(_uri);
    if(response.statusCode==200){
      Map <String,dynamic> myMap=json.decode(response.body);
      List forest=myMap['list'];
      List<WeatherTimeModel> forestList= forest.map<WeatherTimeModel>((e) => WeatherTimeModel.fromJson(e)).toList() ;
      // print(weather.weather[0].main);
      return forestList;

    }
    return [];

  }

  Future<List<WeatherTimeModel>> getDataWeatherTimeLocation(Position position)async{
    String path='https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=0974a7ffc1f4e0a6524db47e4b39a07d';
    Uri _uri =Uri.parse(path);
    http.Response response=await http.get(_uri);
    if(response.statusCode==200){
      Map <String,dynamic> myMap=json.decode(response.body);
      List forest=myMap['list'];
      List<WeatherTimeModel> forestList= forest.map<WeatherTimeModel>((e) => WeatherTimeModel.fromJson(e)).toList() ;
      // print(weather.weather[0].main);
      return forestList;

    }
    return [];

  }

}