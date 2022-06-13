import 'package:flutter/material.dart';
import 'package:gogo_online/generated/l10n.dart';
import 'package:gogo_online/src/controllers/consultation_item_controller.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/helpers/helper.dart';
import 'package:gogo_online/src/models/chat_data.dart';
import 'package:gogo_online/src/models/consultation.dart';
import 'package:gogo_online/src/models/route_argument.dart';
import 'package:gogo_online/src/pages/messaging/messaging_screen.dart';
import 'package:gogo_online/src/repository/user_repository.dart';
import 'package:gogo_online/src/utils/ValidatorUtil.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'ProductOrderItemWidget.dart';


class ConsultationItemWithDateWidget extends StatefulWidget {
  final bool expanded;
  final Consultation consultation;
  final ValueChanged<void> onCanceled;

  const ConsultationItemWithDateWidget({Key key, this.expanded, this.consultation, this.onCanceled}) : super(key: key);
  @override
  _ConsultationItemWithDateWidgetState createState() => _ConsultationItemWithDateWidgetState();
}

class _ConsultationItemWithDateWidgetState extends StateMVC<ConsultationItemWithDateWidget> {
  ConsultationItemController _con;
  bool showChatButton = false;
  _ConsultationItemWithDateWidgetState(): super(ConsultationItemController()){
    _con= controller;
  }

  @override
  void initState() {

    var id = widget.consultation.productConsultations[0].product.healer.id;

    _con.listenForHealer(id: id, currentUserUid: currentUser.value.firebaseUid );
    if (currentUser.value.role.name ==AppConstants.ROLE_MANAGER){
      _con.listenForPatient(clUser: widget.consultation.user, currentUserUid: currentUser.value.firebaseUid );
    }

    showChatButton = ValidatorUtil.isNowPastTheDate(widget.consultation.consultationDate, widget.consultation.consultationStartTime);

    // TODO: implement initState
    super.initState();
  }




  void goToChat(BuildContext context){

    final initData = _con.chatData ??
        new ChatData(
            groupId: _con.getGroupId(currentUser.value.firebaseUid),
            userId: currentUser.value.firebaseUid,
            peerId: _con.healerPeer.id,
            peer: _con.healerPeer,
            messages: []
        );

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MessagingScreenWidget(chatData: initData)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: widget.consultation.active ? 1 : 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: EdgeInsets.only(top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: widget.expanded,
                    title: Column(
                      children: <Widget>[
                        // Text('${S.of(context).order_id}: #${widget.consultation.id}'),
                        Text('Date: ${widget.consultation.consultationDate}'),
                        Text('Time: ${widget.consultation.consultationStartTime}',
                         // DateFormat('dd-MM-yyyy | HH:mm').format(widget.consultation.dateTime),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Helper.getPrice(Helper.getTotalOrdersPrice(widget.consultation), context, style: Theme.of(context).textTheme.headline4),
                        Text('Consultation No: #${widget.consultation.id}',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    children: <Widget>[
                      Column(
                          children: List.generate(
                            widget.consultation.productConsultations.length,
                                (indexProduct) {
                              return ProductOrderItemWidget(
                                  heroTag: 'mywidget.orders', order: widget.consultation, productOrder: widget.consultation.productConsultations.elementAt(indexProduct));
                            },
                          )),
                      showChatButton?
                      Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextButton.icon(
                          onPressed: (){
                            goToChat(context);
                          },
                          style: TextButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(context).accentColor,
                            textStyle: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1,color: Theme.of(context).primaryColor)),
                            shape: StadiumBorder(),
                            elevation: 5
                          ),
                          icon: Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Text(currentUser.value.role?.name == AppConstants.ROLE_MANAGER
                              ? "Chat with client"
                              : "Chat with healer",
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ):SizedBox(height: 0,),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    currentUser.value.role?.name == AppConstants.ROLE_MANAGER
                                        ? widget.consultation.user.name
                                        : "",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${S.of(context).tax} (${widget.consultation.tax}%)',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(Helper.getTaxOrder(widget.consultation), context, style: Theme.of(context).textTheme.subtitle1)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).total,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(Helper.getTotalOrdersPrice(widget.consultation), context, style: Theme.of(context).textTheme.headline4)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                 /*   FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Tracking', arguments: RouteArgument(id: widget.consultation.id));
                      },
                      textColor: Theme.of(context).hintColor,
                      child: Wrap(
                        children: <Widget>[Text(S.of(context).view)],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ), */
                    if (widget.consultation.canCancelConsultation())
                      FlatButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Wrap(
                                  spacing: 10,
                                  children: <Widget>[
                                    Icon(Icons.report, color: Colors.orange),
                                    Text(
                                      S.of(context).confirmation,
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ],
                                ),
                                content: Text(S.of(context).areYouSureYouWantToCancelThisOrder),
                                contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                                actions: <Widget>[
                                  FlatButton(
                                    child: new Text(
                                      S.of(context).yes,
                                      style: TextStyle(color: Theme.of(context).hintColor),
                                    ),
                                    onPressed: () {
                                      widget.onCanceled(widget.consultation);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: new Text(
                                      S.of(context).close,
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        textColor: Theme.of(context).hintColor,
                        child: Wrap(
                          children: <Widget>[Text(S.of(context).cancel + " ")],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)), color: widget.consultation.active ? Theme.of(context).accentColor : Colors.redAccent),
          alignment: AlignmentDirectional.center,
          child: Text(
            widget.consultation.active ? '${widget.consultation.consultationStatus.status}' : S.of(context).canceled,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1, color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }
}
