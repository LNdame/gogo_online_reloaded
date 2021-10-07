import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/custom_trace.dart';
import 'package:gogo_online/src/models/chat_data.dart';
import 'package:gogo_online/src/models/chat_user.dart';
import 'package:gogo_online/src/models/message.dart';
import 'package:gogo_online/src/repository/services/db.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MessagingController extends ControllerMVC {
  ChatUser healerPeer;
  DB db;
  List<String> _contacts = [];
  ChatUser _userDetails;
  List<ChatData> _chats = [];
  GlobalKey<ScaffoldState> scaffoldKey;
  String _userId;
  bool _isLoading = true;

  MessagingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    db = DB();
  }

  void setUserId(String uid) {
    _userId = uid;
  }

  List<dynamic> get getContacts {
    return _contacts;
  }

  void addToContacts(String uid) {
    _contacts.add(uid);
  }

  List<ChatData> get chats {
    return _chats;
  }

  ChatUser get userDetails {
    return _userDetails;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<dynamic> getUserDetailsAndContacts(String currentUserUid) async {
    try {
      print("starting obt user  details and contact =====");
      final userData = await db.getUser(currentUserUid);
      print("${userData.data}");
      _userDetails = ChatUser.fromJson(userData.data);
      // _imageUrl = _user.photoUrl;
      setUserId(_userDetails.id);

      if (userData.data != null) {
        userData.data['contacts'].forEach((elem) {
          _contacts.add(elem);
        });
      }
      print("getting user  details and contact =====");
      await fetchChats();
      return true;
    } on NoSuchMethodError catch (ne) {
      print(CustomTrace(StackTrace.current, message: ne.toString()));
      return false;
    } on Exception catch (ex) {
      print(CustomTrace(StackTrace.current, message: ex.toString()));
      print("error caught");
      return false;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      return false;
    }
  }

  Future<bool> fetchChats() async {
    try {
      _isLoading = true;
      _chats.clear();
      Future.forEach(_contacts, (contact) async {
        final chatData = await getChatData(contact);
        setState(() {
          _chats.add(chatData);
        });
      }).then((value) {
        _isLoading = false;
      });
      return true;
    } on NoSuchMethodError catch (ne) {
      print(CustomTrace(StackTrace.current, message: ne.toString()));
      return false;
    } on Exception catch (_) {
      print("error caught");
      return false;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      return false;
    }
  }

  void addToInitChats(ChatData chatData) {
    if (_chats.contains(chatData)) return;
    _chats.insert(0, chatData);
  }

  void bringChatToTop(String groupId, String currentUserUid) {
    if (_chats.isNotEmpty && _chats[0].groupId != groupId) {
      // bring latest interacted contact and chat to top
      var ids = groupId.split('-');
      var peerId = ids.firstWhere((element) => element != currentUserUid);

      var cIndex = _contacts.indexWhere((element) => element == peerId);
      _contacts.removeAt(cIndex);
      _contacts.insert(0, peerId);

      try{
        db.updateUserInfo(currentUserUid, {'contacts': _contacts});
      }catch(e){
        print(e.toString());
      }

      var index = _chats.indexWhere((element) => element.groupId == groupId);
      var temp = _chats[index];
      _chats.removeAt(index);
      _chats.insert(0, temp);
    }
  }

  void addMessageToInitChats(ChatData chatRoom, Message msg) {
    _chats.firstWhere((element) => element.peer.id == chatRoom.peer.id).messages.insert(0, msg);
    // print('at cahts -------> ${x.messages[0].content}');
  }

  void handleMessagesNotFromContacts(List<dynamic> newContacts) async {
    if (newContacts.length > _contacts.length) {
      for (int i = _contacts.length; i < newContacts.length; ++i) {
        final chatData = await getChatData(newContacts[i]);
        _chats.insert(0, chatData);
        _contacts.insert(0, newContacts[i]);
      }
      notifyListeners();
      db.updateContacts(userDetails.id, _contacts);
    }
  }

  String getGroupId(String contact) {
    String groupId;
    if (_userId.hashCode <= contact.hashCode)
      groupId = '$_userId-$contact';
    else
      groupId = '$contact-$_userId';

    return groupId;
  }

  Future<ChatData> getChatData(String peerId) async {
    try {
      String groupId = getGroupId(peerId);
      final peer = await db.getUser(peerId);
      final ChatUser person = ChatUser.fromJson(peer.data);
      final messagesData = await db.getChatItemData(groupId);

      int unreadCount = 0;
      List<Message> messages = [];
      for (int i = 0; i < messagesData.documents.length; i++) {
        var tmp = Message.fromMap(Map<String, dynamic>.from(messagesData.documents[i].data));
        messages.add(tmp);
        if (tmp.fromId == peerId && !tmp.isSeen) unreadCount++;
      }

      var lastDoc;
      if (messagesData.documents.isNotEmpty)
        lastDoc = messagesData.documents[messagesData.documents.length - 1];

      ChatData chatData = ChatData(
        userId: userDetails.id,
        peerId: person.id,
        groupId: groupId,
        peer: person,
        messages: messages,
        lastDoc: lastDoc,
        unreadCount: unreadCount,
      );
      return chatData;
    } on NoSuchMethodError catch (ne) {
      print(CustomTrace(StackTrace.current, message: ne.toString()));
      return ChatData(messages: [], userId: '', peerId: '', groupId: '', peer: null);
    } on Exception catch (_) {
      print("error caught");
      return ChatData(messages: [], userId: '', peerId: '', groupId: '', peer: null);
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      return ChatData(messages: [], userId: '', peerId: '', groupId: '', peer: null);
    }
  }
}
