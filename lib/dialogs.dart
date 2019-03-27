import 'dart:async';

import 'package:flutter/material.dart';


enum DialogAction{yes, abort}

class Dialogs{
  static Future<DialogAction> yesAbortDialog(
    BuildContext context, 
    String title, 
    String body
  )async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: ( BuildContext context ){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: ()=>Navigator.of(context).pop(DialogAction.abort),
              child: const Text('no'),
            ),
            RaisedButton(
              onPressed: ()=>Navigator.of(context).pop(DialogAction.yes),
              child: const Text('yes', 
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }

  static Future<String> inputDialog(
    BuildContext context, 
    String title,
    String hint, 
  )async {
    final inputTextController = TextEditingController();
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: ( BuildContext context ){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
            controller: inputTextController,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: ()=>Navigator.of(context).pop(DialogAction.abort),
              child: const Text('no'),
            ),
            RaisedButton(
              onPressed: ()=>Navigator.of(context).pop(DialogAction.yes),
              child: const Text('yes', 
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null && action != DialogAction.abort) 
      ? inputTextController.text : null;
  } 
}