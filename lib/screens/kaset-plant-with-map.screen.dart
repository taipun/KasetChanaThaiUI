import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kasetchana_flutter/models/kasetplan.model.dart';
import 'package:kasetchana_flutter/services/kasetplan.service.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'kaset-plant-add.screen.dart';
import 'update-data.screen.dart';

class KasetPlantWithMapScreen extends StatefulWidget {
  static const routeName = '/kaset-plant-with-map';

  @override
  _KasetPlantWithMapScreenState createState() =>
      _KasetPlantWithMapScreenState();
}

class _KasetPlantWithMapScreenState extends State<KasetPlantWithMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  Kasetplan _kasetplant = new Kasetplan();

  List<ChartSampleData> chartData = <ChartSampleData>[];

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitData() async {
    await KasetplanService().getOneKasetplan().then((value) => setState(() {
          this.chartData = <ChartSampleData>[];
          this._kasetplant = value;
          value.kasetAsset.forEach((element) async => setState(() {
                this.chartData.add(ChartSampleData(
                    x: element.assetName,
                    y: double.parse(element.assetVolume.toString()),
                    text: '${element.assetVolume}'));
              }));

          this.isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitData();
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  primary: true,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.7,
                            child: GoogleMap(
                              buildingsEnabled: false,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              mapToolbarEnabled: false,
                              zoomControlsEnabled: false,
                              mapType: MapType.terrain,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    double.parse(this._kasetplant.mapLat),
                                    double.parse(this._kasetplant.mapLng)),
                                zoom: this._kasetplant.mapZoom,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    padding: EdgeInsets.only(top: 50),
                                    icon: Icon(Icons.arrow_back),
                                    color: Colors.black,
                                    onPressed: () => Navigator.pop(context),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(
                                                KasetPlantAddScreen.routeName)
                                            .whenComplete(
                                                () => this.onInitData()),
                                        child: Text(
                                            "${this._kasetplant.planName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.clip,
                                                letterSpacing: 2,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 20),
                                      height: AppConstants.buttonHeight,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed(
                                                UpdateDataScreen.routeName)
                                            .whenComplete(
                                                () => this.onInitData()),
                                        child: Text("อัพเดทข้อมูล",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text("1,600 ตร.ม.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)),
                              ],
                            ),
                          )
                        ]),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text("สินทรัพย์ของคุณ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              this.buildGridViewItems()
                            ],
                          ),
                        ),
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
                      ]),
                )),
          );
  }

  Widget buildGridViewItems() {
    if (this._kasetplant.kasetAsset.length > 0) {
      return SizedBox(
        height:
            double.parse(this._kasetplant.kasetAsset.length.toString()) * 190,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          primary: false,
          itemCount: this._kasetplant.kasetAsset.length,
          itemBuilder: (BuildContext context, int index) => listDataItems(
              this._kasetplant.kasetAsset[index].assetId,
              this._kasetplant.kasetAsset[index].assetName,
              this._kasetplant.kasetAsset[index].assetPhoto,
              this._kasetplant.kasetAsset[index].assetVolume,
              index),
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

  Widget listDataItems(String assetId, String assetName, String assetPhoto,
      int assetVolume, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Container(
                width: 100,
                height: 90,
                child: FittedBox(
                  child: Image.network(assetPhoto, loadingBuilder:
                      (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                        width: 50,
                        height: 50,
                        child: CustomWidgets.loading(context, 5));
                  }),
                  fit: BoxFit.fill,
                ),
              )),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(assetName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("400 ตร.ม."),
                  Text("100 ต้น(โดยประมาณ)"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DoughnutSeries<ChartSampleData, String>> _getDefaultDoughnutSeries() {
    // final List<ChartSampleData> chartData = <ChartSampleData>[
    //   ChartSampleData(x: 'Chlorine', y: 55, text: '55%', color: Colors.red),
    //   ChartSampleData(x: 'Sodium', y: 31, text: '31%', color: Colors.green),
    //   ChartSampleData(
    //       x: 'Magnesium', y: 7.7, text: '7.7%', color: Colors.lightBlue),
    //   ChartSampleData(x: 'Sulfur', y: 3.7, text: '3.7%', color: Colors.yellow),
    //   ChartSampleData(x: 'Calcium', y: 1.2, text: '1.2%', color: Colors.pink),
    //   ChartSampleData(
    //       x: 'Others', y: 1.4, text: '1.4%', color: Colors.lightGreenAccent),
    // ];
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          radius: '80%',
          explode: false,
          explodeOffset: '10%',
          dataSource: this.chartData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          // pointColorMapper: (ChartSampleData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }
}

class ChartSampleData {
  ChartSampleData({this.x, this.y, this.text, this.color});

  final String x;
  final double y;
  final String text;
  final Color color;
}
