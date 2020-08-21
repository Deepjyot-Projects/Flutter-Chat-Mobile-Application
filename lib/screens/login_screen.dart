import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
  static String id ="LoginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance ;
  FirebaseUser _user ;
  String email ;
  String password ;
  bool showSpinner=false;
  Future<bool> isUserValid(String email,String password) async {
    _user=await _auth.currentUser() ;
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    _user=result.user ;
    if(_user==null){
      print('Not a user.');
      return false;
    }else{
      print('Welcome.');
      return true;
    }

  }

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
                  //Do something with the user input.
                  email=value ;
                },
                style: kTextFieldStyle,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email: '),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password=value ;
                },
                style: kTextFieldStyle,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password: '),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(id: LoginScreen.id,buttonText: "Log In",buttonColor: Colors.lightBlueAccent, onPress: () async {
                try{
                  setState(() {
                    showSpinner=true ;
                  });

                  bool result= await isUserValid(email,password);
                  if(result==true){
                    print('Welcome the user .');
                    Navigator.pushNamed(context,ChatScreen.id);
                  }else{
                    print('Not a valid user.');
                  }
                  setState(() {
                    showSpinner=false;
                  });
                }catch(e){
                  print(e);
                  setState(() {
                    showSpinner=false ;
                  });
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
}
