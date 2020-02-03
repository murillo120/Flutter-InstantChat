import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextFieldComposer extends StatefulWidget {

  TextFieldComposer(this.sendMessage);

  final Function({String msg, File imageFile}) sendMessage;

  @override
  _TextFieldComposerState createState() => _TextFieldComposerState();
}

class _TextFieldComposerState extends State<TextFieldComposer> {

  final chatmessage = TextEditingController();
  bool iscomposing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              final File imagefile = await ImagePicker.pickImage(source: ImageSource.camera);
              if(imagefile == null) return;
              widget.sendMessage(imageFile: imagefile);
            },
          ),
          Expanded(
              child: TextField(
                controller: chatmessage,
            decoration: InputDecoration.collapsed(hintText: "Enviar mensagem"),
            onChanged: (text) {
              setState(() {
                iscomposing = text.isNotEmpty;
              });
            },
            onSubmitted: (text) {
              setState(() {
                widget.sendMessage(msg: text);
                chatmessage.clear();
                iscomposing = false;
              });
            },
          )),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: iscomposing ? () {
              setState(() {
                widget.sendMessage(msg: chatmessage.text);
                chatmessage.clear();
                iscomposing = false;
              });
            } : null,
          )
        ],
      ),
    );
  }
}
