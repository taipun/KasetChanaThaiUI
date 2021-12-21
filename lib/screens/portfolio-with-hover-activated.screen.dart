import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/port-log.model.dart';
import 'package:kasetchana_flutter/models/portfolio.model.dart';
import 'package:kasetchana_flutter/services/port-log.service.dart';
import 'package:kasetchana_flutter/services/portfolio.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'portfolio-history.screen.dart';
import 'update-data-portfolio.screen.dart';

class PortfolioWithHoverActivatedScreen extends StatefulWidget {
  static const routeName = '/portfolio-with-hover-activated';

  @override
  _PortfolioWithHoverActivatedScreenState createState() =>
      _PortfolioWithHoverActivatedScreenState();
}

class _PortfolioWithHoverActivatedScreenState
    extends State<PortfolioWithHoverActivatedScreen> {
  bool isLoading = true;
  Portfolio _portfolio = new Portfolio();
  final ScrollController _scrollController = ScrollController();
  List<ChartSampleData> _chartData = <ChartSampleData>[
    // ChartSampleData(x: 'RSS3 Rubber', y: 54, text: '54%'),
    // ChartSampleData(x: 'Fattening Pig', y: 30, text: '30%'),
    // ChartSampleData(x: 'Crude Palm Oil', y: 26, text: '26%'),
  ];

  List<SalesData> lineChartData = <SalesData>[];

  int totalWelath = 0;
  List<PortLog> _chartLine = <PortLog>[];

  @override
  void initState() {
    super.initState();
  }

  Future<void> onIniteData() async {
    this._chartData = <ChartSampleData>[];
    await PortfolioService().findOne().then((res) => setState(() {
          this._portfolio = res;

          this._portfolio.items.forEach((element) {
            this._chartData.add(ChartSampleData(
                x: element.name,
                y: double.parse(element.volume.toString()),
                text: '${element.volume}'));
          });
          this.isLoading = false;
        }));
  }

  Future<void> onInitTotalWelath() async {
    await PortfolioService().getSummaryItems().then((res) => setState(() {
          this.totalWelath = res;
        }));
  }

  Future<void> onInitLineChart() async {
    this.lineChartData = <SalesData>[];
    await PortLogService().findAll().then((res) => setState(() {
          this._chartLine = res;
          int index = 1;
          res.forEach((element) {
            this.lineChartData.add(SalesData(
                day: "${element.date.split('T')[0]} - $index",
                sales: element.price.round()));
            index += 1;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitTotalWelath();
      this.onInitLineChart();
      this.onIniteData();
    }

    // List<SalesData> lineChartData = [
    //   SalesData(day: "8", sales: 20),
    //   SalesData(day: "13", sales: 15),
    //   SalesData(day: "18", sales: 35),
    //   SalesData(day: "23", sales: 25)
    // ];

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "", []),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text("พอร์ตฟอลิโอ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.clip,
                                    letterSpacing: 2,
                                    color: AppColors.SecondaryTextColor)),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            height: AppConstants.buttonHeight,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(
                                      UpdateDataPortfolioScreen.routeName)
                                  .whenComplete(() {
                                this.onInitTotalWelath();
                                this.onInitLineChart();
                                this.onIniteData();
                              }),
                              child: Text("อัพเดทข้อมูล",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                      Text("$totalWelath บาท",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)),
                      // Text("+59% From last month",
                      //     style: TextStyle(
                      //         color: AppColors.primaryColor, fontSize: 16)),
                      Container(
                          child: SfCartesianChart(
                              plotAreaBorderWidth: 0,
                              primaryXAxis: CategoryAxis(
                                axisLine: AxisLine(width: 0),
                                majorGridLines: MajorGridLines(width: 0),
                              ),
                              primaryYAxis: CategoryAxis(
                                isVisible: false,
                                axisLine: AxisLine(width: 0),
                                majorGridLines: MajorGridLines(width: 0),
                              ),
                              legend: Legend(
                                  position: LegendPosition.bottom,
                                  isVisible: false,
                                  toggleSeriesVisibility: false),
                              series: <ChartSeries>[
                            SplineSeries<SalesData, String>(
                              color: Colors.purple,
                              name: "สินทรัพย์รวม + สินทรัพย์ที่ขายไป",
                              dataSource: this.lineChartData,
                              xValueMapper: (SalesData sales, _) => sales.day,
                              yValueMapper: (SalesData sales, _) => sales.sales,
                            )
                          ])),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        height: AppConstants.buttonHeight,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(PortfolioHistoryScreen.routeName),
                          child: Text(
                            "ประวัติ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text("เป้าหมายของเดือนนี้"),
                      SizedBox(height: 20),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          height: 5,
                          child: ClipRRect(
                            borderRadius: AppConstants.borderRadius(),
                            child: LinearProgressIndicator(
                                value: 0.2,
                                color: Colors.lightBlue,
                                backgroundColor:
                                    Colors.lightBlue.withOpacity(0.4)),
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("ปัจจุบัน",
                                      style: TextStyle(
                                          letterSpacing: 2, fontSize: 10)),
                                  Text("\$812.72"),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("เป้าหมาย",
                                      style: TextStyle(
                                          letterSpacing: 2, fontSize: 10)),
                                  Text("\$1200.00"),
                                ],
                              ),
                            ],
                          )),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text("ชื่อ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text("ปริมาณ",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 3,
                              child: Text("มูลค่าตลาด",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(height: 20),
                      this.buildGridViewItems(),
                      Container(
                        child: SfCircularChart(
                          title: ChartTitle(
                            text: "การแบ่งพื้นที่ของคุณ",
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.far,
                          ),
                          legend: Legend(
                              isVisible: true, toggleSeriesVisibility: false),
                          series: _getDefaultDoughnutSeries(),
                          tooltipBehavior: TooltipBehavior(
                              enable: true,
                              color: Colors.white,
                              duration: 1500,
                              textStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                )));
  }

  List<DoughnutSeries<ChartSampleData, String>> _getDefaultDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          radius: '100%',
          explode: false,
          dataSource: this._chartData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          // pointColorMapper: (ChartSampleData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }

  Widget buildGridViewItems() {
    if (this._portfolio.items.length > 0) {
      return SizedBox(
        height: double.parse(this._portfolio.items.length.toString()) * 60,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            physics: NeverScrollableScrollPhysics(),
            primary: false,
            itemCount: this._portfolio.items.length,
            itemBuilder: (BuildContext context, int index) => listDataItems(
                this._portfolio.items[index].productId,
                this._portfolio.items[index].volume,
                this._portfolio.items[index].name,
                this._portfolio.items[index].price,
                index)),
      );
    } else {
      return Center(
          child: Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    }
  }

  Widget listDataItems(
      String productId, int volume, String name, double price, int index) {
    return Container(
      width: 120,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Expanded(
                  flex: 5,
                  child: Text("$name",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
                  child: Text("${this._portfolio.items[index].volume}",
                      textAlign: TextAlign.center)),
              Expanded(
                  flex: 3,
                  child: Text(
                    "${this._portfolio.items[index].volume * price}",
                    textAlign: TextAlign.center,
                  ))
            ]),
          ),
          Divider(thickness: 1, color: Colors.grey)
        ],
      ),
    );
  }
}

class SalesData {
  SalesData({this.day, this.sales});
  final String day;
  final int sales;
}

class ChartSampleData {
  ChartSampleData({this.x, this.y, this.text, this.color});

  final String x;
  final double y;
  final String text;
  final Color color;
}
