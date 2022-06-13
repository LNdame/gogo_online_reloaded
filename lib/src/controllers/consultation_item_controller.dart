import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/models/chat_data.dart';
import 'package:gogo_online/src/models/chat_user.dart';
import 'package:gogo_online/src/models/healer.dart';
import 'package:gogo_online/src/models/message.dart';
import 'package:gogo_online/src/models/user.dart';
import 'package:gogo_online/src/repository/healer_repository.dart';
import 'package:gogo_online/src/repository/services/db.dart';
import 'package:gogo_online/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class ConsultationItemController extends ControllerMVC{
  Healer healer;
  ChatUser healerPeer;
  ChatData chatData;
  DB db;
  ChatUser clientPeer;
  User clientUser;

  ConsultationItemController() {
   /* registerFormKey = new  GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();*/
    db = DB();
  }


  void listenForHealer({String id, String message ,String currentUserUid}) async {
    final Stream<Healer> stream = await getHealer(id, billingAddress.value);
    stream.listen((Healer _healer) {
      setState(() {
        healer = _healer;
        healerPeer = setupHealerAsPeerUser(_healer);
      } );
    }, onError: (a) {
      print(a);
    /*  ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));*/
    }, onDone: () {
      if(currentUserUid!=null){
         listenForChatData(currentUserUid, healerPeer);
      }
      if (message != null) {
        /*ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));*/
      }
    });
  }

//Id here should be PatientID //
  void listenForPatient({User clUser, String message ,String currentUserUid}) async {
    setState(() {
      clientUser = clUser;
      clientPeer = setupClientAsPeerUser(clUser);
    });
    if(currentUserUid!=null){
      listenForChatData(currentUserUid, clientPeer);
    }
  }




  ChatUser setupHealerAsPeerUser(Healer healer) {
    return new ChatUser(
        id: healer.firebaseId,
        username: healer.name,
        email: "",
        imageUrl: healer.image.thumb,
        about: healer.description,
        role: AppConstants.ROLE_MANAGER);
  }

  ChatUser setupClientAsPeerUser(User client) {
    return new ChatUser(
        id: client.firebaseUid,
        username: client.name,
        email: "",
        imageUrl: client.image.thumb,
        about: "",
        role: AppConstants.ROLE_CLIENT);
  }

  void listenForChatData(String currentUserUid, ChatUser peer) async{
    final Stream<ChatData> stream = await getChatData(currentUserUid , peer);
    stream.listen((ChatData _data) {
      setState(() => chatData = _data);
    }, onError: (e){}, onDone: (){});
  }

  String getGroupId(String uid) {
    String groupId;
    if (uid.hashCode <= healer.firebaseId.hashCode)
      groupId = '$uid-${healer.firebaseId}';
    else
      groupId = '${healer.firebaseId}-$uid';

    return groupId;
  }

  Future<Stream<ChatData>> getChatData(String currentUserUid, ChatUser peer) async {
    String groupId = getGroupId(currentUserUid);
    // final peer = await db.getUser(healer.firebaseId);
    //final User person = User.fromJson(peer.data);
    final messagesData = await db.getChatItemData(groupId);

    int unreadCount = 0;
    List<Message> messages = [];
    for (int i = 0; i < messagesData.documents.length; i++) {
      var tmp = Message.fromMap(Map<String, dynamic>.from(messagesData.documents[i].data));
      messages.add(tmp);
      if(tmp.fromId == healer.firebaseId && !tmp.isSeen) unreadCount++;
    }

    var lastDoc;
    if (messagesData.documents.isNotEmpty)
      lastDoc = messagesData.documents[messagesData.documents.length - 1];


    ChatData chatData = ChatData(
      userId: currentUserUid,
      peerId: healer.firebaseId,
      groupId: groupId,
      peer: peer,
      messages: messages,
      lastDoc: lastDoc,
      unreadCount: unreadCount,
    );
    return new Stream.value(chatData);
  }


}