import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';

class CustomWidgets {
  static Widget appBar(
      BuildContext context, String title, List<Widget> actionItems) {
    return AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: actionItems);
  }

  static Widget loading(BuildContext context, double radius) {
    return Container(
        child: Center(child: CupertinoActivityIndicator(radius: radius)));
  }
}
