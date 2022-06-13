import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_weatherapp/models/weather_time_model.dart';

class DetailWidget extends StatelessWidget {
  WeatherTimeModel weatherModelList;
  DetailWidget({required this.weatherModelList});

  String retornarImagen(String tipo){
    String img='';
    switch(tipo){
      case 'Clouds': img='cloud.png';break;
      case 'Clear': img='ventoso_bn.png';break;
      case 'Tornado': img='tornado_bn.png';break;
      case 'Snow': img='snow_bn.png';break;
      case 'Rain': img='lluvia_bn.png';break;
      case 'Thunderstorm': img='clear_bn.png';break;
      default:img='cloud.png';break;

    }
    return img;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(12),
          boxShadow: [
      BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 10,
      offset: const Offset(5, 5),
    ),
    ]
    ),
    child: Column(
    children: [
    Text(
    weatherModelList.dtTxt.toString().substring(0,16),
    style: TextStyle(
    color: Colors.white,
    fontSize: 14,
    ),
    ),
    const SizedBox(
    height: 10.0,
    ),
    Image.asset(
    'assets/images/${retornarImagen(weatherModelList.weather[0].main)}',
    height: 50.0,
    ),
    const SizedBox(
    height: 10.0,
    ),
    Text(
    '${(weatherModelList.main.temp - 273.15).toStringAsFixed(0)}°',
    style: TextStyle(
    color: Colors.white,
    fontSize: 23,
    ),
    ),
    ],
    ),
    );
  }
}