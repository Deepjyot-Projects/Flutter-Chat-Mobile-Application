//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_pref.dart';
class RegistrationScreen extends StatefulWidget {
  static String id="RegistrationScreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth =FirebaseAuth.instance ;
  String email ;
  String password ;
  FirebaseAuth _firebaseAuth ;
  bool showSpinner=false ;
  FirebaseUser firebaseUser ;




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email=value ;
                },
                style:kTextFieldStyle ,
                decoration:kTextFieldDecoration.copyWith(hintText: 'Enter your email: '),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password=value;
                },
                style: kTextFieldStyle,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password:'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(id: ChatScreen.id,buttonText: 'Register',buttonColor: Colors.blueAccent,
              onPress:() async{
                try{
                  setState(() {
                    showSpinner=true ;
                  });
                  final newUser=await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  if(newUser!=null){
                    SharedPref sh=await SharedPref();
                    sh.addStringToSF(key: kEmail_sh, value: email);
                    sh.addStringToSF(key: kPassword_sh, value: password);
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  setState(() {
                    showSpinner=false;
                  });
                }catch(e){
                  print(e);
                  setState(() {
                    showSpinner=false;
                  });
                }
              }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
