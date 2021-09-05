import 'package:flutter/material.dart';

class HeartAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback onEnd;

  HeartAnimationWidget({Key key, this.onEnd, this.child, this.duration=const Duration(milliseconds: 150), this.isAnimating})
      : super(key: key);

  @override
  _HeartAnimationWidgetState createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget> with SingleTickerProviderStateMixin{
   AnimationController controller;
   Animation<double> scale;
  @override
  void initState() {
    final halfduration=widget.duration.inMilliseconds ~/2;
    controller= AnimationController(vsync: this,duration: Duration(milliseconds: halfduration));
    scale= Tween<double>(begin: 1,end: 1.2).animate(controller);
    super.initState();
  }

  @override
  void didUpdateWidget( HeartAnimationWidget oldWidget) {
    
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimating !=oldWidget.isAnimating){
      doAnimation();
    }
  }

  doAnimation() async {
    if(widget.isAnimating){
    await controller.forward();
    await controller.reverse();

    // await Future.delayed(Duration(milliseconds:100));
    if(widget.onEnd !=null){
      print('here');
      widget.onEnd();
    }
    }
  }

  @override
  void dispose() {
   controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => ScaleTransition(scale: scale,child: widget.child,);
}
