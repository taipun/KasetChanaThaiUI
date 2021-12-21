import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/weather.model.dart';
import 'package:kasetchana_flutter/services/weather.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:intl/intl.dart';

import 'rain-month.screen.dart';
import 'weather-add-location.dart';

class WeatherSeeMoreScreen extends StatefulWidget {
  static const routeName = '/weather-see-more';

  @override
  _WeatherSeeMoreScreenState createState() => _WeatherSeeMoreScreenState();
}

class _WeatherSeeMoreScreenState extends State<WeatherSeeMoreScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;

  Weather _weather = new Weather();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onInitWeather() {
    WeatherService().getWeather().then((res) => setState(() {
          this._weather = res;
          this.isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitWeather();
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "", []),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(WeatherAddLocationScreen.routeName)
                              .whenComplete(() => this.onInitWeather()),
                          child: Text(
                              "${this._weather?.location?.city.toString().toUpperCase()}, ${this._weather?.location?.region.toString().toUpperCase()}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: Text(
                                  "${this._weather?.currentObservation?.condition?.text}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      overflow: TextOverflow.clip,
                                      color: AppColors.SecondaryTextColor)),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              height: AppConstants.buttonHeight,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(RainMonthScreen.routeName),
                                child: Text("พญากรณ์ฝน",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: Container(
                            width: 280,
                            height: 230,
                            child: FittedBox(
                              child: Image.asset(
                                  AppConstants.getWeatherImage(
                                      "${this._weather?.currentObservation?.condition?.temperature}"),
                                  filterQuality: FilterQuality.high),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Center(
                            child: Text(
                                "${this._weather?.currentObservation?.condition?.temperature}°",
                                style: TextStyle(
                                    color: AppColors.SecondaryTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 60))),
                        Center(
                          child: Text(
                              "สูงสุด ${this._weather?.forecasts[0]?.high}° / ต่ำสุด ${this._weather?.forecasts[0]?.low}°"),
                        ),
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Card(
                                      shape: AppConstants.borderCard(),
                                      elevation: 0,
                                      color: Color(0xAAB9D7FF),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 25),
                                        child: Text(
                                            "${this._weather?.currentObservation?.atmosphere?.humidity}%",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      )),
                                  Text("โอกาสเกิดฝน")
                                ],
                              ),
                              Column(
                                children: [
                                  Card(
                                      shape: AppConstants.borderCard(),
                                      elevation: 0,
                                      color: Color(0xAAB9D7FF),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 25),
                                        child: Text(
                                            "${this._weather?.currentObservation?.wind?.speed}Km/h",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      )),
                                  Text("ลม")
                                ],
                              )
                            ]),
                        this.buildGridViewItems(),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: AppConstants.buttonHeight,
                          child: ElevatedButton(
                            onPressed: () => print("LiveWeatherMap"),
                            child: Text("แผนที่สภาพอากาศ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: 30)
                      ],
                    ),
                  ),
                )));
  }

  Widget buildGridViewItems() {
    if (this._weather.forecasts.length > 0) {
      return SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          primary: false,
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) => listDataItems(
              index == 0 ? 0 : this._weather.forecasts[index].date,
              this._weather.forecasts[index].high,
              this._weather.forecasts[index].low,
              this._weather.forecasts[index].text),
        ),
      );
    } else {
      return Center(
          child: Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    }
  }

  Widget listDataItems(int date, int high, int low, String text) {
    return Column(
      children: [
        Container(
          width: 150,
          child: Stack(children: [
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 70),
              elevation: AppConstants.elevation,
              shape: AppConstants.borderCard(),
              child: Container(
                width: 150,
                height: 120,
                alignment: Alignment.bottomCenter,
                child: Text("${((high + low) / 2).round()}°",
                    style: TextStyle(
                        color: AppColors.SecondaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 44)),
              ),
            ),
            Center(
              child: Container(
                width: 150,
                height: 140,
                child: FittedBox(
                  child: Image.asset(AppConstants.getWeatherImage(text)),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ]),
        ),
        SizedBox(height: 10),
        Text(
            "${date == 0 ? 'วันนี้' : DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(date * 1000))}",
            style: TextStyle(
                color: AppColors.SecondaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 20))
      ],
    );
  }
}
