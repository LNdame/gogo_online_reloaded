import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/consultation.dart';
import '../repository/consultation_repository.dart';

class ConsultationController extends ControllerMVC {
  List<Consultation> consultations = <Consultation>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ConsultationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForConsultations({String message}) async {
    final Stream<Consultation> stream = await getConsultations();
    stream.listen((Consultation _consultation) {
      setState(() {
        consultations.add(_consultation);
      });
    }, onError: (a) {
      print(a);
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForHealerConsultations({String message}) async {
    final Stream<Consultation> stream = await getHealerConsultations();
    stream.listen((Consultation _consultation) {
      setState(() {
        consultations.add(_consultation);
      });
    }, onError: (a) {
      print(a);
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void doCancelConsultation(Consultation consultation) {
    cancelConsultation(consultation).then((value) {
      setState(() {
        consultation.active = false;
      });
    }).catchError((e) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e),
      ));
    }).whenComplete(() {
      //refreshOrders();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).consultationThisconsultaitonidHasBeenCanceled(consultation.id)),
      ));
    });
  }

  Future<void> refreshConsultations() async {
    consultations.clear();
    listenForConsultations(message: S.of(state.context).consultations_refreshed_successfuly);
  }
}
