import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kasetchana_flutter/models/kaset-product.model.dart';
import 'package:kasetchana_flutter/models/plant.model.dart';
import 'package:kasetchana_flutter/models/user.model.dart';
import 'package:kasetchana_flutter/models/weather.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/services/kasetplan.service.dart';
import 'package:kasetchana_flutter/services/kasetprice.service.dart';
import 'package:kasetchana_flutter/services/portfolio.service.dart';
import 'package:kasetchana_flutter/services/user.service.dart';
import 'package:kasetchana_flutter/services/weather.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'kaset-plant-add.screen.dart';
import 'kaset-plant-with-map.screen.dart';
import 'kaset-price.screen.dart';
import 'plant-all.screen.dart';
import 'plant-detail.screen.dart';
import 'portfolio-with-hover-activated.screen.dart';
import 'profile.screen.dart';
import 'watch-list.screen.dart';
import 'weather-see-more.screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  User _user = new User();
  Weather _weather = new Weather();
  List<KasetProduct> _kasetPrice = <KasetProduct>[];
  bool isLoading = true;
  String date = DateFormat('yyyy-MM-dd').format(new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
  int totalWealth = 0;

  @override
  void initState() {
    this.onInitName();
    this.onInitTotalWealth();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onInitName() async {
    UserService()
        .getUserByEmail(await AuthService().decodeEmail())
        .then((res) => setState(() {
              this._user = res;
              this.onInitWeather();
            }));
  }

  Future<void> onInitTotalWealth() async {
    await PortfolioService().getSummaryItems().then((res) => setState(() {
          this.totalWealth = res;
        }));
  }

  Future<void> onInitWeather() async {
    await KasetPriceService().findAll('').then((res) => setState(() {
          this._kasetPrice = res;
        }));
    await WeatherService().getWeather().then((res) => setState(() {
          this._weather = res;
          this.isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    )),
                    color: AppColors.primaryColor,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(ProfileScreen.routeName)
                                      .whenComplete(() => this.onInitName()),
                                  icon: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(WatchListScreen.routeName),
                                  icon: Icon(
                                    Icons.favorite_border_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                "สวัสดี ${this._user?.userName?.split(' ')[0]}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold)),
                            Text("วันนี้อากาศดี",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                "${this._weather?.location?.city}, ${this._weather?.location?.region}",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                    "${this._weather?.currentObservation?.condition?.temperature}°C",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                SizedBox(width: 20),
                                Icon(FontAwesomeIcons.umbrella,
                                    size: 14, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                    "${this._weather?.currentObservation?.atmosphere?.humidity}%",
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(width: 20),
                                Icon(FontAwesomeIcons.wind,
                                    size: 14, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                    "${this._weather?.currentObservation?.wind?.speed}%",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(WeatherSeeMoreScreen.routeName)
                                  .whenComplete(() => this.onInitWeather()),
                              child: Text("ดูเพิ่มเติม",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(height: 20),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(KasetPlantWithMapScreen
                                                .routeName),
                                        child: Card(
                                            elevation: 5,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: AppConstants
                                                        .borderCardRadius(),
                                                    topLeft: AppConstants
                                                        .borderCardRadius())),
                                            child: Container(
                                                height: 120,
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text("1,600 ตร.ม.",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24),
                                                        textAlign:
                                                            TextAlign.center),
                                                    Text("ขนาดที่ดิน"),
                                                  ],
                                                ))),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(
                                                PortfolioWithHoverActivatedScreen
                                                    .routeName)
                                            .whenComplete(
                                                () => this.onInitTotalWealth()),
                                        child: Card(
                                            elevation: 10,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight: AppConstants
                                                        .borderCardRadius(),
                                                    topRight: AppConstants
                                                        .borderCardRadius())),
                                            child: Container(
                                                height: 120,
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text("$totalWealth บาท",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24),
                                                        textAlign:
                                                            TextAlign.center),
                                                    Text("สินทรัพย์รวม"),
                                                  ],
                                                ))),
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width,
                              height: AppConstants.buttonHeight,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(KasetPlantAddScreen.routeName),
                                child: Text("สร้างแผนการเกษตรใหม่",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: SafeArea(
                        top: false,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("พืชผักที่น่าสนใจ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(PlantAllScreen.routeName),
                                  child: Text("ดูเพิ่มเติม",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            this.buildFutureBuilder(context),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ราคาเกษตร",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(KasetPriceScreen.routeName),
                                  child: Text("ดูเพิ่มเติม",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Card(
                              margin: EdgeInsets.zero,
                              elevation: AppConstants.elevation,
                              shape: AppConstants.borderCard(),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                              "${this._kasetPrice[0]?.productName}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${this._kasetPrice[0]?.productPrice}",
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Divider(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                              "${this._kasetPrice[100]?.productName}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${this._kasetPrice[100]?.productPrice}",
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                              "${this._kasetPrice[200]?.productName}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${this._kasetPrice[200]?.productPrice}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
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
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          primary: false,
          itemCount: 5,
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
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        elevation: AppConstants.elevation,
        shape: AppConstants.borderCard(),
        child: Container(
          width: 120,
          height: 150,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 90,
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
      ),
    );
  }
}
