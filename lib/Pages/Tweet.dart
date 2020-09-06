import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tweet extends StatefulWidget {
  @override
  _TweetState createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  final Color twitterColour = new Color(0xff00acee);
  TextEditingController tweet = TextEditingController();
  String email;
 getEmail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       email = prefs.get("email");
     });
  }
  @override
  void initState() {
   getEmail();
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.white,elevation: 0,
      leading: IconButton(icon: Icon(Icons.close,color: twitterColour,),onPressed: (){
        Navigator.of(context).pop();
      },),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
              elevation:0,onPressed: (){
                if(tweet.text != null)
                  FirebaseFirestore.instance.collection("user").doc(email).get().then(((DocumentSnapshot ds){
                    List _tweets = ds.data()["tweets"];
_tweets.insert(0, tweet.text);
                    FirebaseFirestore.instance.collection("user").doc(email).update({"tweets" : _tweets}).then((value) {
                      Fluttertoast.showToast(msg: "Tweet posted",toastLength: Toast.LENGTH_SHORT);
                    });
                }));
          }, label: Text("Post",style: TextStyle(color: Colors.white),)),
        )
      ],
    ),
      body: Column(
children: [
  Row(
   //   direction: Axis.horizontal,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left:16.0,top:8),
          child: CircleAvatar(child: Icon(Icons.person,color: Color(0xff657686),size: 20,),radius: 15,backgroundColor: Color(0xffcbd7df),),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: tweet,
              decoration: InputDecoration(
                border: InputBorder.none,
                  hintText: "What's happening?",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade700, fontSize: 20)),

            ),
          ),
        ),
      ],
  )
],
      ),
    );
  }
}
