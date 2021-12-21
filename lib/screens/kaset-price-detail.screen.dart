import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'quote-history.screen.dart';

class KasetPriceDetailScreen extends StatefulWidget {
  static const routeName = '/kaset-price-detail';

  @override
  _KasetPriceDetailScreenState createState() => _KasetPriceDetailScreenState();
}

class _KasetPriceDetailScreenState extends State<KasetPriceDetailScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String itemId = ModalRoute.of(context).settings.arguments;
    if (this.isLoading == true) {}

    List<SalesData> chartData = [
      SalesData(day: "จันทร์", sales: 20),
      SalesData(day: "อังคาร", sales: 30),
      SalesData(day: "พุธ", sales: 35),
      SalesData(day: "พฤหัส", sales: 50),
      SalesData(day: "ศุกร์", sales: 45),
      SalesData(day: "เสาร์", sales: 60),
      SalesData(day: "อาทิตย์", sales: 55)
    ];

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "$itemId", []),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("อาทิตย์นี้",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 10),
                              Text("+5.9%",
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 18)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => print("icon"),
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.black),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              IconButton(
                                onPressed: () => print("icon"),
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: Colors.black.withOpacity(0.4)),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              IconButton(
                                onPressed: () => print("icon"),
                                icon: Icon(Icons.add_outlined,
                                    color: Colors.black),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                            series: <ChartSeries>[
                          SplineSeries<SalesData, String>(
                              dataSource: chartData,
                              color: AppColors.primaryColor,
                              xValueMapper: (SalesData sales, _) => sales.day,
                              yValueMapper: (SalesData sales, _) => sales.sales)
                        ])),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      height: AppConstants.buttonHeight,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                            QuoteHistoryScreen.routeName,
                            arguments: itemId),
                        child: Text(
                          "ประวัติ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text("การเปลี่ยนแปลงใน52สัปดาห์",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        height: 10,
                        child: ClipRRect(
                          borderRadius: AppConstants.borderRadius(),
                          child: LinearProgressIndicator(
                              value: 0.2,
                              backgroundColor:
                                  AppColors.primaryColor.withOpacity(0.4)),
                        )),
                    Text("100-178")
                  ],
                ),
              ),
            ));
  }
}

class SalesData {
  SalesData({this.day, this.sales});
  final String day;
  final int sales;
}
