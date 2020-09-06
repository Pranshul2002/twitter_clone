import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_clone/Pages/Tweet.dart';
import 'package:twitter_clone/main.dart';

class Home extends StatefulWidget {
  String email;

  Home(this.email);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color twitterColour = new Color(0xff00acee);
  String username = "";
  String name = "";
  List followers = [];
  List following = [];
  int selectedIndex = 0;
  String email;
  getEmail() async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   setState(() {
     email = sharedPreferences.get("email");
     print(email);
   });
 }
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
 initState(){
getUserData();
    super.initState();
  }
  getUserData() async {
   await getEmail();

   await FirebaseFirestore.instance.collection("user").doc(email).get().then((DocumentSnapshot ds) {
      setState(() {
        username = ds.data()["username"];
        name = ds.data()["name"];
        followers = ds.data()["followers"];
        following = ds.data()["following"];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder:(context) => IconButton(icon: Icon(Icons.menu,color: twitterColour,),onPressed: (){

            Scaffold.of(context).openDrawer();

          },),
        ),
        centerTitle: true,
        title: Icon(FontAwesomeIcons.twitter,color: twitterColour,),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left:16.0,top:16,bottom: 8),
                child: CircleAvatar(child: Icon(Icons.person,color: Color(0xff657686),size: 55,),radius: 35,backgroundColor: Color(0xffcbd7df),),
              ),
              Container(
                padding: EdgeInsets.only(left:16),
                alignment: Alignment.topLeft,
                child: Text(name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Container(
                padding: EdgeInsets.only(left:16,top: 5),
                alignment: Alignment.topLeft,
                child: Text("@"+username,style: TextStyle(fontSize:16,color: Color(0xff657686)),),
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0,top: 16.0,bottom: 16.0),
                child: Row(children: [
                  Text(following.length.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  Text(" Following    ",style: TextStyle(color: Color(0xff657686),fontSize: 16),),
                  Text(followers.length.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  Text(" Followers",style: TextStyle(color: Color(0xff657686),fontSize: 16),),
                ],),
              ),
              Divider(thickness: 1,),
              Container(
                child:    FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: twitterColour,
                  onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(currentIndex: selectedIndex,onTap: onItemTapped,items: [
        BottomNavigationBarItem(icon: Icon(Icons.home,),title: Text("")),
        BottomNavigationBarItem(icon: Icon(Icons.search),title: Text("")),
        BottomNavigationBarItem(icon: Icon(Icons.notifications,),title: Text("")),
        BottomNavigationBarItem(icon: Icon(Icons.email),title: Text("")),
      ],selectedItemColor: twitterColour,unselectedItemColor: Colors.grey,
       
      ),
      floatingActionButton: FloatingActionButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => Tweet())); },
      child: Icon(Icons.add),),
    body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("user").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(!snapshot.hasData){
            return Text("Loading");
          }
          else
            if(snapshot.hasError){
              Fluttertoast.showToast(msg: snapshot.hasError.toString(),toastLength: Toast.LENGTH_SHORT);
              return Container();
            }
        else
             {
               return ListView.builder(

                 itemCount: snapshot.data.docs.length,
                 itemBuilder: (context,index){
                   DocumentSnapshot ds  = snapshot.data.docs[index];

                   if(ds.id != "username")
                   return ListView.builder(
                       shrinkWrap: true,
                       itemCount: ds.data()["tweets"].length,itemBuilder: (context,i){

                     return Card(
                       child: Padding(
                         padding: const EdgeInsets.all(
                             5),
                         child: Container(
                         //  margin: EdgeInsets.all(8.0),
                           child: new Card(
                             child: Padding(
                               padding: const EdgeInsets.all(20.0),
                               child:
                               Column(
                                 children: [
                                   Row(children: [
                                     CircleAvatar(radius: 20,),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Container(
                                           alignment: Alignment.topLeft,
                                           padding: EdgeInsets.only(left: 15.0),
                                           child: Text(ds.data()["name"],style: TextStyle(fontSize: 17),),),
                                         Padding(padding: EdgeInsets.only(left: 15.0),
                                           child: Text("@"+ds.data()["username"],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),),
                                       ],
                                     )
                                   ],),
                                   Container(
                                     alignment: Alignment.topLeft,
                                     padding: EdgeInsets.only(top:16.0,left: 8.0,right: 8,bottom: 8),child: Text(ds.data()["tweets"][i]),)
                                 ],
                               ),
                             ),
                             shape: RoundedRectangleBorder(
                                 borderRadius:
                                 BorderRadius.circular(16.0)),
                           ),
                         ),
                       ),
                     );
                   });

                   return Container();
                 },
              );}
      },

    ),
    ), onWillPop: () => SystemNavigator.pop(animated: true),

    );
  }
}
