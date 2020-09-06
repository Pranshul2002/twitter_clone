import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color twitterColour = new Color(0xff00acee);
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool hidden = true;
String email;
  Future<String> getEmail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("email");
  }

  void _signInWithTwitter() async{
    try{
     UserCredential result = await _auth.signInWithEmailAndPassword(email: username.text.toLowerCase().trim(), password: password.text);
if(result.user != null)
 email = await getEmail();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(email)));

    }catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: "Error: "+ e.toString(),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: twitterColour),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: Icon(
                FontAwesomeIcons.twitter,
                color: twitterColour,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 10, top: 0),
                child: Text(
                  "Log in to Twitter.",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 16.0),
                      child: TextField(
                        controller: username,
                        decoration: InputDecoration(
                            labelText: 'Phone, email or username',
                            labelStyle: TextStyle(
                                color: Colors.grey.shade700, fontSize: 20)),
                        autofillHints: ["twitter username"],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 16.0),
                      child: TextField(
                        controller: password,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: hidden ? Colors.grey : twitterColour,
                              ),
                              onPressed: () {
                                if(mounted)
                                setState(() {
                                  hidden ? hidden = false : hidden = true;
                                });
                              },
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: Colors.grey.shade700, fontSize: 20)),
                        autofillHints: ["twitter password"],
                        obscureText: hidden,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: twitterColour,
                    onPressed: () {
                      _signInWithTwitter();

                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
