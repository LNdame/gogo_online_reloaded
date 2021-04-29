import 'package:flutter/material.dart';
import '../elements/UpcomingConsultationsCardWidget.dart';

class UpcomingConsultations extends StatefulWidget {
  @override
  _UpcomingConsultationsState createState() => _UpcomingConsultationsState();
}

class _UpcomingConsultationsState extends State<UpcomingConsultations> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return UpcomingConsultationsCardWidget();
      },
      itemCount: 15,
    );
  }
}
