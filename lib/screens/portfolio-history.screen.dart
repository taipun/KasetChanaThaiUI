import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasetchana_flutter/models/port-log.model.dart';
import 'package:kasetchana_flutter/models/portfolio.model.dart';
import 'package:kasetchana_flutter/services/port-log.service.dart';
import 'package:kasetchana_flutter/services/portfolio.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'kaset-price-detail.screen.dart';

class PortfolioHistoryScreen extends StatefulWidget {
  static const routeName = '/portfolio-history';

  @override
  _PortfolioHistoryScreenState createState() => _PortfolioHistoryScreenState();
}

class _PortfolioHistoryScreenState extends State<PortfolioHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  Portfolio _portfolio = new Portfolio();
  List<SalesData> lineChartData = <SalesData>[];
  List<PortLog> _portLog = <PortLog>[];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitLineChart() async {
    this.lineChartData = <SalesData>[];
    await PortLogService().findAll().then((res) => setState(() {
          this._portLog = res;
          int index = 1;
          res.forEach((element) {
            this.lineChartData.add(SalesData(
                day: "${element.date.split('T')[0]} - $index",
                sales: element.price.round()));
            index += 1;
          });
        }));
  }

  Future<void> onIniteData() async {
    await PortfolioService().findOne().then((res) => setState(() {
          this._portfolio = res;
          this.isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitLineChart();
      this.onIniteData();
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "", []),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("พอร์ตฟอลิโอ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.clip,
                              letterSpacing: 2,
                              color: AppColors.SecondaryTextColor)),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: GestureDetector(
                          onTap: () => this.onClickDatePicker(),
                          child: Card(
                            elevation: AppConstants.elevation,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppConstants.borderRadius()),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.date_range_outlined,
                                        size: 32),
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                            "${DateFormat('dd-MM-yyyy').format(startDate)} - ${DateFormat('dd-MM-yyyy').format(endDate)}"),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Icon(Icons.arrow_drop_down))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                      color: AppColors.primaryColor,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 490,
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text("สิ่งที่เกิดขึ้น",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20)),
                                this.buildGridViewItems()
                              ],
                            )),
                      ),
                    )
                  ],
                )));
  }

  Future<void> onClickDatePicker() async {
    return await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: this.startDate,
        end: this.endDate,
      ),
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'เลือกวันที่',
    )
        .then((value) => setState(() {
              this.startDate = value.start;
              this.endDate = value.end;
            }))
        .onError((error, stackTrace) => null);
  }

  Widget buildGridViewItems() {
    if (this._portLog.length > 0) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 560,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            primary: false,
            itemCount: this._portLog.length,
            itemBuilder: (BuildContext context, int index) => listDataItems(
                this._portLog[index].date, this._portLog[index].price, index)),
      );
    } else {
      return Center(
          child: Text(
        "",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    }
  }

  Widget listDataItems(String date, double price, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                    child: Text("${index + 1}",
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${date.split('T')[0]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white)),
                    Text("$price บาท", style: TextStyle(color: Colors.white)),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
