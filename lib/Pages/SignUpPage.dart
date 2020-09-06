import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_clone/Pages/Home.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color twitterColour = new Color(0xff00acee);
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
List<dynamic> usernamelist = new List<dynamic>();
  @override
  void initState() {
  getUser();
    super.initState();
  }
void getUser()async{
    await FirebaseFirestore.instance.collection("user").doc("username").get().then((DocumentSnapshot ds){
      setState(() {
        usernamelist = ds.data()["usernames"];
      });
    });
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
          title:
            Center(
              child: Icon(
                FontAwesomeIcons.twitter,
                color: twitterColour,
              ),
            ),
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 10, top: 0),
                child: Text(
                  "Create your account",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    EdgeInsets.only(left: 10.0, right: 10.0, top: 16.0),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              color: Colors.grey.shade700, fontSize: 20)),
                      autofillHints: ["name"],
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(left: 10.0, right: 10.0, top: 16.0),
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                       /*   suffixIcon: IconButton(
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
                          ),*/
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                              color: Colors.grey.shade700, fontSize: 20)),
                      autofillHints: ["email"],
                     /* obscureText: hidden,*/
                    ),
                  ),
                ],
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Password(name.text,email.text,usernamelist)));
                    },
                    child: Text(
                      "Next",
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
class Password extends StatefulWidget {
  String name;
  String email;
  List<dynamic> usernamelist = new List<dynamic>();
  Password(this.name, this.email,this.usernamelist);

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool hidden = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color twitterColour = new Color(0xff00acee);

  Future<void> _signup(String email,String name,String password,String username)async{
    try{
      UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(user.user != null)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home(email.toLowerCase().trim())));
    }catch(e){
      Fluttertoast.showToast(msg: "Error: "+ e.toString(),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
    }
  }

  _saveemail(String email)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
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
                            labelText: 'Username',
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
                    onPressed: () async {
                      if(widget.usernamelist.any((element){
                        if(element == username.text.toLowerCase().trim())
                          return true;
                        return false;
                      }))
                        Fluttertoast.showToast(msg: "UserName already exists",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
                      else
                        {
                          FirebaseFirestore.instance.collection("user").doc("username").get().then((DocumentSnapshot ds){
                           List usernames =  ds.get("usernames");
                           usernames.add(username.text);
                           FirebaseFirestore.instance.collection("user").doc("username").set({"usernames":usernames});
                          });
                          FirebaseFirestore.instance.collection("user").doc(widget.email.toLowerCase().trim()).set({"name":widget.name.trim(),"username":username.text.trim(),"followers":[],"following":[],"tweets":[]});
                          await _signup(widget.email, widget.name, password.text, username.text);
                        await _saveemail(widget.email);
                        }

                    },
                    child: Text(
                      "SignUp",
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

