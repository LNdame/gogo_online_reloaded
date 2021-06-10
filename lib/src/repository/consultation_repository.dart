import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/credit_card.dart';
import '../models/consultation.dart';
import '../models/consultation_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Consultation>> getConsultations() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}consultations?${_apiToken}with=user;productConsultations;productConsultations.product;productConsultations.options;consultationStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Consultation.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Consultation.fromJSON({}));
  }
}

Future<Stream<Consultation>> getConsultation(consultationId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}consultations/$consultationId?${_apiToken}with=user;productConsultations;productConsultations.product;productConsultations.options;consultationStatus;billingAddress;payment';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
    return Consultation.fromJSON(data);
  });
}

Future<Stream<Consultation>> getHealerConsultations() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}consultations?${_apiToken}user_type=healer&with=user;productConsultations;productConsultations.product;productConsultations.options;consultationStatus;payment';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Consultation.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Consultation.fromJSON({}));
  }
}

Future<Stream<Consultation>> getRecentConsultations() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}consultations?${_apiToken}with=user;productConsultations;productConsultations.product;productConsultations.options;consultationStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Consultation.fromJSON(data);
  });
}

Future<Stream<ConsultationStatus>> getConsultationStatus() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}consultation_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return ConsultationStatus.fromJSON(data);
  });
}

Future<Consultation> addUserConsultation(Consultation consultation, Payment payment) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Consultation();
  }
  CreditCard _creditCard = await userRepo.getCreditCard();
  consultation.user = _user;
  consultation.payment = payment;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}consultations?$_apiToken';
  Uri uri = Uri.parse(url);
  final client = new http.Client();
  Map params = consultation.toMap();
  print(json.encode(consultation.toMap()));
  params.addAll(_creditCard.toMap());
  print(json.encode(params));
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return Consultation.fromJSON(json.decode(response.body)['data']);
}

Future<Consultation> cancelConsultation(Consultation consultation) async {
  print(consultation.toMap());
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}consultations/${consultation.id}?$_apiToken';
  Uri uri = Uri.parse(url);
  final client = new http.Client();
  final response = await client.put(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(consultation.cancelMap()),
  );
  if (response.statusCode == 200) {
    return Consultation.fromJSON(json.decode(response.body)['data']);
  } else {
    throw new Exception(response.body);
  }
}
