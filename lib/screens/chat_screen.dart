import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = "ChatScreen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = new TextEditingController();
  final _firestore =Firestore.instance ;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String messageText ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
//    messagesStream();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async{
                //Implement logout functionality
                await _auth.signOut();
                Navigator.pop(context);
//                 getMessages();

              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
              builder:(context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                  final messages= snapshot.data.documents ;
                  List<MessageBubble> messagesBubbles = [] ;
                  for(var message in messages){
                    final messageText = message.data['text'];
                    final messageSender=message.data['sender'];

                    if(messageText!=null && messageSender!=null){
                        final messageBubble=MessageBubble(sender: messageSender,message: messageText,isMe: messageSender==loggedInUser.email,);
                        messagesBubbles.add(messageBubble);
                    }
                  }
                  return Expanded(
                    child: ListView(
                      children: messagesBubbles,
                      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                    ),
                  );

              }
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller:_controller,
                      style:kTextFieldStyle ,
                      onChanged: (value) {
                        // Do something with the user input.
                        setState(() {
                          messageText=value ;
                        });
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if(messageText==null && messageText.trim()!='')
                          return ;
                      setState(() {
                        _controller.clear();
                      });
                      print('Message text is : $messageText');
                      if(messageText==null || messageText==''){
                        print('Message text is : $messageText');
                        return ;
                      }
                      _firestore.collection('messages').add({
                        'text':messageText ,
                        'sender':loggedInUser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      setState(() {
                        messageText=null;
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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


  void messagesStream() async{
    await for(var snapshot in  _firestore.collection('messages').snapshots())// returns stream of QueryStream...actually we are subscribing to it and we will receive any changes if it;s occurred.
      {
        for(var message in snapshot.documents){
          print(message.data);
        }
      }
  }

}



class MessageBubble extends StatelessWidget {
  String message , sender ;
  bool isMe ;
  MessageBubble({@required this.message,@required this.sender,@required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start ,
        children: <Widget>[
          Text(
              isMe? "" : sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54
            ),
          ),
          Material(
            elevation: 5.0,
            color: isMe? Colors.lightBlue:Colors.white70,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 20.0,
                  color: isMe ? Colors.white: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

