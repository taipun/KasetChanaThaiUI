import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/kasetplan.model.dart';
import 'package:kasetchana_flutter/services/kasetplan.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:kasetchana_flutter/widgets/toasts.dart';

class KasetPlantAddScreen extends StatefulWidget {
  static const routeName = '/kaset-plant-add';

  @override
  _KasetPlantAddScreenState createState() => _KasetPlantAddScreenState();
}

class _KasetPlantAddScreenState extends State<KasetPlantAddScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;

  List<Kasetplan> _kasetplant = <Kasetplan>[];
  Kasetplan _kasetplantModel = new Kasetplan();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitData() async {
    await KasetplanService().getKasetplan().then((res) => setState(() {
          this._kasetplant = res;
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
            appBar: CustomWidgets.appBar(context, "", [
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('เพิ่มแผน'),
                          content: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Material(
                              borderRadius: AppConstants.borderRadius(),
                              elevation: AppConstants.elevation,
                              child: TextFormField(
                                onChanged: (value) => setState(() {
                                  this._kasetplantModel.planName = value;
                                }),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppConstants.borderRadius(),
                                        borderSide: BorderSide(
                                            color: AppColors.borderColor)),
                                    border: OutlineInputBorder(
                                      borderRadius: AppConstants.borderRadius(),
                                    ),
                                    hintText: 'ใส่ชื่อแผน'),
                              ),
                            ),
                          ),
                          actions: [
                            FlatButton(
                              textColor: AppColors.SecondaryTextColor,
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('ยกเลิก'),
                            ),
                            FlatButton(
                              onPressed: () => this.onCreate(),
                              child: Text('บันทึก'),
                            ),
                          ],
                        )).whenComplete(() => this.onInitData()),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              )
            ]),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: this.buildGridViewItems(),
                )));
  }

  Widget buildGridViewItems() {
    if (this._kasetplant.length > 0) {
      return SizedBox(
        height: 300,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            primary: false,
            itemCount: this._kasetplant.length,
            itemBuilder: (BuildContext context, int index) => listDataItems(
                this._kasetplant[index].planName,
                this._kasetplant[index].isActive,
                this._kasetplant[index])),
      );
    } else {
      return Center(
          child: Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    }
  }

  Widget listDataItems(String planName, bool isActive, Kasetplan model) {
    return GestureDetector(
      onTap: () => this.onSave(model),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        width: 120,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: isActive == true
                        ? Center(
                            child: Container(
                                child: Icon(
                            Icons.check,
                            color: Colors.lightGreen,
                          )))
                        : Container(),
                  ),
                  Expanded(
                    flex: 9,
                    child: Container(
                      child: Text("$planName"),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey, thickness: 1.5)
          ],
        ),
      ),
    );
  }

  Future<void> onSave(Kasetplan model) async {
    await KasetplanService().getOneKasetplan().then((res) async {
      res.isActive = false;
      await KasetplanService().updateKasetplan(res).then((value) {
        model.isActive = true;
      });
    });

    await KasetplanService().updateKasetplan(model).then((value2) {
      Toasts.toastSuccess(context, "เปลี่ยนข้อมูลสำเร็จ", 1);
      Navigator.of(context).pop();
    });
  }

  Future<void> onCreate() async {
    await KasetplanService().createKasetplan(this._kasetplantModel).then((res) {
      Toasts.toastSuccess(context, "เพิ่มข้อมูลสำเร็จ", 1);
      Navigator.of(context).pop();
    });
  }
}
