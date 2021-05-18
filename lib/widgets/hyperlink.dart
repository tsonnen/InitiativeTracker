// Code Lovingly copied from: https://dev.to/guimg/hyperlink-widget-on-flutter-4fa5

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends StatelessWidget {
  final String _url;
  final String _text;

  Hyperlink(this._url, this._text);

  void _launchURL() async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchURL,
      child: Text(
        _text,
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
