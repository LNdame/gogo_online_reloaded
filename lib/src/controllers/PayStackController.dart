import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:gogo_online/src/models/cart.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../repository/user_repository.dart' as userRepo;

class PayStackController extends ControllerMVC{
  GlobalKey<ScaffoldState> scaffoldKey;
  WebViewController webViewController;
  List<Cart> currentCarts;
  double total;
  String url = "";

  PayStackController(){
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';
    setState(() {});
    super.initState();
  }


  String getPaymentUrl(){
    String payUrl = '${GlobalConfiguration().getString('base_url')}paystack?total=$total&doctor=${getDoctor()}&consultation_date=${getDate()}';
    print(payUrl);
    return payUrl;
  }

  String getDoctor(){
    return currentCarts[0].product.healer.name;
  }

  String getDate(){
    return currentCarts[0].consultationDate;
  }

}