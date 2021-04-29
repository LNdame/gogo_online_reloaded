import '../models/address.dart';
import '../models/consultation_status.dart';
import '../models/payment.dart';
import '../models/product_consultation.dart';
import '../models/user.dart';

class Consultation {
  String id;
  List<ProductConsultation> productConsultations;
  ConsultationStatus consultationStatus;
  double tax;
  String hint;
  bool active;
  DateTime dateTime;
  String consultationStartTime;
  String consultationEndTime;
  String consultationDate;
  User user;
  Payment payment;
  Address billingAddress;

  Consultation();

  Consultation.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : '';
      active = jsonMap['active'] ?? false;
      consultationStatus = jsonMap['consultation_status'] != null ? ConsultationStatus.fromJSON(jsonMap['consultation_status']) : ConsultationStatus.fromJSON({});
      dateTime = DateTime.parse(jsonMap['updated_at']);
      consultationStartTime = jsonMap['consultation_start_time'] != null ? jsonMap['consultation_start_time'].toString() : '';
      consultationEndTime = jsonMap['consultation_end_time'] != null ? jsonMap['consultation_end_time'].toString() : '';
      consultationDate = jsonMap['consultation_date'] != null ? jsonMap['consultation_date'].toString() : '';
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : User.fromJSON({});
      billingAddress = jsonMap['billing_address'] != null ? Address.fromJSON(jsonMap['billing_address']) : Address.fromJSON({});
      payment = jsonMap['payment'] != null ? Payment.fromJSON(jsonMap['payment']) : Payment.fromJSON({});
      productConsultations = jsonMap['product_consultations'] != null ? List.from(jsonMap['product_consultations']).map((element) => ProductConsultation.fromJSON(element)).toList() : [];
    } catch (e) {
      id = '';
      tax = 0.0;
      consultationStartTime ='';
      consultationEndTime='';
      consultationDate='';
      hint = '';
      active = false;
      consultationStatus = ConsultationStatus.fromJSON({});
      dateTime = DateTime(0);
      user = User.fromJSON({});
      payment = Payment.fromJSON({});
      billingAddress = Address.fromJSON({});
      productConsultations = [];
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    map["consultation_status_id"] = consultationStatus?.id;
    map["tax"] = tax;
    map['hint'] = hint;
    map["consultation_start_time"] = consultationStartTime;
    map["consultation_end_time"] = consultationEndTime;
    map["consultation_date"] = consultationDate;
    map["products"] = productConsultations?.map((element) => element.toMap())?.toList();
    map["payment"] = payment?.toMap();
    if (!billingAddress.isUnknown()) {
      map["billing_address_id"] = billingAddress?.id;
    }
    return map;
  }

  Map deliveredMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["consultation_status_id"] = 5;
    if (billingAddress?.id != null && billingAddress?.id != 'null') map["billing_address_id"] = billingAddress.id;
    return map;
  }

  Map cancelMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    if (consultationStatus?.id != null && consultationStatus?.id == '1') map["active"] = false;
    return map;
  }

  bool canCancelConsultation() {
    return this.active == true && this.consultationStatus.id == '1'; // 1 for order received status
  }
}
