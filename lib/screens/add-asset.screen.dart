import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/kasetplan.model.dart';
import 'package:kasetchana_flutter/models/plant.model.dart';
import 'package:kasetchana_flutter/services/kasetplan.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:kasetchana_flutter/widgets/toasts.dart';

class AddAssetScreen extends StatefulWidget {
  static const routeName = '/add-asset';

  @override
  _AddAssetScreenState createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final ScrollController _scrollController = ScrollController();
  List<KasetplanAsset> _kasetplanAsset = <KasetplanAsset>[];
  List<String> selected = <String>[];

  bool isLoading = true;

  Kasetplan model = new Kasetplan();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onOnitData() async {
    await KasetplanService()
        .getOneKasetplan()
        .then((res) => setState(() {
              this.model = res;
              res.kasetAsset.forEach((element) async {
                setState(() {
                  this._kasetplanAsset.add(element);
                  this.selected.add(element.assetId);
                });
              });
              this.isLoading = false;
            }))
        .catchError((ex) => this.isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onOnitData();
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: this.buildFutureBuilder(context),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: AppConstants.buttonHeight,
            child: ElevatedButton(
              onPressed: () => this.onAddPlant(),
              child:
                  Text("เสร็จ", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ));
  }

  Widget buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: KasetplanService().findAll(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this.buildGridViewItems(snapshot.data, context);
        } else {
          return CustomWidgets.loading(context, 20);
        }
      },
    );
  }

  Widget buildGridViewItems(List<Plant> model, BuildContext context) {
    if (model.length > 0) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 30, childAspectRatio: 0.6),
          controller: _scrollController,
          primary: false,
          itemCount: model.length,
          itemBuilder: (BuildContext context, int index) =>
              listDataItems(model[index]),
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

  Widget listDataItems(Plant model) {
    return GestureDetector(
      onTap: () => setState(() {
        if (selected.contains(model.plantId)) {
          this
              ._kasetplanAsset
              .removeWhere((element) => element.assetId == model.plantId);
          this.selected.remove(model.plantId);
        } else {
          this._kasetplanAsset.add(KasetplanAsset(
              assetVolume: 0,
              assetPlantId: model.plantNumberId,
              assetName: model.plantName,
              assetDay: 0,
              assetAuto: false,
              assetPrice: 0,
              assetPhoto: model.plantPhoto,
              assetId: model.plantId));
          this.selected.add(model.plantId);
        }
      }),
      child: Stack(children: [
        Container(
          width: 120,
          height: 200,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 140,
                child: FittedBox(
                  child: Image.network(model.plantPhoto, loadingBuilder:
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
              Text(model.plantName)
            ],
          ),
        ),
        selected.contains(model.plantId)
            ? Center(
                child: Icon(Icons.check_circle,
                    color: AppColors.primaryColor, size: 40),
              )
            : Container()
      ]),
    );
  }

  Future<void> onAddPlant() async {
    model.kasetAsset = this._kasetplanAsset;
    if (this.model.kasetUId == null) {
      await KasetplanService().createKasetplan(model).then((res) {
        Navigator.of(context).pop();
        Toasts.toastSuccess(context, "บันทึกข้อมูลสำเร็จ", 1);
      }).catchError((ex) => Toasts.toastError(context, ex, 2));
    } else {
      await KasetplanService().updateKasetplan(model).then((res) {
        Navigator.of(context).pop();
        Toasts.toastSuccess(context, "บันทึกข้อมูลสำเร็จ", 1);
      }).catchError((ex) => Toasts.toastError(context, ex, 2));
    }
  }
}
