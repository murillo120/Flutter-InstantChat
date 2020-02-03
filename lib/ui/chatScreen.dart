import 'dart:io';

import 'package:InstantChat/ui/chatMessage.dart';
import 'package:InstantChat/ui/textComposer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final signIn = GoogleSignIn();
  FirebaseUser user;
  bool _isLoading = false;
  final scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
        this.user = user;
      });
    });

  }

  Future<FirebaseUser> getUser() async {
    if(this.user != null) return this.user;

    try{
      final signInAccount = await signIn.signIn();
      final signInAuth = await signInAccount.authentication;

      final auth = GoogleAuthProvider.getCredential(idToken: signInAuth.idToken, accessToken: signInAuth.accessToken);

      final authResult = await FirebaseAuth.instance.signInWithCredential(auth);

      final firebaseUser = authResult.user;

      return firebaseUser;
    }
    catch(error){
      return null;
    }
  }

  sendMessage({String msg, File imageFile}) async {

    final user = await getUser();

    if(user == null){

      scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text("não foi possivel executar o Login", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.yellow,
      ));
    }

    Map<String, dynamic> messagetypes = {
      'userid': user.uid,
      'sender': user.displayName,
      'senderphoto': user.photoUrl ,
      'time': Timestamp.now()
    };

    if (imageFile != null) {
      setState(() {
        this._isLoading = true;
      });
      

      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imageFile);

      StorageTaskSnapshot snap = await task.onComplete;
      String url = await snap.ref.getDownloadURL();

      setState(() {
        this._isLoading = false;
      });

      messagetypes['img'] = url;
    }

    if (msg != null) messagetypes['text'] = msg;

    Firestore.instance.collection('messages').add(messagetypes);
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
        appBar: AppBar(
          title: Text(user != null ? "Olá ${user.displayName}" : "Chat App", style: TextStyle(color: Colors.white)),
          elevation: 0,
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
          actions: <Widget>[
            user != null ? IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: (){
                FirebaseAuth.instance.signOut();
                signIn.signOut();

                scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text("Log out Efetuado!", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.green,
      ));
              },
            ) : Container()
            ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('messages').orderBy('time').snapshots(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    default:
                      List<DocumentSnapshot> snaplist =  snapshot.data.documents.reversed.toList();
                      return ListView.builder(
                        itemCount: snaplist.length,
                        reverse: true,
                        itemBuilder: (context, index){
                          return ChatMessage(snaplist[index].data, true);
                        },
                      );

                  }
                },
              ),
            ),
             _isLoading ? LinearProgressIndicator() : Container(),
             TextFieldComposer(sendMessage),
          ],
        ));
  }
}
