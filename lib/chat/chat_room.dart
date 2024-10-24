import 'dart:async';
import 'package:chat_app_demo/chat/chat_messages.dart';
import 'package:chat_app_demo/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final String receiverMail;
  final String senderID;
  final String receiverID;

  const ChatRoom(
      {super.key,
      required this.senderID,
      required this.receiverID,
      required this.receiverMail});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late String chatRoomId;
  // bool _clear = false;
  // Timer? _clearTimer; // To store the periodic timer instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatRoomId = _generateId(widget.senderID, widget.receiverID);
    _createChatRoom(chatRoomId);

    // setState(() {
    //   _clear = true;
    // });

    // _clearTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
    //   if (_clear) {
    //     _clearChat();
    //   }
    // });
  }

  @override
  void dispose() {
    message.dispose();

    // _clearTimer?.cancel();

    super.dispose();
  }

  void _clearChat() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  String _generateId(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    return ids.join('_');
  }

  Future<void> _createChatRoom(String chatRoomID) async {
    await firestore
        .collection('chat_room')
        .doc(chatRoomID)
        .set({}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: themeData.colorScheme.shadow),
          backgroundColor: themeData.colorScheme.tertiary,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            widget.receiverMail,
            style: themeData.textTheme.titleLarge,
          ),
          leading: IconButton(
              onPressed: () {
                // setState(() {
                //   _clear = false;
                // });
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: themeData.colorScheme.shadow,
              )),
        ),
        backgroundColor: themeData.colorScheme.tertiary,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ChatMessages(
                  chatRoomId: chatRoomId,
                  senderId: widget.senderID,
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    style: themeData.textTheme.titleLarge
                        ?.copyWith(color: themeData.colorScheme.tertiary),
                    cursorColor: themeData.colorScheme.tertiary,
                    controller: message,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: themeData.colorScheme.shadow,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                width: 2.0,
                                color: themeData.colorScheme.shadow)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: themeData.colorScheme.primary))),
                  )),
                  IconButton(
                      onPressed: () async {
                        if (message.text.isNotEmpty) {
                          _sendMessage(
                              message: message.text,
                              receiverId: widget.receiverID,
                              senderId: widget.senderID,
                              roomId: chatRoomId);
                          message.clear();
                          await Future.delayed(const Duration(seconds: 5), () {
                            _clearChat();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: themeData.colorScheme.shadow,
                        size: 32,
                      ))
                ],
              )
            ],
          ),
        ));
  }

  Future<void> _sendMessage(
      {required String message,
      required String receiverId,
      required String senderId,
      required String roomId}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'message': message,
      'receiverId': receiverId,
      'senderId': widget.senderID,
      'timeStamp': Timestamp.now(),
    });
  }
}
