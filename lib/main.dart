import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kasetchana_flutter/screens/edit-profile.screen.dart';
import 'screens/add-asset.screen.dart';
import 'screens/forgot-password.screen.dart';
import 'screens/home.screen.dart';
import 'screens/kaset-plant-add.screen.dart';
import 'screens/kaset-plant-with-map.screen.dart';
import 'screens/kaset-price-detail.screen.dart';
import 'screens/kaset-price.screen.dart';
import 'screens/login.screen.dart';
import 'screens/measurementland.screen.dart';
import 'screens/plant-all.screen.dart';
import 'screens/plant-detail.screen.dart';
import 'screens/portfolio-history.screen.dart';
import 'screens/portfolio-with-hover-activated.screen.dart';
import 'screens/profile.screen.dart';
import 'screens/quote-history.screen.dart';
import 'screens/rain-month.screen.dart';
import 'screens/register.screen.dart';
import 'screens/search-kaset-price.screen.dart';
import 'screens/search-update-data-portfolio.screen.dart';
import 'screens/search-watch-list.screen.dart';
import 'screens/update-data-portfolio.screen.dart';
import 'screens/update-data.screen.dart';
import 'screens/watch-list-edit.screen.dart';
import 'screens/watch-list.screen.dart';
import 'screens/weather-add-location.dart';
import 'screens/weather-see-more.screen.dart';
import 'utilities/colors.dart';
import 'utilities/constants.dart';

void main() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([
    //   SystemUiOverlay.bottom,
    // ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
        primaryColor: AppColors.primaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              elevation:
                  MaterialStateProperty.all<double>(AppConstants.elevation),
              textStyle:
                  MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 20)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: AppConstants.borderRadius()))),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: AppConstants.borderRadius()),
          textTheme: ButtonTextTheme.primary,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: LoginScreen(),
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        PlantAllScreen.routeName: (context) => PlantAllScreen(),
        PlantDetailScreen.routeName: (context) => PlantDetailScreen(),
        WeatherSeeMoreScreen.routeName: (context) => WeatherSeeMoreScreen(),
        RainMonthScreen.routeName: (context) => RainMonthScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        KasetPriceScreen.routeName: (context) => KasetPriceScreen(),
        KasetPriceDetailScreen.routeName: (context) => KasetPriceDetailScreen(),
        QuoteHistoryScreen.routeName: (context) => QuoteHistoryScreen(),
        KasetPlantWithMapScreen.routeName: (context) =>
            KasetPlantWithMapScreen(),
        UpdateDataScreen.routeName: (context) => UpdateDataScreen(),
        AddAssetScreen.routeName: (context) => AddAssetScreen(),
        MeasurementlandScreen.routeName: (context) => MeasurementlandScreen(),
        WatchListScreen.routeName: (context) => WatchListScreen(),
        WatchListEditScreen.routeName: (context) => WatchListEditScreen(),
        PortfolioWithHoverActivatedScreen.routeName: (context) =>
            PortfolioWithHoverActivatedScreen(),
        PortfolioHistoryScreen.routeName: (context) => PortfolioHistoryScreen(),
        UpdateDataPortfolioScreen.routeName: (context) =>
            UpdateDataPortfolioScreen(),
        SearchUpdateDataPortfolioScreen.routeName: (context) =>
            SearchUpdateDataPortfolioScreen(),
        SearchWatchListScreen.routeName: (context) => SearchWatchListScreen(),
        SearchKasetPriceScreen.routeName: (context) => SearchKasetPriceScreen(),
        WeatherAddLocationScreen.routeName: (context) =>
            WeatherAddLocationScreen(),
        EditProfileScreen.routeName: (context) => EditProfileScreen(),
        KasetPlantAddScreen.routeName: (context) => KasetPlantAddScreen(),
      },
    );
  }
}
