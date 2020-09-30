import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../widgets/chat/send_messages.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final cloudMessaging = FirebaseMessaging();
    cloudMessaging.requestNotificationPermissions();
    cloudMessaging.configure(onMessage: (msg) {
      print('OnMessage $msg');
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print('OnResume $msg');
      return;
    });
    cloudMessaging.getToken().then((value) => {print('token $value')});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Screen'),
          actions: [
            DropdownButton(
              underline: Container(), // remove for some underline with color
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text('LogOut'),
                      ],
                    ),
                  ),
                  value: 'logout',
                )
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                print('Chat Screen Build');
                return Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Messages(
                          userId: dataSnapshot.data.uid,
                        ),
                      ),
                      SendMessages(
                        userId: dataSnapshot.data.uid,
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
