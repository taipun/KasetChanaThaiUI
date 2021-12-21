import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/rain-monthly.model.dart';
import 'package:kasetchana_flutter/models/rain-weekly.model.dart';
import 'package:kasetchana_flutter/models/weather.model.dart';
import 'package:kasetchana_flutter/services/weather.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class RainMonthScreen extends StatefulWidget {
  static const routeName = '/rain-month';

  @override
  _RainMonthScreenState createState() => _RainMonthScreenState();
}

class _RainMonthScreenState extends State<RainMonthScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  bool isMonthly = true;

  Weather _weather = new Weather();
  RainWeekly _rainWeekly = new RainWeekly();
  RainMonthly _rainMonthly = new RainMonthly();

  List<SevenDaysForecast> data;
  TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onInitWeather() async {
    await WeatherService().getWeather().then((res) => setState(() async {
          this._weather = res;
          await WeatherService()
              .findOneCumulativeRain()
              .then((res) => setState(() async {
                    this._rainMonthly = res;
                    await WeatherService()
                        .findOneWeeklyCumulativeRain()
                        .then((res) => setState(() {
                              this._rainWeekly = res;
                              this.isLoading = false;
                            }));
                  }));
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${this._weather?.location?.city.toString().toUpperCase()}, ${this._weather?.location?.region.toString().toUpperCase()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 2)),
                    SizedBox(height: 20),
                    Card(
                        elevation: AppConstants.elevation,
                        shape: AppConstants.borderCard(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => this.isMonthly = true),
                              child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  shape: AppConstants.borderCard(),
                                  color: this.isMonthly == true
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 40),
                                    child: Text("รายเดือน",
                                        style: TextStyle(
                                            color: this.isMonthly == true
                                                ? Colors.white
                                                : AppColors.SecondaryTextColor,
                                            fontSize: 20)),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => this.isMonthly = false),
                              child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  shape: AppConstants.borderCard(),
                                  color: this.isMonthly == false
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 40),
                                    child: Text("รายอาทิตย์",
                                        style: TextStyle(
                                            color: this.isMonthly == false
                                                ? Colors.white
                                                : AppColors.SecondaryTextColor,
                                            fontSize: 20)),
                                  )),
                            )
                          ],
                        )),
                    SizedBox(height: 20),
                    this.isMonthly == true
                        ? this._buildMonthly(context)
                        : this._buildWeekly(context)
                  ],
                ),
              ),
            ));
  }

  Widget _buildMonthly(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jan ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallJAN}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("กุมภาพันธ์ ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallFEB}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("มีนาคม ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallMAR}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("เมษายน ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallAPR}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("พฤษภาคม ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallMAY}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("มิถุนายน ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallJUN}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("กรกฏาคม ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallJUL}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("สิงหาคม ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallAUG}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("กันยายน ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallSEP}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ตุลาคม ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallOCT}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("พฤศจิกายน ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallNOV}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: AppConstants.elevation,
            shape: AppConstants.borderCard(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  flex: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ธันวาคม ${this._rainMonthly.rmYear}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        Container(
                            height: 100,
                            child: VerticalDivider(
                                thickness: 1, color: Colors.grey)),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("วัดค่า",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "${this._rainMonthly?.rmMonthlyRainfall?.rmRainfallDEC}mm.",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekly(BuildContext context) {
    data = this._rainWeekly.rwSevenDaysForecast;
    _tooltip = TooltipBehavior(
        enable: true,
        color: Colors.white,
        duration: 1500,
        textStyle: TextStyle(color: Colors.black));

    return Container(
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 100, interval: 10),
          tooltipBehavior: _tooltip,
          series: <ChartSeries<SevenDaysForecast, String>>[
            ColumnSeries<SevenDaysForecast, String>(
                dataSource: data,
                xValueMapper: (SevenDaysForecast data, _) =>
                    DateFormat("dd MMM").format(DateTime.parse(
                        "${data.rwDate.split('/')[2]}-${data.rwDate.split('/')[1]}-${data.rwDate.split('/')[0].length == 1 ? '0' + data.rwDate.split('/')[0] : data.rwDate.split('/')[0]}")),
                yValueMapper: (SevenDaysForecast data, _) =>
                    int.parse(data.rwRain),
                name: '',
                width: 0.5,
                color: AppColors.primaryColor)
          ]),
    );
  }
}
