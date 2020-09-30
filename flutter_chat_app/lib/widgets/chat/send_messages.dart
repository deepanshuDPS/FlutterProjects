import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendMessages extends StatefulWidget {
  final String userId;

  const SendMessages({this.userId});

  @override
  _SendMessagesState createState() => _SendMessagesState();
}

class _SendMessagesState extends State<SendMessages> {
  var _enteredMessage = '';
  final textController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final username = await Firestore.instance
        .collection('users')
        .document(widget.userId)
        .get();
    Firestore.instance.collection("chat").document().setData({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': widget.userId,
      'username': username['username'],
      'userImage':username['image_url']
    });
    setState(() {
      _enteredMessage = '';
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(hintText: 'Send a Message'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).accentColor,
            ),
            onPressed: _enteredMessage.isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
