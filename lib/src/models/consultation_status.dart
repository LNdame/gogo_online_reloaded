import '../helpers/custom_trace.dart';

class ConsultationStatus {
  String id;
  String status;

  ConsultationStatus();

  ConsultationStatus.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['status'] != null ? jsonMap['status'] : '';
    } catch (e) {
      id = '';
      status = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
