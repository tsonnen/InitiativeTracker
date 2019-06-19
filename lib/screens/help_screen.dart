import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpPage extends StatefulWidget {
  static final String route = "Help-Page";

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: FutureBuilder(
          future:
              DefaultAssetBundle.of(context).loadString('assets/data/help.md'),
          builder: (context, snapshot) {
            return Markdown(data: snapshot.data);
          }),
    );
  }
}
