import 'package:flutter/material.dart';

import 'package:image_reader/UI/pantry_item.dart';

class PantryPage extends StatefulWidget {
  //PantryPage({Key key}) : super(key: key);

  @override
  PantryPageState createState() => PantryPageState();
}

class PantryPageState extends State<PantryPage> {
  // int _currentTab = 0;
  // final List<Widget> _children = [
  //   PantryPage(),
  //   DiscoverPage(),
  //   ProfilePage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 13),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF2E3131),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Text(
                        'Search Through Pantry',
                        style: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                    Expanded(
                      child: Icon(Icons.search,
                          color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 10),
                    child: Text(
                      'Pantry',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                child: Row(children: <Widget>[
                  Text(
                    'Past IDs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Spacer(flex: 5),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => print('See All'),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 30,
                      ),
                    ),
                  ),
                ]),
              ),
              PantryList(),
            ],
          ),
        ),
      ),
    );
  }
}
