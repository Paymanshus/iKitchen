import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:simple_share/simple_share.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:image_reader/styles.dart';

class ImageReviewPage extends StatelessWidget {
  final String imagePath;
  final List recs;

  ImageReviewPage({Key key, @required this.imagePath, @required this.recs})
      : super(key: key);

  final GlobalKey _renderKey = new GlobalKey();
  final style = const TextStyle(
    color: Colors.purpleAccent,
    fontSize: 36,
    fontWeight: FontWeight.w800,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final image = Image.file(File(imagePath));
    final imageRatio = (image?.width ?? 1) / (image?.height ?? 1);
    print(image);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          RepaintBoundary(
            key: _renderKey,
            child: Stack(
              children: <Widget>[
                Transform.scale(
                  scale: imageRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      child: image ?? SizedBox(),
                      aspectRatio: imageRatio,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.center,
                        end: FractionalOffset.bottomCenter,
                        colors: [gradientStart, gradientStop],
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            bottom: 0,
                            child: Container(
                                height: size.height / 2.0,
                                width: size.width,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  begin: FractionalOffset.center,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [gradientStart, gradientStop],
                                )),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                        'Predicted Item is ${recs[0]["label"]}')
                                  ],
                                )),
                          ),
                          //For debugging:
                          // Align(alignment: Alignment.center,child: Text(classes.join(","), style: infoTextStyle),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AroundShareMenu(),
        ],
      ),
    );
  }
}

class AroundShareMenu extends StatelessWidget {
  const AroundShareMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
