import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/watch.model.dart';
import 'package:kasetchana_flutter/services/watch.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';

import 'watch-list-edit.screen.dart';

class WatchListScreen extends StatefulWidget {
  static const routeName = '/watch-list';

  @override
  _WatchListScreenState createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  int selected = 1;

  Watch _watch = new Watch();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitData() async {
    await WatchService().findOne(this.selected).then((res) => setState(() {
          this._watch = res;
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
            appBar: CustomWidgets.appBar(context, "รายการโปรด", [
              IconButton(
                icon: Icon(Icons.add_outlined),
                color: Colors.black,
                onPressed: () => Navigator.of(context)
                    .pushNamed(WatchListEditScreen.routeName)
                    .whenComplete(() => this.onInitData()),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              )
            ]),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() {
                                this.selected = 1;
                                this.onInitData();
                              }),
                              child: Text("รายการโปรด 1",
                                  style: TextStyle(
                                      fontWeight: this.selected == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal)),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => setState(() {
                                this.selected = 2;
                                this.onInitData();
                              }),
                              child: Text("รายการโปรด 2",
                                  style: TextStyle(
                                      fontWeight: this.selected == 2
                                          ? FontWeight.bold
                                          : FontWeight.normal)),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => setState(() {
                                this.selected = 3;
                                this.onInitData();
                              }),
                              child: Text("รายการโปรด 3",
                                  style: TextStyle(
                                      fontWeight: this.selected == 3
                                          ? FontWeight.bold
                                          : FontWeight.normal)),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => setState(() {
                                this.selected = 4;
                                this.onInitData();
                              }),
                              child: Text("รายการโปรด 4",
                                  style: TextStyle(
                                      fontWeight: this.selected == 4
                                          ? FontWeight.bold
                                          : FontWeight.normal)),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => setState(() {
                                this.selected = 5;
                                this.onInitData();
                              }),
                              child: Text("รายการโปรด 5",
                                  style: TextStyle(
                                      fontWeight: this.selected == 5
                                          ? FontWeight.bold
                                          : FontWeight.normal)),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    this.buildGridViewItems()
                  ],
                )));
  }

  Widget buildGridViewItems() {
    if (this._watch.items.length > 0) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 150,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            primary: false,
            itemCount: this._watch.items.length,
            itemBuilder: (BuildContext context, int index) => listDataItems(
                this._watch.items[index].name, this._watch.items[index].price)),
      );
    } else {
      return Center(
          child: Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    }
  }

  Widget listDataItems(String name, double price) {
    return Container(
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
                  flex: 6,
                  child: Container(
                    child: Text("$name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis)),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Text("$price",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            overflow: TextOverflow.clip)),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey, thickness: 1.5)
        ],
      ),
    );
  }
}
