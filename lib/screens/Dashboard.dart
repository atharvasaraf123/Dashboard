
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  static const id='dashboard';


  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedUser;
  String message;
  String text;
  String name;
  String phone;
  final _store = Firestore.instance;

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    try {
      if (user != null) {
        loggedUser = user;
        print(loggedUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _store.collection('userinfo').snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData)
                  {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                final userinfo=snapshot.data.documents;
                for(var user in userinfo)
                {
                    final name=user.data['name'];
                    final email=user.data['email'];
                    final phone1=user.data['phone'];
                    if(email==loggedUser.email)
                      {
                        text=name;
                        phone=phone1;
                        break;
                      }
                }
                return
                    Center(
                      child: SafeArea(
                        child: Center(
                          child: Card(
                            color: Colors.red,
                            child: Center(
                              child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Name:  $text",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                      "Phone:  $phone",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                      "Email:  ${loggedUser.email}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    ),
                                  ),
                                )
                              ],
                              ),
                            ),


                          ),
                        ),
                      ),
                    );
              },
            )
          ],
        )
      ),
    );
  }
}
