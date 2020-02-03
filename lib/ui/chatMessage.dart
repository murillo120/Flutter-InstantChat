import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data, this.mine);
  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: <Widget>[
          !mine
              ? CircleAvatar(backgroundImage: NetworkImage(data['senderphoto']))
              : Container(),
          Expanded(
              child: Padding(
            padding: !mine  ? EdgeInsets.only(left: 10.0) : EdgeInsets.only(right: 10.0),
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                data['img'] != null
                    ? Image.network(
                        data['img'],
                        width: 200,
                        height: 200,
                      )
                    : Text(
                        data['text'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                Text(
                  data['sender'],
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          )),
          mine
              ? CircleAvatar(backgroundImage: NetworkImage(data['senderphoto']))
              : Container(),
        ],
      ),
    );
  }
}
