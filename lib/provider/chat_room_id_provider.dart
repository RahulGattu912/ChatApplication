import 'package:flutter/material.dart';

class ChatRoomIdProvider extends ChangeNotifier {
  late String _chatRoomId;
  void set(String id) {
    _chatRoomId = id;
    notifyListeners();
  }

  void get chatRoomId => _chatRoomId;
}
