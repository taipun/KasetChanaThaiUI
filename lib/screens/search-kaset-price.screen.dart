import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/kaset-product.model.dart';
import 'package:kasetchana_flutter/services/kasetprice.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:intl/intl.dart';

import 'kaset-price-detail.screen.dart';

class SearchKasetPriceScreen extends StatefulWidget {
  static const routeName = '/search-kaset-price';

  @override
  _SearchKasetPriceScreenState createState() => _SearchKasetPriceScreenState();
}

class _SearchKasetPriceScreenState extends State<SearchKasetPriceScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  List<KasetProduct> kasetProduct = <KasetProduct>[];
  String date = DateFormat('yyyy-MM-dd').format(new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitProducts(String keyword) async {
    await KasetPriceService().findAll(keyword).then((value) => setState(() {
          this.kasetProduct = value;
          this.isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitProducts(null);
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            body: SafeArea(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Material(
                            borderRadius: AppConstants.borderRadius(),
                            elevation: AppConstants.elevation,
                            child: TextFormField(
                              onChanged: (value) => this.onInitProducts(value),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: AppConstants.borderRadius(),
                                      borderSide: BorderSide(
                                          color: AppColors.borderColor)),
                                  border: OutlineInputBorder(
                                    borderRadius: AppConstants.borderRadius(),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        this.buildGridViewItems()
                      ],
                    ),
                  )),
            ),
          ));
  }

  Widget buildGridViewItems() {
    if (this.kasetProduct.length > 0) {
      return SizedBox(
        height: 300,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            primary: false,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) => listDataItems(
                this.kasetProduct[index].productId,
                this.kasetProduct[index].productName,
                this.kasetProduct[index].categoryName,
                this.kasetProduct[index])),
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
      String categoryName, KasetProduct model) {
    return GestureDetector(
      onTap: () => Navigator.of(context).popAndPushNamed(
          KasetPriceDetailScreen.routeName,
          arguments: productId),
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
                    child: Center(child: Container(child: Icon(Icons.add))),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Text("$productName"),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Text("$categoryName", textAlign: TextAlign.end),
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
}
