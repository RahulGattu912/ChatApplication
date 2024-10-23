import 'package:chat_app_demo/chat/chat_messages.dart';
import 'package:chat_app_demo/themes/light_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  ThemeData themeData = lightMode;
  TextTheme textTheme = theme;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatRoomId = _generateId(widget.senderID, widget.receiverID);
    _createChatRoom(chatRoomId);
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeData.colorScheme.tertiary,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            widget.receiverMail,
            style: textTheme.titleLarge,
          ),
        ),
        backgroundColor: Colors.white,
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
                    cursorColor: themeData.colorScheme.shadow,
                    controller: message,
                    decoration: InputDecoration(
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
                      onPressed: () {
                        _sendMessage(
                            message: message.text,
                            receiverId: widget.receiverID,
                            senderId: widget.senderID,
                            roomId: chatRoomId);
                        message.clear();
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
