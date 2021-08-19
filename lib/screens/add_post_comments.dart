import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:toast/toast.dart';
import 'package:time_formatter/time_formatter.dart';


class Addpostcomment extends StatefulWidget {
  var postdata;
  Addpostcomment({@required this.postdata});

  @override
  _AddpostcommentState createState() => _AddpostcommentState();
}

class _AddpostcommentState extends State<Addpostcomment> {
  TextEditingController commentController = TextEditingController();
  List comments = [];
  @override
  void initState() {
    super.initState();
    comments = widget.postdata['comments'];
    setState(() {});
  }

  commentlist() {
    return List.generate(
        comments.length,
        (i) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/andy.png'),
                          backgroundColor: Colors.transparent,
                          minRadius: Sizes.RADIUS_20,
                          maxRadius: Sizes.RADIUS_20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                // Text(toBeginningOfSentenceCase('Saad_hafeez'),
                                //     style: TextStyle(
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.black)),
                                // SizedBox(
                                //   width: 4,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top:2.0),
                                //   child: Container(
                                //     child: Text(
                                //         toBeginningOfSentenceCase(
                                //             'Very nice pic kepp it up, Very nice pic kepp it up, Very nice pic kepp it up'),
                                //         style:
                                //             TextStyle(fontSize: 13, color: Colors.black)),
                                //   ),
                                // ),

                                RichText(
                                  text: TextSpan(
                                    // text: 'Hello ',
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: 'roboto'),
                                    children: [
                                      TextSpan(
                                          text: toBeginningOfSentenceCase(
                                              comments[i]['user']['cust_first_name'] + '  '),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: toBeginningOfSentenceCase(
                                          comments[i]['comment']),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(datechecker(comments[i]['created_at']),
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 15,
                  thickness: 1,
                  color: Colors.grey.shade200,
                )
              ],
            ));
  }

    datechecker(chkdate) {
    var datetime = DateTime.parse(chkdate);
    var newtime = Timestamp.fromDate(datetime);
    return formatTime(newtime.millisecondsSinceEpoch).toString();
  }


  addcomment(comment) async {
    AppService().commentpost(comment).then((value) async {
      print(value);
      if (value['success'] == true) {
        // comments.add(value['data']);
        var response = await AppService().getratingdata( widget.postdata['id'].toString());
        print(response);
        comments= response['data'][0]['comments'];
        commentController.text='';
        setState(() {
          
        });
      } else {
        // Toast.show('error', context, duration: 3);
        print('error');
      }
    });
    setState(() {});
  }

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
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 50,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
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
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    controller: commentController,
                    autofocus: true,
                    cursorColor: Colors.grey,
                    // onChanged: (val) {
                    //   if (commentController.text.trim() != '') {
                    //   } else {
                    //     Toast.show('Comment is empty', context, duration: 3);
                    //   }
                    //   setState(() {});
                    // },
                    decoration: InputDecoration(
                      hintText: "Write Comment",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 0),
                    ),
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                InkWell(
                  onTap: () {
                      FocusScope.of(context).unfocus();
                    if (commentController.text.trim() != '') {
                      var data = {
                        'review_id': widget.postdata['id'],
                        // 'Is_liked': reviewdata['Is_liked'] ? 1:0,
                        'comment': commentController.text
                      };
                      print('object');
                      addcomment(data);

                    } else {
                      Toast.show('Comment is empty', context, duration: 3);
                    }
                    setState(() {});
                  },
                  child: Container(
                    // alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: commentlist(),
          ),
        ),
      ),
    );
  }
}
