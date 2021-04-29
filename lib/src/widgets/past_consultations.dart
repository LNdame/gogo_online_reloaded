import 'package:flutter/material.dart';
import '../elements/PastConsultationCardWidget.dart';

class PastConsultations extends StatefulWidget {
  @override
  _PastConsultationsState createState() => _PastConsultationsState();
}

class _PastConsultationsState extends State<PastConsultations> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return PastConsultationCardWidget();
      },
      itemCount: 15,
    );
  }
}
