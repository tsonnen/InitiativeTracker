import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpPage extends StatefulWidget {
  static final String route = "Help-Page";

  @override
  HelpPageState createState() => HelpPageState();
}

//TODO: Add in navigation buttons to allow users to go back to their previous page
class HelpPageState extends State<HelpPage> {

  String markdown = '';

  @override
  void initState(){
    super.initState();

    showHelp("table_contents");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: new Markdown(
        data: markdown,
        onTapLink: (value){
          showHelp(value);
        },
      ),
    );
  }

  void showHelp(String file){
    loadHelpFile(file).then((value){
      setState(() {
        markdown = value;
      });
    });
  }

  Future<String> loadHelpFile(String file) async {
    return await rootBundle.loadString('assets/helpx/' + file + '.md');
  }
}
