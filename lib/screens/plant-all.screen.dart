import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/plant.model.dart';
import 'package:kasetchana_flutter/services/kasetplan.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';

import 'plant-detail.screen.dart';

class PlantAllScreen extends StatefulWidget {
  static const routeName = '/plant-all';

  @override
  _PlantAllScreenState createState() => _PlantAllScreenState();
}

class _PlantAllScreenState extends State<PlantAllScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets.appBar(context, "", [
          RotatedBox(
            quarterTurns: 1,
            child: IconButton(
              icon: Icon(Icons.search_outlined),
              color: Colors.black,
              onPressed: () => print("search"),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          )
        ]),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("พืชผัก", style: TextStyle(fontSize: 32)),
              SizedBox(height: 20),
              this.buildFutureBuilder(context),
            ],
          ),
        ));
  }

  Widget buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: KasetplanService().findAll(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this.buildGridViewItems(snapshot.data);
        } else {
          return CustomWidgets.loading(context, 20);
        }
      },
    );
  }

  Widget buildGridViewItems(List<Plant> model) {
    if (model.length > 0) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 30, childAspectRatio: 0.6),
          controller: _scrollController,
          primary: false,
          itemCount: model.length,
          itemBuilder: (BuildContext context, int index) => listDataItems(
              model[index].plantPhoto,
              model[index].plantName,
              model[index].plantId),
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

  Widget listDataItems(String plantPhoto, String plantName, String plantId) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, PlantDetailScreen.routeName,
          arguments: plantId),
      child: Container(
        width: 120,
        height: 200,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 140,
              child: FittedBox(
                child: Image.network(plantPhoto, loadingBuilder:
                    (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                      width: 50,
                      height: 50,
                      child: CustomWidgets.loading(context, 5));
                }, errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Container(
                      width: 50,
                      height: 50,
                      child: CustomWidgets.loading(context, 5));
                }),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 20),
            Text(plantName)
          ],
        ),
      ),
    );
  }
}
