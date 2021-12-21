import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/port-log.model.dart';
import 'package:kasetchana_flutter/models/portfolio.model.dart';
import 'package:kasetchana_flutter/services/port-log.service.dart';
import 'package:kasetchana_flutter/services/portfolio.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:kasetchana_flutter/widgets/toasts.dart';

import 'search-update-data-portfolio.screen.dart';

class UpdateDataPortfolioScreen extends StatefulWidget {
  static const routeName = '/update-data-portfolio';

  @override
  _UpdateDataPortfolioScreenState createState() =>
      _UpdateDataPortfolioScreenState();
}

class _UpdateDataPortfolioScreenState extends State<UpdateDataPortfolioScreen> {
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  Portfolio _portfolio = new Portfolio();

  @override
  void initState() {
    super.initState();
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
      this.onIniteData();
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "", []),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    primary: true,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("สินทรัพย์",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(height: 20),
                        this.buildGridViewItems(),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          height: AppConstants.buttonHeight,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(
                                    SearchUpdateDataPortfolioScreen.routeName)
                                .whenComplete(() => this.onIniteData()),
                            child: Text(
                              "เพิ่มสินทรัพย์",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          height: AppConstants.buttonHeight,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () => this.onSave(),
                            child: Text(
                              "อัพเดท",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ));
  }

  Widget buildGridViewItems() {
    if (this._portfolio.items.length > 0) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 320,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            primary: false,
            itemCount: this._portfolio.items.length,
            itemBuilder: (BuildContext context, int index) =>
                listDataItems(this._portfolio.items[index].name, index)),
      );
    } else {
      return Center(
          child: Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    }
  }

  Widget listDataItems(String name, int index) {
    TextEditingController _volumeController = TextEditingController();
    _volumeController.text = "${this._portfolio.items[index].volume}";
    _volumeController.selection = TextSelection.fromPosition(
        TextPosition(offset: _volumeController.text.length));
    return Container(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.remove_circle),
                color: Colors.red,
                onPressed: () =>
                    setState(() => this._portfolio.items.removeAt(index)),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              )),
          Expanded(
              flex: 5,
              child: Container(
                child: Text("$name",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              )),
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
                    this._portfolio.items[index].volume =
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
                      ),
                      hintText: 'Volume'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSave() async {
    if (this._portfolio.pUserId == null) {
      Toasts.toastWarning(context, "ไม่พบข้อมูล", 2);
    } else {
      await PortfolioService().update(this._portfolio).then((res) async {
        int price = await PortfolioService().getSummaryItems();
        PortLog model = new PortLog();
        model.userId = this._portfolio.pUserId;
        model.price = double.parse(price.toString());
        await PortLogService().create(model).then((res2) {
          this.onIniteData();
          Toasts.toastSuccess(context, "บันทึกข้อมูลสำเร็จ", 1);
        });
      });
    }
  }
}
