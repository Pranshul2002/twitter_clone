import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_clone/Pages/LoginPage.dart';
import 'package:twitter_clone/Pages/SignUpPage.dart';

import 'Pages/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> getEmail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("email");
  }
  String email;
@override
  initState()  {
    try{
     setState(() async {
       email = await getEmail();
     });
    }catch(e){}
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
      theme: ThemeData(backgroundColor: Colors.white),
      home: (FirebaseAuth.instance.currentUser == null)?MyHomePage():Home(email),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color twitterColour = new Color(0xff00acee);



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(FontAwesomeIcons.twitter,color: twitterColour,)],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(child: Text("See what's happening",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),),
                  Container(child: Text("in the world right now.",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold)),),
               Padding(
                 padding: const EdgeInsets.all(32.0),
                 child: FlatButton(
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30.0),

                   ),
                   color: Colors.blueAccent,onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                 },
                 child: Row(children: [Expanded(child: Container(padding:EdgeInsets.all(10.0),alignment:Alignment.center,child: Text("SignUp",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)))],),),
               )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Already have a account ",style: TextStyle(color: Colors.grey),),GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("Login",style: TextStyle(color: Colors.blue),))],
              ),
            )
          ],
        ),
      ),
    );
  }
}
