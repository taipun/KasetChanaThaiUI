import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kasetchana_flutter/models/kasetplan.model.dart';
import 'package:kasetchana_flutter/services/kasetplan.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:kasetchana_flutter/widgets/toasts.dart';

import 'add-asset.screen.dart';
import 'kaset-plant-add.screen.dart';
import 'measurementland.screen.dart';

class UpdateDataScreen extends StatefulWidget {
  static const routeName = '/update-data';

  @override
  _UpdateDataScreenState createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State<UpdateDataScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollCropController = ScrollController();
  TextEditingController _goldController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();

  bool isLoading = true;

  Kasetplan _kasetplant = new Kasetplan();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollCropController.dispose();
    super.dispose();
  }

  void onInitData() {
    KasetplanService().getOneKasetplan().then((value) => setState(() {
          this._kasetplant = value;
          this.isLoading = false;
          this._goldController.text = "${this._kasetplant.kasetEsimate}";
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
            appBar: CustomWidgets.appBar(context, "", [
              IconButton(
                icon: Icon(Icons.cloud_upload),
                color: Colors.black,
                onPressed: () => this.onSave(),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              )
            ]),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    primary: false,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(KasetPlantAddScreen.routeName)
                                .whenComplete(() => this.onInitData()),
                            child: Text("${this._kasetplant.planName}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.clip,
                                    letterSpacing: 2,
                                    color: AppColors.SecondaryTextColor)),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
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
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: AppConstants.buttonHeight,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(MeasurementlandScreen.routeName)
                                  .whenComplete(() => this.onInitData()),
                              child: Text("วัดขนาดที่ดิน",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("สินทรัพย์",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 20),
                          this.buildGridViewItems(),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: AppConstants.buttonHeight,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(AddAssetScreen.routeName)
                                  .whenComplete(() => this.onInitData()),
                              child: Text("เพิ่มสินทรัพย์",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("เก็บเกี่ยวอัตโนมัติ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 20),
                          this.buildGridViewItemsCrop(),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: AppConstants.buttonHeight,
                            child: ElevatedButton(
                              onPressed: () => print("เก็บเกี่ยวตอนนี้"),
                              child: Text("เก็บเกี่ยวตอนนี้",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("เป้าหมาย",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Material(
                              borderRadius: AppConstants.borderRadius(),
                              elevation: AppConstants.elevation,
                              child: TextFormField(
                                controller: _goldController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) => setState(() {
                                  this._kasetplant.kasetEsimate =
                                      int.tryParse(value) != null
                                          ? int.parse(value)
                                          : 0;
                                }),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 0, bottom: 0, left: 10, right: 10),
                                    suffixIcon: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(50),
                                            bottomRight: Radius.circular(50)),
                                      ),
                                      child: Text("ต่อเดือน",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppConstants.borderRadius(),
                                        borderSide: BorderSide(
                                            color: AppColors.borderColor)),
                                    border: OutlineInputBorder(
                                      borderRadius: AppConstants.borderRadius(),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                        ]),
                  )),
            ));
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
    TextEditingController _volumeController = TextEditingController();
    _volumeController.text =
        "${this._kasetplant.kasetAsset[index].assetVolume}";
    _volumeController.selection = TextSelection.fromPosition(
        TextPosition(offset: _volumeController.text.length));
    return Container(
      width: 120,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded(
          //     flex: 1,
          //     child: IconButton(
          //       icon: Icon(Icons.remove_circle),
          //       color: Colors.red,
          //       onPressed: () => print(assetId),
          //       splashColor: Colors.transparent,
          //       highlightColor: Colors.transparent,
          //     )),
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
            flex: 3,
            // flex: 2,
            child:
                Text(assetName, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Material(
                borderRadius: AppConstants.borderRadius(),
                elevation: AppConstants.elevation,
                child: TextFormField(
                  controller: _volumeController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {
                    this._kasetplant.kasetAsset[index].assetVolume =
                        int.tryParse(value) != null ? int.parse(value) : 0;
                  }),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 0, bottom: 0, left: 10, right: 10),
                      suffixIcon: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                        ),
                        child: Icon(Icons.check_outlined, color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: AppConstants.borderRadius(),
                          borderSide: BorderSide(color: AppColors.borderColor)),
                      border: OutlineInputBorder(
                        borderRadius: AppConstants.borderRadius(),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridViewItemsCrop() {
    if (this._kasetplant.kasetAsset.length > 0) {
      return SizedBox(
        height:
            double.parse(this._kasetplant.kasetAsset.length.toString()) * 220,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollCropController,
          primary: false,
          itemCount: this._kasetplant.kasetAsset.length,
          itemBuilder: (BuildContext context, int index) => listDataItemsCrop(
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

  Widget listDataItemsCrop(String assetId, String assetName, String assetPhoto,
      int assetVolume, int index) {
    TextEditingController _dayController = TextEditingController();
    _dayController.text = "${this._kasetplant.kasetAsset[index].assetDay}";
    _dayController.selection = TextSelection.fromPosition(
        TextPosition(offset: _dayController.text.length));
    return Container(
      width: 120,
      height: 180,
      child: Column(
        children: [
          Row(
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
                flex: 3,
                child: Text(assetName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 4,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: CupertinoSwitch(
                      activeColor: AppColors.primaryColor,
                      value: this._kasetplant.kasetAsset[index].assetAuto,
                      onChanged: (bool value) {
                        setState(() {
                          this._kasetplant.kasetAsset[index].assetAuto = value;
                        });
                      },
                    )),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Material(
              borderRadius: AppConstants.borderRadius(),
              elevation: AppConstants.elevation,
              child: TextFormField(
                controller: _dayController,
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() {
                  this._kasetplant.kasetAsset[index].assetDay =
                      int.tryParse(value) != null ? int.tryParse(value) : 0;
                }),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                    suffixIcon: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                      ),
                      child: Text("วัน",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: AppConstants.borderRadius(),
                        borderSide: BorderSide(color: AppColors.borderColor)),
                    border: OutlineInputBorder(
                      borderRadius: AppConstants.borderRadius(),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> onSave() async {
    if (this._kasetplant.kasetAsset.length == 0) {
      Toasts.toastWarning(context, "ไม่พบข้อมูล", 2);
    } else {
      await KasetplanService().updateKasetplan(this._kasetplant).then((res) {
        this.onInitData();
        Toasts.toastSuccess(context, "บันทึกข้อมูลสำเร็จ", 1);
      }).catchError((ex) => Toasts.toastError(context, ex, 2));
    }
  }
}
