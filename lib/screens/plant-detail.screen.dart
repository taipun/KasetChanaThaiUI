import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/plant.model.dart';
import 'package:kasetchana_flutter/services/kasetplan.service.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';

class PlantDetailScreen extends StatefulWidget {
  static const routeName = '/plant-detail';

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  bool isLoading = true;
  Plant _plant = new Plant();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String itemId = ModalRoute.of(context).settings.arguments;
    if (this.isLoading == true) {
      KasetplanService().findOne(itemId).then((value) => setState(() {
            this._plant = value;
            this.isLoading = false;
          }));
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "", []),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text("${this._plant.plantName}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      overflow: TextOverflow.clip)),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              height: AppConstants.buttonHeight,
                              child: ElevatedButton(
                                onPressed: () => print("btn"),
                                child: Text("ซื้อเมล็ด",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("เวลาที่ใช้ในการปลูก"),
                                Text("${this._plant.plantTime} วัน")
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ปลูกได้"),
                                Text(
                                    "${this._plant.plantPersqrmeter} ต้นต่อ ตร.ม.")
                              ],
                            )
                          ],
                        ),
                        Container(
                          width: 280,
                          height: 260,
                          child: FittedBox(
                            child: Image.network(this._plant.plantPhoto,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                  width: 50,
                                  height: 50,
                                  child: CustomWidgets.loading(context, 5));
                            }),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          height: AppConstants.buttonHeight,
                          child: ElevatedButton(
                            onPressed: () => print("btn"),
                            child: Text(
                              "ผู้ใช้1,280คนปลูกสิ่งนี้ ${this._plant.plantName}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(child: Text(this._plant.plantDescription)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.only(top: 10),
                                height: AppConstants.buttonHeight,
                                child: ElevatedButton(
                                  onPressed: () => print("btn"),
                                  child: Text(
                                    "Visit ${this._plant.plantName} Forum",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: MaterialButton(
                                onPressed: () {},
                                elevation: AppConstants.elevation,
                                color: Colors.white,
                                child: Icon(
                                  Icons.favorite_border_outlined,
                                  size: 26,
                                ),
                                padding: EdgeInsets.all(15),
                                shape: CircleBorder(),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
