import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/models/media_model.dart';
import 'package:gogo_online/src/models/message.dart';

class DB{
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection(AppConstants.USERS_COLLECTION);
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection(AppConstants.ALL_MESSAGES_COLLECTION);

  Stream<QuerySnapshot> getContactsStream() {
    return FirebaseFirestore.instance.collection(AppConstants.USERS_COLLECTION).snapshots();
  }

  Stream<DocumentSnapshot> getUserContactsStream(String uid) {
    return _usersCollection.doc(uid).snapshots();
  }

  Future<DocumentSnapshot> getUser(String id) {
    return _usersCollection.doc(id).get();
  }

  void addNewMessage(String groupId, DateTime timeStamp, dynamic data) {
    try {
      _messagesCollection
          .doc(groupId)
          .collection(AppConstants.CHATS_COLLECTION)
          .doc(timeStamp.millisecondsSinceEpoch.toString())
          .set(data);
    } catch (error) {
      print('****************** DB addNewMessage error **********************');
      print(error);
      throw error;
    }
  }

  Future<QuerySnapshot> getChatItemData(String groupId, [int limit = 20]) {
    try {
      return _messagesCollection
          .doc(groupId)
          .collection(AppConstants.CHATS_COLLECTION)
          .orderBy('timeStamp', descending: true)
          .limit(limit)
          .get();
    } catch (error) {
      print(
          '****************** DB getChatItemData error **********************');
      throw error;
    }
  }

  void addMediaUrl(String groupId, String url, Message mediaMsg) {
    try {
      _messagesCollection
          .doc(groupId)
          .collection(AppConstants.MEDIA_COLLECTION)
          .doc(mediaMsg.timeStamp)
          .set(MediaModel.fromMsgToMap(mediaMsg));
    } catch (error) {
      print('****************** DB addMediaUrl error **********************');
      print(error);
      throw error;
    }
  }

  Stream<QuerySnapshot> getMediaCount(String groupId) {
    try {
      return _messagesCollection
          .doc(groupId)
          .collection(AppConstants.MEDIA_COLLECTION)
          .snapshots();
    } catch (error) {
      print('****************** DB getMediaCount error **********************');
      print(error);
      throw error;
    }
  }

  Stream<QuerySnapshot> getChatMediaStream(String groupId) {
    try {
      return _messagesCollection
          .doc(groupId)
          .collection(AppConstants.MEDIA_COLLECTION)
          .snapshots();
    } catch (error) {
      print('****************** DB getChatMedia error **********************');
      print(error);
      throw error;
    }
  }

  void updateContacts(String userId, dynamic contacts) {
    try {
      _usersCollection
          .doc(userId)
          .set({'contacts': contacts}, SetOptions(merge: true));
    } catch (error) {
      print(
          '****************** DB updateContacts error **********************');
      print(error);
      throw error;
    }
  }

  Future<DocumentSnapshot> addToPeerContacts(
      String peerId, String newContact) async {
    DocumentReference doc;
    DocumentSnapshot docSnapshot;

    try {
      doc = _usersCollection.doc(peerId);
      docSnapshot = await doc.get();

      var peerContacts = [];

      List<dynamic> contacts = docSnapshot.get(FieldPath(['contacts']));
      contacts.forEach((element) =>peerContacts.add(element));
      // docSnapshot.data['contacts'].forEach((elem) => peerContacts.add(elem));
      peerContacts.add(newContact);;

      FirebaseFirestore.instance.runTransaction((transaction) async {
        final freshDoc = await transaction.get(doc);
        transaction.update(freshDoc.reference, {'contacts': peerContacts});
      });

      // doc.setData({'contacts': peerContacts}, merge: true);
    } catch (error) {
      print(
          '****************** DB addToPeerContacts error **********************');
      print(error);
      throw error;
    }

    return docSnapshot;
  }

  Stream<QuerySnapshot> getSnapshotsAfter(
      String groupChatId, DocumentSnapshot lastSnapshot) {
    try {
      return _messagesCollection
          .doc(groupChatId)
          .collection(AppConstants.CHATS_COLLECTION)
          .startAfterDocument(lastSnapshot)
          .orderBy('timeStamp')
          .snapshots();
    } catch (error) {
      print(
          '****************** DB getSnapshotsAfter error **********************');
      print(error);
      throw error;
    }
  }

  Future<QuerySnapshot> getNewChats(
      String groupChatId, DocumentSnapshot lastSnapshot,
      [int limit = 20]) {
    try {
      return _messagesCollection
          .doc(groupChatId)
          .collection(AppConstants.CHATS_COLLECTION)
          .startAfterDocument(lastSnapshot)
          .limit(20)
          .orderBy('timeStamp', descending: true)
          .get();
    } catch (error) {
      print(
          '****************** DB getSnapshotsAfter error **********************');
      print(error);
      throw error;
    }
  }

  Stream<QuerySnapshot> getSnapshotsWithLimit(String groupChatId,
      [int limit = 10]) {
    try {
      return _messagesCollection
          .doc(groupChatId)
          .collection(AppConstants.CHATS_COLLECTION)
          .limit(limit)
          .orderBy('timeStamp', descending: true)
          .snapshots();
    } catch (error) {
      print(
          '****************** DB getSnapshotsWithLimit error **********************');
      print(error);
      throw error;
    }
  }

  void updateMessageField(dynamic snapshot, String field, dynamic value) {
    try {
     FirebaseFirestore.instance.runTransaction((transaction) async {
        // DocumentSnapshot freshDoc = await transaction.get(snapshot.reference);
        transaction.update(snapshot.reference, {'$field': value});
      });
    } catch (error) {
      print(
          '****************** DB updateMessageField error **********************');
      print(error);
      throw error;
    }
  }

  // USER INFO

  void addNewUser(
      String userId, String imageUrl, String username, String email) {
    try {
      _usersCollection.doc(userId).set({
        'id': userId,
        'imageUrl': imageUrl,
        'username': username,
        'email': email,
        'contacts': [],
      });
    } catch (error) {
      print('****************** DB addNewUser error **********************');
      print(error);
      throw error;
    }
  }

  Future<DocumentSnapshot> getUserDocRef(String userId) async {
    try {
      return _usersCollection.doc(userId).get();
    } catch (error) {
      print('****************** DB getUserDocRef error **********************');
      print(error);
      throw error;
    }
  }

  void updateUserInfo(String userId, Map<String, dynamic> data) async {
    try {
      _usersCollection.doc(userId).set(data, SetOptions(merge: true) );
    } catch (error) {
      print(
          '****************** DB updateUserInfo error **********************');
      print(error);
      throw error;
    }
  }
}