import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatefulWidget {
  static const routeName = '/article-detail';

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("ArticleDetailScreen"),
    ));
  }
}
