import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TileDeleteActionRow extends StatelessWidget {
  final Icon actionIcon;
  final Function()? onDeleteTap;
  final Function()? onActionTap;

  TileDeleteActionRow(
      {required this.onDeleteTap,
      required this.actionIcon,
      required this.onActionTap});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: actionIcon,
          onPressed: onActionTap,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDeleteTap,
        )
      ],
    ));
  }
}
