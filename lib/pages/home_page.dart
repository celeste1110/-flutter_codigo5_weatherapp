import 'package:flutter/material.dart';
import 'package:flutter_codigo5_weatherapp/models/weather_time_model.dart';
import 'package:flutter_codigo5_weatherapp/services/api_service.dart';
import 'package:flutter_codigo5_weatherapp/ui/general/colors.dart';

import '../ui/widget/detail_widgett.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final APIService apiService = APIService();
  final TextEditingController cityNameController = TextEditingController();
  String city = "-";
  String country = "-";
  String weatherType = "";
  String temp = "0";
  String lat = "";
  String long = "";
  bool isLoading = true;
  String imagen='dom.png';
  List<WeatherTimeModel> weatherList = [];
  @override
  initState() {
    super.initState();
    // _getDataWeather();
    _getWeatherLocation();
  }

  _getDataWeather() {
    String cityName = cityNameController.text;
    isLoading = true;
    apiService.getDataWeather(cityName).then((value) {
      if (value != null) {
        city = value.name;
        country = value.sys.country;
        weatherType = value.weather[0].main;
        imagen=retornarImagen( weatherType );
        temp = (value.main.temp - 273.15).toStringAsFixed(0);
        apiService.getDataWeatherTime(cityName).then((value1){
          weatherList=value1;
          setState(() {});
        });
        isLoading = false;
        setState(() {});
      } else {
        // isLoading = false;

        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Hubo un inconveniente, por favor intentelo nuevamente',
            ),
          ),
        );
      }
    });
  }

  _getWeatherLocation() async {
    // Position _position=await Geolocator.getCurrentPosition();
    // print(_position);
    isLoading = true;
    cityNameController.text='';
    setState(() {});
    Geolocator.getCurrentPosition().then((position) {
      apiService.getDataWeatherLocation(position).then((value) {
        if (value != null) {
          city = value.name;
          country = value.sys.country;
          weatherType = value.weather[0].main;
          imagen=retornarImagen( weatherType );
          temp = (value.main.temp - 273.15).toStringAsFixed(0);
          apiService.getDataWeatherTimeLocation(position).then((value1){
            weatherList=value1;
            setState(() {});
          });
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Hubo un inconveniente, por favor intentelo nuevamente',
              ),
            ),
          );
        }
      });
    });
  }
  String retornarImagen(String tipo){
    String img='';
    switch(tipo){
      case 'Clouds': img='dom.png';break;
      case 'Clear': img='ventoso.png';break;
      case 'Tornado': img='tornado.png';break;
      case 'Snow': img='snow.png';break;
      case 'Rain': img='lluvia.png';break;
      case 'Drizzle': img='lluvioso.png';break;
      case 'Thunderstorm': img='clear.png';break;
      default:img='dom.png';break;

    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: kBrandPrimaryColor,
        appBar: AppBar(
          title: Text("WeatherApp"),
          elevation: 0,
          centerTitle: true,
          backgroundColor: kBrandPrimaryColor,
          actions: [
            IconButton(
              onPressed: () {
                _getWeatherLocation();
              },
              icon: Icon(
                Icons.location_on,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Image.asset(
                      // 'assets/images/dom.png',
                      'assets/images/$imagen',
                      height: height * 0.14,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      weatherType,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          temp,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.08,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        const Text(
                          "°C",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "$city, $country",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: cityNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter city name',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (value) {
                        _getDataWeather();
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: weatherList.map((e) => DetailWidget(weatherModelList: e,)).toList(),
                        // children: [
                        //   DetailWidget(),
                        //   DetailWidget(),
                        //   DetailWidget(),
                        //   DetailWidget(),
                        //   DetailWidget(),
                        //   DetailWidget(),
                        // ],
                      ),
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '15 minutes ago',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo',
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            top: -55,
                            child: Image.asset(
                              'assets/images/nube.png',
                              height: height * 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isLoading
                ? Container(
                    color: kBrandPrimaryColor.withOpacity(0.95),
                    child: Center(
                        child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )),
                  )
                : Container(),
          ],
        ));
  }
}
