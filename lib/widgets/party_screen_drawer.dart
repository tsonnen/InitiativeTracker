import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:initiative_tracker/helpers/app_info.dart';
import 'package:initiative_tracker/screens/help_screen.dart';
import 'package:initiative_tracker/screens/party_management_screen.dart';
import 'package:initiative_tracker/screens/settings_screen.dart';

class PartyScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Initiative Tracker'),
          ),
          ListTile(
              leading: Icon(Icons.archive_rounded),
              title: Text('Saved Parties'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PartyManagementScreen(),
                  ),
                );
              }),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              }),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HelpPage()));
            },
          ),
          if (!kIsWeb)
            AboutListTile(
              applicationName: 'Initiative Tracker',
              icon: Icon(Icons.info),
              applicationIcon: Image.asset(
                'assets/images/app_image.png',
                scale: 15,
              ),
              applicationVersion: AppInfo.version,
              applicationLegalese: '\u{a9} 2021',
              aboutBoxChildren: [
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          style: Theme.of(context).textTheme.bodyText2,
                          text: 'This is a simple initiative tracker. Please'
                              ' send any questions or suggestions to '),
                      TextSpan(
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('mailto:tsonnenapps@gmail.com');
                            },
                          text: 'tsonnenapps@gmail.com'),
                      TextSpan(
                          style: Theme.of(context).textTheme.bodyText2,
                          text: '.'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
