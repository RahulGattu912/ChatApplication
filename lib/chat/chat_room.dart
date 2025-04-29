import 'dart:async';
import 'package:chat_app_demo/chat/chat_messages.dart';
import 'package:chat_app_demo/provider/chat_room_id_provider.dart';
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
    return Consumer<ChatRoomIdProvider>(builder: (context, provider, _) {
      return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: themeData.colorScheme.shadow),
            backgroundColor: themeData.colorScheme.tertiary,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            title: Text(
              widget.receiverMail,
              style: themeData.textTheme.titleLarge,
            ),
            leading: IconButton(
                onPressed: () {
                  // setState(() {
                  //   _clear = false;
                  // });
                  provider.clearSelectedMessage();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: themeData.colorScheme.shadow,
                )),
            actions: [
              provider.selectedMessageCount > 0
                  ? IconButton(
                      onPressed: () {
                        provider.deleteSelectedMessages(chatroomID: chatRoomId);
                      },
                      icon:
                          const Icon(Icons.delete_forever, color: Colors.grey))
                  : const SizedBox.shrink(),
              // PopupMenuButton(
              //   itemBuilder: (context) {
              //     return [
              //       PopupMenuItem(
              //           child: Row(
              //         children: [
              //           const Icon(Icons.av_timer),
              //           const SizedBox(
              //             width: 12,
              //           ),
              //           Text(
              //               'Auto-delete messages every 7 days. To change click here',
              //               style: themeData.textTheme.titleLarge
              //                   ?.copyWith(color: Colors.black54, fontSize: 16))
              //         ],
              //       ))
              //     ];
              //   },
              // )
              // PopupMenuButton(
              //   icon:
              //       Icon(Icons.more_vert, color: themeData.colorScheme.shadow),
              //   itemBuilder: (context) => [
              //     const PopupMenuItem(

              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             children: [
              //               Icon(Icons.av_timer, color: Colors.black54),
              //               SizedBox(width: 10),
              //               Text(
              //                 'Auto-delete messages',
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SizedBox(height: 6),
              //           Text(
              //             'Messages will be deleted every 7 days automatically.',
              //             style: TextStyle(
              //               fontSize: 14,
              //               color: Colors.black54,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          backgroundColor: themeData.colorScheme.tertiary,
          body: PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                provider.clearSelectedMessage();
              }
            },
            child: Padding(
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
                              // await Future.delayed(const Duration(seconds: 5), () {
                              //   _clearChat();
                              // });
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
            ),
          ));
    });
  }

  Future<void> _sendMessage({
    required String message,
    required String receiverId,
    required String senderId,
    required String roomId,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final newMessageRef = firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .doc();

    await newMessageRef.set({
      'messageId': newMessageRef.id,
      'message': message,
      'receiverId': receiverId,
      'senderId': senderId,
      'timeStamp': Timestamp.now(),
    });
  }

  // Future<void> _sendMessage(
  //     {required String message,
  //     required String receiverId,
  //     required String senderId,
  //     required String roomId}) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   await firestore
  //       .collection('chat_room')
  //       .doc(chatRoomId)
  //       .collection('messages')
  //       .add({
  //     'message': message,
  //     'receiverId': receiverId,
  //     'senderId': widget.senderID,
  //     'timeStamp': Timestamp.now(),
  //   });
  // }
}
