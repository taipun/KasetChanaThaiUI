import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';

class StartCodeScreen extends StatefulWidget {
  static const routeName = '/start';

  @override
  _StartCodeScreenState createState() => _StartCodeScreenState();
}

class _StartCodeScreenState extends State<StartCodeScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {}

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "", []),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("StartPage"),
                )));
  }
}
