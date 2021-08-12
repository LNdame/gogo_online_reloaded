import 'package:flutter/material.dart';
import 'package:gogo_online/src/controllers/PayStackController.dart';
import 'package:gogo_online/src/models/cart.dart';
import 'package:gogo_online/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class PayStackPaymentWidget extends StatefulWidget {
  RouteArgument routeArgument;
  final List<Cart> carts ;
  final double total;

  PayStackPaymentWidget({Key key, this.routeArgument, this.carts, this.total}) : super(key: key);

  @override
  _PayStackPaymentWidgetState createState() => _PayStackPaymentWidgetState();
}

class _PayStackPaymentWidgetState extends StateMVC<PayStackPaymentWidget> {
  PayStackController _con;

  _PayStackPaymentWidgetState() : super(PayStackController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.total = widget.total;
    _con.currentCarts =  widget.carts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Consultation Payment",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body:Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: WebView(
              initialUrl: _con.getPaymentUrl(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller){
                _con.webViewController = controller;
              },
              onPageStarted: (String url){
                setState(() {
                  _con.url = url;
                });
                if(url.contains("payment/callback")  ){
                  Navigator.of(context).pushReplacementNamed("/PayOnPickup");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
