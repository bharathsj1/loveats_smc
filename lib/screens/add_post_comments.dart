import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';
import 'package:toast/toast.dart';

class Addpostcomment extends StatefulWidget {
  var postdata;
  Addpostcomment({@required this.postdata});

  @override
  _AddpostcommentState createState() => _AddpostcommentState();
}

class _AddpostcommentState extends State<Addpostcomment> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(
          'Comments',
          style: TextStyle(color: AppColors.black),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
        ),
      ),
      bottomNavigationBar:Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 50,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom:10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 SizedBox(
                  width: 10,
                ),
                Container(
                   alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/andy.png'),
                    backgroundColor: Colors.transparent,
                    minRadius: Sizes.RADIUS_16,
                    maxRadius: Sizes.RADIUS_16,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.75,
                  child: TextField(
            controller: commentController,
            autofocus: true,
            cursorColor: Colors.grey,
            onChanged: (val) {
              if (commentController.text.trim() != '') {
               
              } else {
                 Toast.show('Comment is empty', context,
                                      duration: 3);
              }
              setState(() {});
            },
            decoration: InputDecoration(
                hintText: "Write Comment",
                border: InputBorder.none,
                
                contentPadding:
                    EdgeInsets.only(top:  0),
                ),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16
            ),
          ),),
                  SizedBox(
                  width: 0,
                ),
                  Container(
                    // alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Post',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),),),
               SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
