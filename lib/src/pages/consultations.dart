import 'package:flutter/material.dart';
import 'package:gogo_online/src/elements/ConsultationItemWithDateWidget.dart';
import 'package:gogo_online/src/models/consultation.dart';
import '../elements/UpcomingConsultationsCardWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/EmptyConsultationsWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/WaitingRoomButtonWidget.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';

import '../controllers/consultation_controller.dart';

class ConsultationsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const ConsultationsWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _ConsultationsWidgetState createState() => _ConsultationsWidgetState();
}

class _ConsultationsWidgetState extends StateMVC<ConsultationsWidget> {
  ConsultationController _con;

  _ConsultationsWidgetState() : super(ConsultationController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _con.listenForConsultations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).my_consultations,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new WaitingRoomButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          :  _con.consultations.isEmpty
              ? EmptyConsultationsWidget()
              : RefreshIndicator(
                  onRefresh: _con.refreshConsultations,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SearchBarWidget(),
                          ),
                          SizedBox(height: 20),
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              var _consultation = _con.consultations.elementAt(index);  // var _consultation =  new Consultation();
                              return ConsultationItemWithDateWidget(
                                expanded: true,
                                consultation: _consultation,
                                onCanceled: (e) {
                                  _con.doCancelConsultation(_consultation);
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 2);
                            },
                            itemCount: _con.consultations.length, //10
                          ),
                        ]),
                  ),
                ),
    );
  }
}
