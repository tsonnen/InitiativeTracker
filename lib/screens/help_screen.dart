import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  static final String route = 'Help-Page';

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  String markdown = '';
  String _currentPage;
  Queue backStack = Queue();
  Queue forwardStack = Queue();

  @override
  void initState() {
    super.initState();

    showHelp('table_contents');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Markdown(
        data: markdown,
        onTapLink: (text, hrewf, title) {
          if (hrewf.contains("help:")) {
            hrewf = hrewf.replaceAll("help:", "");
            backStack.addLast(_currentPage);
            forwardStack.clear();
            showHelp(hrewf);
          } else if (hrewf.contains("url:")) {
            hrewf = hrewf.replaceAll("url:", "");
            String url = hrewf;
            canLaunch(url).then((ableLaunch) {
              if (ableLaunch) {
                launch(url);
              } else {
                throw 'Could not launch $url';
              }
            });
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () {
                  if (backStack.isNotEmpty) {
                    forwardStack.addLast(_currentPage);
                    showHelp(backStack.removeLast());
                  }
                },
                color: backStack.isNotEmpty
                    ? Theme.of(context).buttonColor
                    : Theme.of(context).disabledColor,
              ),
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  if (forwardStack.isNotEmpty) {
                    backStack.addLast(_currentPage);
                    showHelp(forwardStack.removeLast());
                  }
                },
                color: forwardStack.isNotEmpty
                    ? Theme.of(context).buttonColor
                    : Theme.of(context).disabledColor,
              ),
            ]),
      ),
    );
  }

  void showHelp(String file) {
    loadHelpFile(file).then((value) {
      setState(() {
        markdown = value;
        _currentPage = file;
      });
    });
  }

  Future<String> loadHelpFile(String file) async {
    return await rootBundle.loadString('assets/help/' + file + '.md');
  }
}
