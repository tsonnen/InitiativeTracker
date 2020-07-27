import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  MenuItem({this.icon, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        onTap: onTap,
    );
  }
}
