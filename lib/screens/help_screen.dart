import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpPage extends StatefulWidget {
  static final String route = "Help-Page";

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {

  String markdown = '';

  @override
  void initState(){
    super.initState();

    loadHelpFile().then((value){
      setState(() {
        markdown = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: new Markdown(data: markdown),
    );
  }

  Future<String> loadHelpFile() async {
    return await rootBundle.loadString('assets/data/help.md');
  }
}
