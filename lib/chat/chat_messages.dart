import 'package:chat_app_demo/provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  final String chatRoomId;
  final String senderId;
  const ChatMessages(
      {super.key, required this.chatRoomId, required this.senderId});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(microseconds: 300), () => scrollDown());
      }
    });
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;
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
                style: themeData.textTheme.titleLarge,
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No Message Yet!',
                  style: themeData.textTheme.titleLarge,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  'Loading...',
                  style: themeData.textTheme.titleLarge,
                ),
              );
            }
            return ListView(
              controller: _scrollController,
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc, themeData))
                  .toList(),
            );
          }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, ThemeData themeData) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isSender = data['senderId'] == widget.senderId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
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
            child: Text(data['message'],
                style: themeData.textTheme.titleLarge?.copyWith(
                    color: isSender ? Colors.white : Colors.black54,
                    fontSize: 16)
                // TextStyle(

                //     fontSize: 16,
                //     color: isSender ? Colors.white : Colors.black54),
                ),
          ),
        ),
      ),
    );
  }
}
