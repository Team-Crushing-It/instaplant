import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Instaplant\n2020\n🏝',
                style: TextStyle(fontSize: 35),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('All Plants'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Plant Overview'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Social'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Requests'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Favourties'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Layout'),
              onTap: () {},
            ),
            ListTile(
              title: Text('About'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
