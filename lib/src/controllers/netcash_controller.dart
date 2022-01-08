import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:gogo_online/src/models/cart.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../repository/user_repository.dart' as userRepo;

class NetCashController extends ControllerMVC{
  GlobalKey<ScaffoldState> scaffoldKey;
  WebViewController webViewController;
  List<Cart> currentCarts;
  double total;
  String url = "";

  NetCashController(){
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';
    setState(() {});
    super.initState();
  }

///netcash?doctor=${getDoctor()}&consultation_date=${getDate()&total=$total&consultation_number=${getTransId()}&email=${getUserEmail()}&cellphone=${getUserCellphone()}
  String getPaymentUrl(){
   String payUrl = '${GlobalConfiguration().getString('base_url')}netcash?doctor=${getDoctor()}&consultation_date=${getDate()}&total=$total&consultation_number=${getTransId()}&email=${getUserEmail()}&cellphone=${getUserCellphone()}';
    print(payUrl);
    return payUrl;
  }

  String getDoctor()=>currentCarts[0].product.healer.name;

  String getDate()=>currentCarts[0].consultationDate;

  String getUserEmail() =>  userRepo.currentUser.value.email;

  String getUserCellphone()=> userRepo.currentUser.value.phone;

  String getTransId() => currentCarts[0].id.toString();

}