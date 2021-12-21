import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/kaset-product.model.dart';
import 'package:kasetchana_flutter/screens/search-kaset-price.screen.dart';
import 'package:kasetchana_flutter/services/kasetprice.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';

import 'kaset-price-detail.screen.dart';

class KasetPriceScreen extends StatefulWidget {
  static const routeName = '/kaset-price';

  @override
  _KasetPriceScreenState createState() => _KasetPriceScreenState();
}

class _KasetPriceScreenState extends State<KasetPriceScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  String selectedType = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onInitData() async {
    await KasetPriceService().findAllGroup().then((res) => setState(() {
          this.selectedType = res[0].groupName;
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
            appBar: CustomWidgets.appBar(context, "ราคาเกษตร", [
              RotatedBox(
                quarterTurns: 1,
                child: IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(SearchKasetPriceScreen.routeName),
                  icon: Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              )
            ]),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                primary: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: this.buildFutureBuilderGroup(context),
                    ),
                    SizedBox(height: 20),
                    this.buildFutureBuilder(context)
                  ],
                ),
              ),
            ));
  }

  Widget buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: KasetPriceService().getProductByGroup(this.selectedType),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this.buildGridViewItems(snapshot.data);
        } else {
          return CustomWidgets.loading(context, 20);
        }
      },
    );
  }

  Widget buildGridViewItems(List<KasetProduct> model) {
    if (model.length > 0) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 150,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          primary: false,
          itemCount: model.length,
          itemBuilder: (BuildContext context, int index) => listDataItems(
              model[index].productId,
              model[index].productName,
              model[index].categoryName,
              model[index].productPrice),
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

  Widget listDataItems(String productId, String productName,
      String categoryName, double productPrice) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
          context, KasetPriceDetailScreen.routeName,
          arguments: productId),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(productName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.clip)),
                      // Text(categoryName,
                      //     style: TextStyle(
                      //         fontSize: 15, overflow: TextOverflow.clip)),
                      Text("ประเภท $categoryName",
                          style: TextStyle(
                              fontSize: 14, overflow: TextOverflow.clip)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '$productPrice',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFutureBuilderGroup(BuildContext context) {
    return FutureBuilder(
      future: KasetPriceService().findAllGroup(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this.buildGridViewItemsGroup(snapshot.data);
        } else {
          return CustomWidgets.loading(context, 20);
        }
      },
    );
  }

  Widget buildGridViewItemsGroup(List<KasetProductGroup> model) {
    if (model.length > 0) {
      return SizedBox(
        height: 20,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          primary: false,
          itemCount: model.length,
          itemBuilder: (BuildContext context, int index) =>
              listDataItemsGroup(model[index].groupName),
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

  Widget listDataItemsGroup(String groupName) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () => setState(() => this.selectedType = "$groupName"),
        child: Text("$groupName",
            style: TextStyle(
                fontWeight: this.selectedType == "$groupName"
                    ? FontWeight.bold
                    : FontWeight.normal)),
      ),
    );
  }
}
