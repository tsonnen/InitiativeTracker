import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/dialogs.dart';

class ThemePage extends StatefulWidget {
  static final String route = "Theme-Page";

  @override
  ThemePageState createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    ThemeData curr = DynamicTheme.of(context).data;
    return Scaffold(
        appBar: AppBar(
          title: Text('Custom Theme'),
        ),
        body: Container(
          child: ListView(
            children: [constructColor("Background", curr.backgroundColor)],
          ),
        ));
  }

  ListTile constructColor(String title, Color currColor) {
    return new ListTile(
      title: Text(title),
      trailing: new Container(
        child: Icon(
          Icons.favorite,
          color: currColor,
        ),
      ),
      onTap: () {
        Dialogs.colorDialog(context, currColor);
      },
    );
  }
}
