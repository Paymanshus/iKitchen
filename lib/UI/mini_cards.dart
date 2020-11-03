import 'package:flutter/material.dart';
import 'package:image_reader/styles.dart';

class MiniCards extends StatelessWidget {
  final cardStart = const Color(0xffEF473A);
  final cardEnd = const Color(0xffCB2D3E);

  String miniCardsText;
  IconData miniCardsIcon;

  MiniCards(this.miniCardsText, this.miniCardsIcon);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2.25,
      height: 200,
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.black12,
            offset: new Offset(0, 6),
            blurRadius: 8,
          )
        ],
        borderRadius: BorderRadius.circular(6.0),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [blueCardStart, blueCardEnd],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            miniCardsIcon,
            color: Colors.white,
            size: 35.0,
          ),
          Semantics(
            child: Text(
              miniCardsText.toString(),
              style: tileTextStyle,
            ),
            enabled: true,
          ),
        ],
      ),
    );
  }
}
