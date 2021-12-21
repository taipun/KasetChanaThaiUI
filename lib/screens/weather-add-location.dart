import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/region.model.dart';
import 'package:kasetchana_flutter/models/user.model.dart';
import 'package:kasetchana_flutter/models/weather.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/services/user.service.dart';
import 'package:kasetchana_flutter/services/weather.service.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:kasetchana_flutter/widgets/toasts.dart';

class WeatherAddLocationScreen extends StatefulWidget {
  static const routeName = '/weather-add-location';

  @override
  _WeatherAddLocationScreenState createState() =>
      _WeatherAddLocationScreenState();
}

class _WeatherAddLocationScreenState extends State<WeatherAddLocationScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  Weather _weather = new Weather();
  User _user = new User();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitName() async {
    UserService()
        .getUserByEmail(await AuthService().decodeEmail())
        .then((res) => setState(() {
              this._user = res;
            }));
  }

  Future<void> onInitWeather() async {
    await WeatherService().getWeather().then((res) => setState(() {
          this._weather = res;
          this.isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitName();
      this.onInitWeather();
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "", []),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${this._weather?.location?.city}, ${this._weather?.location?.region}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey, thickness: 1.5),
                      SizedBox(height: 20),
                      this.buildFutureBuilder(context),
                    ],
                  ),
                )));
  }

  Widget buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: WeatherService().getRegion(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this.buildGridViewItems(snapshot.data);
        } else {
          return CustomWidgets.loading(context, 20);
        }
      },
    );
  }

  Widget buildGridViewItems(List<Region> model) {
    if (model.length > 0) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 220,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            primary: false,
            itemCount: model.length,
            itemBuilder: (BuildContext context, int index) =>
                listDataItems(model[index].nameEng)),
      );
    } else {
      return Center(
          child: Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    }
  }

  Widget listDataItems(String stationNameEnglish) {
    return GestureDetector(
      onTap: () => this.onSave(stationNameEnglish),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        width: 120,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            child: Text("$stationNameEnglish",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Future<void> onSave(String name) async {
    this._user.userRegion = name;
    await UserService().update(this._user).then((value) {
      Toasts.toastSuccess(context, 'บันทึกข้อมูลสำเร็จ', 1);
      Navigator.of(context).pop();
    });
  }
}
