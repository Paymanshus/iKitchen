import 'package:flutter/material.dart';
import 'package:image_reader/main.dart';
import 'package:image_reader/pages/TfLiteHomeCam.dart';
import 'package:image_reader/pages/TfLiteHomeGallery.dart';
import 'package:image_reader/styles.dart';

import 'package:image_reader/UI/mini_cards.dart';
import 'PantryPage.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                child: Text(
                  'iKitchen',
                  style: headerTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  "Get started by Clicking a photo or Choosing one from the Gallery",
                  style: infoTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TfLiteHomeCam())),
                        child: MiniCards('Camera', Icons.camera_alt)),
                    SizedBox(width: 5),
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TfLiteHomeGallery())),
                        child: MiniCards('Gallery', Icons.wallpaper)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PantryPage())),
                child: Container(
                  width: size.width,
                  height: 180,
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black12,
                        offset: new Offset(0, 6),
                        blurRadius: 8,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                      colors: [blueCardStart, blueCardEnd],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'View Pantry',
                      style: tileTextStyle,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
