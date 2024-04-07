import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get instance of firestore (firestore dan örnek al)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // get instance of auth (authet' dan örnek al)
  final FirebaseAuth _auth = FirebaseAuth.instance;
  /*
    List<Map<String, dynamic>> = 
    [
     {
      "email": "test@example.com",
      "id": "1",
     }
     {
      "email": "ibrahim@example.com",
      "id": "1",
     }
    ]
  */
  // get user stream (kullanıcı akışını al)
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // send message (mesaj gönder)
  Future<void> sendMessage(String receiverID, String message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensure the chatRoomID is the same for any 2 people)
    String chatRoomID = ids.join("_");

    // add a new message to database
    await _firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").add(newMessage.toMap());
  }

  // get message (mesaj al)

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // constructa chatroom ID for the two users
    List<String> id = [userID, otherUserID];
    id.sort();
    String chatRoomID = id.join("_");

    return _firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }
}
