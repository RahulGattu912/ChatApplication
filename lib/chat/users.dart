import 'package:chat_app_demo/chat/chat_room.dart';
import 'package:chat_app_demo/provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;
    return Scaffold(
        backgroundColor: themeData.colorScheme.tertiary,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: themeData.colorScheme.primary,
                ),
              );
            }
            if (!snapshot.hasData) {
              return Text(
                'No Users Found',
                style: themeData.textTheme.titleLarge,
              );
            }
            List<DocumentSnapshot> users = snapshot.data!.docs;
            List<Map<String, dynamic>> userMap =
                users.map((e) => e.data() as Map<String, dynamic>).toList();
            String? currentUserMail = FirebaseAuth.instance.currentUser?.email;
            String? currentUid = FirebaseAuth.instance.currentUser?.uid;
            for (int i = 0; i < userMap.length; i++) {
              if (userMap[i]['email'] == currentUserMail) {
                userMap.removeAt(i);
              }
            }

            return ListView.builder(
                itemCount: userMap.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                      senderID: currentUid!,
                                      receiverID: userMap[index]['uid'],
                                      receiverMail: userMap[index]['email'],
                                    )));
                      },
                      child: Stack(clipBehavior: Clip.none, children: [
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                              color: themeData.colorScheme.shadow,
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(
                              child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.person,
                                color: themeData.colorScheme.tertiary,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                userMap[index]['email'],
                                style: themeData.textTheme.titleLarge?.copyWith(
                                    color: themeData.colorScheme.tertiary),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                                  senderID: currentUid!,
                                                  receiverID: userMap[index]
                                                      ['uid'],
                                                  receiverMail: userMap[index]
                                                      ['email'],
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.message,
                                    color: themeData.colorScheme.tertiary,
                                  )),
                              const SizedBox(
                                width: 12,
                              ),
                            ],
                          )),
                        ),
                        // Positioned(
                        //     top: -8,
                        //     right: -8,
                        //     child: CountMessages(
                        //       chatRoomId: '',
                        //     )),
                      ]),
                    ),
                  );
                });
          },
        ));
  }
}
