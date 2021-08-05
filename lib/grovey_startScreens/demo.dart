import 'package:flutter/material.dart';

import 'content_card.dart';
import 'gooey_carousel.dart';

class GooeyEdgeDemo extends StatefulWidget {
  GooeyEdgeDemo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GooeyEdgeDemoState createState() => _GooeyEdgeDemoState();
}

class _GooeyEdgeDemoState extends State<GooeyEdgeDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GooeyCarousel(
        children: <Widget>[
          ContentCard(
            color: 'Red',
            altColor: Color(0xFF4259B2),
            title: "Wake up gently \nwith sounds of nature",
            subtitle:
                'Relax your mind and create inner peace with soothing sounds of nature.',
            buttontext: 'Get Started',
          ),
          ContentCard(
            color: 'Yellow',
            altColor: Color(0xFF904E93),
            title: "Ready to lick your fingers",
            subtitle: 'Taste our authentic Indian cuisines',
            buttontext: 'Get Started',
          ),
          ContentCard(
            color: 'Blue',
            altColor: Color(0xFFFFB138),
            title: "Keep clam and eat our Korean dishes",
            subtitle:
                'Fun fact - "There are hundreds of different types of kimchi"',
            buttontext: 'Login',
          ),
        ],
      ),
    );
  }
}
