import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final String userId;

  const Messages({this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("chat")
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          print('List Build Again');
          final documents = streamSnapshot.data.documents;
          return ListView.builder(
              reverse: true,
              itemCount: documents.length,
              itemBuilder: (ctx, index) => MessageBubble(
                    key: ValueKey(documents[index].documentID),
                    message: documents[index]['text'],
                    username: documents[index]['username'],
                    isMe: documents[index]['userId'] == userId,
                    imageUrl: documents[index]['userImage'],
                  ));
        }
      },
    );
  }
}
