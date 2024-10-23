import 'package:chat_app_demo/chat/chat_room.dart';
import 'package:chat_app_demo/themes/light_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  ThemeData themeData = lightMode;
  TextTheme textTheme = theme;

  @override
  Widget build(BuildContext context) {
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
                style: textTheme.titleLarge,
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
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          color: themeData.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                          child: Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(Icons.person),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            userMap[index]['email'],
                            style: textTheme.titleLarge
                                ?.copyWith(color: themeData.colorScheme.shadow),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatRoom(
                                              senderID: currentUid!,
                                              receiverID: userMap[index]['uid'],
                                              receiverMail: userMap[index]
                                                  ['email'],
                                            )));
                              },
                              icon: const Icon(Icons.message))
                        ],
                      )),
                    ),
                  );
                });
          },
        ));
  }
}
