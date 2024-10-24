import 'package:chat_app_demo/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountMessages extends StatefulWidget {
  final String chatRoomId;
  const CountMessages({super.key, required this.chatRoomId});

  @override
  State<CountMessages> createState() => _CountMessagesState();
}

class _CountMessagesState extends State<CountMessages> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat_room')
            .doc(widget.chatRoomId)
            .collection('messages')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
                border: Border.all(color: themeData.colorScheme.shadow),
                borderRadius: BorderRadius.circular(24),
                color: themeData.colorScheme.tertiary),
          );
        });
  }
}
