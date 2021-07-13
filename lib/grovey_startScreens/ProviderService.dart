

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import './side.dart';

import 'gooey_edge.dart';

class ProviderService with ChangeNotifier  {
   int pageindex = 0; // index of the base (bottom) child
  int dragIndex; // index of the top child
  Offset dragOffset; // starting offset of the drag
  double dragDirection; // +1 when dragging left to right, -1 for right to left
  bool dragCompleted = false; // has the drag successfully resulted in a swipe
Ticker ticker;
  var ind=0;
  GooeyEdge edge= GooeyEdge(count: 25);
 bool login=false;
 bool signup=false;


   dispose() {
    ticker.dispose();
    notifyListeners();
    super.dispose();
  }

    tick(Duration duration) {
    edge.tick(duration);
    notifyListeners();
  }

  
  
 void handlePanDown(DragDownDetails details, Size size) {
    print('details1');
    print(details);
    print(size);
    print('size1');
    print(dragIndex);
    print(dragCompleted);
    print(pageindex);
    print('pageindex');

    if (dragIndex != null && dragCompleted) {

      pageindex = dragIndex;
      print(pageindex);
      notifyListeners();

    }
    dragOffset = details.localPosition;
    dragIndex = null;
    dragCompleted = false;
    dragDirection = 0;

    edge.farEdgeTension = 0.0;
    edge.edgeTension = 0.01;
    edge.reset();
      notifyListeners();

  }

  check(detail){
          //  pageindex = dragIndex;
    // //   pageindex=1;
    // //   // notifyListeners();
    // //     // dragOffset = details.localPosition;
    // // dragOffset = detail.localPosition;
    dragIndex = null;
    dragCompleted = false;
    // // dragDirection = 0;

    // // edge.farEdgeTension = 0.0;
    // // edge.edgeTension = 0.01;
    // edge.reset();
    //  edge.applyTouchOffset();
      notifyListeners();
  }

  void handlePanUpdate(DragUpdateDetails details, Size size) {
    print('details2');
    print(details);
    print(size);
    print('size2');
    double dx = details.globalPosition.dx - dragOffset.dx;

    if (!isSwipeActive(dx)) {
      return;
    }
    if (isSwipeComplete(dx, size.width)) {
      ind= dragIndex%3;
      notifyListeners();
      print(ind);
      print('ind');
      return;
    }

    if (dragDirection == -1) {
      dx = size.width + dx;
    }
    edge.applyTouchOffset(Offset(dx, details.localPosition.dy), size);
      notifyListeners();

  }

  bool isSwipeActive(double dx) {
    // check if a swipe is just starting:
    if (dragDirection == 0.0 && dx.abs() > 20.0) {
      dragDirection = dx.sign;
      edge.side = dragDirection == 1.0 ? Side.left : Side.right;
      // setState(() {
        dragIndex = pageindex - dragDirection.toInt();
      // });
    }
      notifyListeners();
    return dragDirection != 0.0;
  }

  bool isSwipeComplete(double dx, double width) {
    if (dragDirection == 0.0) {
      return false;
    } // haven't started
    if (dragCompleted) {
      return true;
    } // already done

    // check if swipe is just completed:
    double availW = dragOffset.dx;
    if (dragDirection == 1) {
      availW = width - availW;
    }
    double ratio = dx * dragDirection / availW;

    if (ratio > 0.8 && availW / width > 0.5) {
      dragCompleted = true;
      edge.farEdgeTension = 0.01;
      edge.edgeTension = 0.0;
      edge.applyTouchOffset();
    }
      notifyListeners();
    return dragCompleted;
  }

  Future<void> handlePanEnd(DragEndDetails details, Size size) async {
    print('details3');
    print(details);
    print(size);
    print('size3');
    edge.applyTouchOffset();
    // edge.reset();
    
    // dragCompleted=null;
      notifyListeners();
    // dragIndex=null;
    print(dragIndex);
    print(dragCompleted);
  }

  changeslogtatus(){
    login=true;
    signup=false;
    notifyListeners();
  }
  changessignuptatus(){
    login=false;
    signup=true;
    notifyListeners();
  }
  allfalse(){
    print(signup);
    if(signup == false){
    login=false;
    signup=false;
    notifyListeners();     
    }
  }
}