import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomIdProvider extends ChangeNotifier {
  late String _chatRoomId;

  Set<String> selectedMessageID = {};

  int get selectedMessageCount => selectedMessageID.length;

  void clearSelectedMessage() {
    selectedMessageID.clear();
    notifyListeners();
  }

  void addToSelectedMessage({required String messageId}) {
    selectedMessageID.add(messageId);
    notifyListeners();
  }

  void removeSelectedMessage({required String messageId}) {
    selectedMessageID.remove(messageId);
    notifyListeners();
  }

  void deleteSelectedMessages({required String chatroomID}) async {
    final firestore = FirebaseFirestore.instance;

    final batch = firestore.batch();

    for (String messageId in selectedMessageID) {
      final docRef = firestore
          .collection('chat_room')
          .doc(chatroomID)
          .collection('messages')
          .doc(messageId);
      batch.delete(docRef);
    }

    try {
      await batch.commit();
      selectedMessageID.clear();
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting messages: $e");
    }
  }

  void set(String id) {
    _chatRoomId = id;
    notifyListeners();
  }

  void get chatRoomId => _chatRoomId;
}
