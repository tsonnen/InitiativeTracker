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
            Icon(this.icon),
            Expanded(
              child: Text(
                this.label,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        onTap: onTap,
    );
  }
}
