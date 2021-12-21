import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/watch.model.dart';
import 'package:kasetchana_flutter/services/watch.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'search-watch-list.screen.dart';

class WatchListEditScreen extends StatefulWidget {
  static const routeName = '/watch-list-edit';

  @override
  _WatchListEditScreenState createState() => _WatchListEditScreenState();
}

class _WatchListEditScreenState extends State<WatchListEditScreen> {
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
            appBar: AppBar(
                backgroundColor: AppColors.backgroundColor,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.check_outlined),
                  color: Colors.black,
                  onPressed: () => this.onSave(),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                title: Text("รายการโปรด",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                actions: [
                  IconButton(
                    icon: Icon(Icons.add_outlined),
                    color: Colors.black,
                    onPressed: () => Navigator.of(context)
                        .pushNamed(SearchWatchListScreen.routeName,
                            arguments: this.selected)
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
                              child: Text("รายการโปรดe 4",
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
                    this.buildListItems()
                  ],
                )),
            // bottomNavigationBar: BottomAppBar(
            //   elevation: 0,
            //   child: Container(
            //     padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            //     width: MediaQuery.of(context).size.width,
            //     height: AppConstants.buttonHeight,
            //     child: ElevatedButton(
            //       onPressed: () => null,
            //       style: ElevatedButton.styleFrom(primary: Colors.red),
            //       child: Text("Delete List"),
            //     ),
            //   ),
            // )
          );
  }

  Widget buildListItems() {
    return SizedBox(
      height: 300,
      child: ReorderableListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: this._watch.items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              shape: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
              contentPadding: EdgeInsets.zero,
              key: Key('$index'),
              leading: GestureDetector(
                  onTap: () =>
                      setState(() => this._watch.items.removeAt(index)),
                  child: Icon(Icons.remove_circle, color: Colors.red)),
              title: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text("${this._watch.items[index].name}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text("${this._watch.items[index].price}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            overflow: TextOverflow.clip)),
                  )
                ],
              ),
              trailing: Icon(Icons.menu));
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            WatchItem item = this._watch.items.removeAt(oldIndex);
            this._watch.items.insert(newIndex, item);
          });
        },
      ),
    );
  }

  Future<void> onSave() async {
    await WatchService().update(this._watch).then((res) {
      Navigator.of(context).pop();
    });
  }
}
