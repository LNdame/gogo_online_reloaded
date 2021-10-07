import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/helpers/custom_trace.dart';
import 'package:gogo_online/src/models/media_model.dart';
import 'package:gogo_online/src/models/message.dart';

class DB{
  final CollectionReference _usersCollection =
  Firestore.instance.collection(AppConstants.USERS_COLLECTION);
  final CollectionReference _messagesCollection =
  Firestore.instance.collection(AppConstants.ALL_MESSAGES_COLLECTION);

  Stream<QuerySnapshot> getContactsStream() {
    return Firestore.instance.collection(AppConstants.USERS_COLLECTION).snapshots();
  }

  Stream<DocumentSnapshot> getUserContactsStream(String uid) {
    try{
      print("obtaining user contact =====");
      var snapshots =_usersCollection.document(uid).snapshots();
      print("obtained user contact =====");
      return snapshots;

    }on NoSuchMethodError catch (ne) {
      print(CustomTrace(StackTrace.current, message: ne.toString()));
      return null;
    } on Exception catch (_) {
      print("error caught");
      return null;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      return null;
    }

  }

  Future<DocumentSnapshot> getUser(String id) {
    try{
      print("getting user db ******");
      return _usersCollection.document(id).get();
    }on NoSuchMethodError catch (ne) {
      print(CustomTrace(StackTrace.current, message: ne.toString()));
      return null;
    } on Exception catch (_) {
      print("error caught");
      return null;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      return null;
    }

  }

  void addNewMessage(String groupId, DateTime timeStamp, dynamic data) {
    try {
      _messagesCollection
          .document(groupId)
          .collection(AppConstants.CHATS_COLLECTION)
          .document(timeStamp.millisecondsSinceEpoch.toString())
          .setData(data);
    } catch (error) {
      print('****************** DB addNewMessage error **********************');
      print(error);
      throw error;
    }
  }

  Future<QuerySnapshot> getChatItemData(String groupId, [int limit = 20]) {
    try {
      return _messagesCollection
          .document(groupId)
          .collection(AppConstants.CHATS_COLLECTION)
          .orderBy('timeStamp', descending: true)
          .limit(limit)
          .getDocuments();
    } catch (error) {
      print(
          '****************** DB getChatItemData error **********************');
      throw error;
    }
  }

  void addMediaUrl(String groupId, String url, Message mediaMsg) {
    try {
      _messagesCollection
          .document(groupId)
          .collection(AppConstants.MEDIA_COLLECTION)
          .document(mediaMsg.timeStamp)
          .setData(MediaModel.fromMsgToMap(mediaMsg));
    } catch (error) {
      print('****************** DB addMediaUrl error **********************');
      print(error);
      throw error;
    }
  }

  Stream<QuerySnapshot> getMediaCount(String groupId) {
    try {
      return _messagesCollection
          .document(groupId)
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
          .document(groupId)
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
          .document(userId)
          .setData({'contacts': contacts}, merge: true);
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
      doc = _usersCollection.document(peerId);
      docSnapshot = await doc.get();

      var peerContacts = [];

      docSnapshot.data['contacts'].forEach((elem) => peerContacts.add(elem));
      peerContacts.add(newContact);

      Firestore.instance.runTransaction((transaction) async {
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
          .document(groupChatId)
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
          .document(groupChatId)
          .collection(AppConstants.CHATS_COLLECTION)
          .startAfterDocument(lastSnapshot)
          .limit(20)
          .orderBy('timeStamp', descending: true)
          .getDocuments();
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
          .document(groupChatId)
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
      Firestore.instance.runTransaction((transaction) async {
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
      _usersCollection.document(userId).setData({
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
      return _usersCollection.document(userId).get();
    } catch (error) {
      print('****************** DB getUserDocRef error **********************');
      print(error);
      throw error;
    }
  }

  void updateUserInfo(String userId, Map<String, dynamic> data) async {
    try {
      _usersCollection.document(userId).setData(data, merge: true);
    } catch (error) {
      print(
          '****************** DB updateUserInfo error **********************');
      print(error);
      throw error;
    }
  }
}