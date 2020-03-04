
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/ReusableButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class RegistrationScreen extends StatefulWidget {

  static const String id='registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  String email;
  String password;
  final _store = Firestore.instance;
  String name;
  final _auth=FirebaseAuth.instance;
  String phone;
  Map<String,String>mapp;

  bool loading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email=value;
                },
                decoration: kTextFieldStyle.copyWith(
                  hintText: 'Enter your Email',
                )
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value){
                  name=value;
                  var abc={"name":name};
                  mapp.addAll(abc);
                },
                decoration: kTextFieldStyle.copyWith(
                  hintText: 'Enter your Name'
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                onChanged: (value){
                  phone=value;
                },
                decoration: kTextFieldStyle.copyWith(
                    hintText: 'Enter your Number'
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password=value;

                },
                decoration: kTextFieldStyle.copyWith(
                  hintText: 'Enter your Password',
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              ReusableButton(
                text: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    loading=true;
                  });
                  try {
                    final newuser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newuser != null) {
                      _store.collection('userinfo').add({'email':email,'name':name,'phone':phone});
                      Navigator.pushNamed(context, Dashboard.id);
                    }
                    setState(() {
                      loading=false;
                    });
                  }catch(e)
                  {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
