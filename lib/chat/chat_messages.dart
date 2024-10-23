import 'package:chat_app_demo/themes/light_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  final String chatRoomId;
  final String senderId;
  const ChatMessages(
      {super.key, required this.chatRoomId, required this.senderId});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  ThemeData themeData = lightMode;
  TextTheme textTheme = theme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.colorScheme.tertiary,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat_room')
              .doc(widget.chatRoomId)
              .collection('messages')
              .orderBy("timeStamp", descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Error',
                style: textTheme.titleLarge,
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No Message Yet!',
                  style: textTheme.titleLarge,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  'Loading...',
                  style: textTheme.titleLarge,
                ),
              );
            }
            return ListView(
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList(),
            );
          }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isSender = data['senderId'] == widget.senderId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          // Let the container size itself based on the text content
          decoration: BoxDecoration(
            color: isSender ? Colors.green : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: isSender ? const Radius.circular(12) : Radius.zero,
              topRight: isSender ? Radius.zero : const Radius.circular(12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Text(
              data['message'],
              style: TextStyle(
                  fontSize: 16,
                  color: isSender ? Colors.white : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
