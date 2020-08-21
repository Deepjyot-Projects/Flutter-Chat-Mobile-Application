import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id= "WelcomeScreen";


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

//TickerProviderStateAnimation is used when multiple animations.
// Mixin add capabilities to the class.
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller ;
  Animation animation1 ;
  Animation animation2 ;
  FirebaseAuth _auth=FirebaseAuth.instance ;


  @override
  void initState()  {
    // TODO: implement initState
//    var auth = FirebaseAuth.instance;
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        print("user is logged in");
        Navigator.pushNamed(context, ChatScreen.id);
      } else {
        print("user is not logged in");
        return;
      }
    },);


    super.initState();


    controller=AnimationController(
      duration: Duration(seconds: 1),
      upperBound: 1,
      vsync: this,         //TickerProvider..in this case WelocmeScreenSrate
    );

    animation1= CurvedAnimation(parent: controller ,curve: Curves.easeIn);
    animation2=ColorTween(begin: Colors.white,end: Colors.grey).animate(controller);
    controller.forward();      // ticker will go from 0 to 1....1/60 then 2/60 then 3/60 ro 0.002 and so on to 1

    controller.addListener(() {       // this method will executes every time it ticks our activity..but to make changes in state use setState .
        setState(() {});
//        print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation2.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation1.value *100,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text:['Flash Chat'],
                  speed: Duration(milliseconds: 500),
//                  stopPauseOnTap: true,
                  isRepeatingAnimation: false,
                  totalRepeatCount: 2,
                  pause: Duration(milliseconds:  2000),
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              id: LoginScreen.id,
              buttonText: "Log In",buttonColor: Colors.lightBlueAccent,
              onPress:(){
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(id: RegistrationScreen.id,
                buttonText: "Register",
                buttonColor: Colors.blueAccent,
              onPress: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
