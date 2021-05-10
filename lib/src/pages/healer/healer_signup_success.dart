import 'package:flutter/material.dart';
import 'package:gogo_online/generated/l10n.dart';
import 'package:gogo_online/src/controllers/healer_controller.dart';
import 'package:gogo_online/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HealerSignUpSuccessWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  const HealerSignUpSuccessWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _HealerSignUpSuccessWidgetState createState() => _HealerSignUpSuccessWidgetState();
}

class _HealerSignUpSuccessWidgetState extends StateMVC<HealerSignUpSuccessWidget> {
  HealerController _con;

  _HealerSignUpSuccessWidgetState(): super(HealerController()){
    _con = controller;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).confirmation,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
        body: Stack(
            fit: StackFit.expand,
          children: [
            Container(
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                              Colors.green.withOpacity(1),
                              Colors.green.withOpacity(0.2),
                            ])),
                        child: /*_con.loading
                            ? Padding(
                          padding: EdgeInsets.all(55),
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor),
                          ),
                        )
                            :*/ Icon(
                          Icons.check,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 90,
                        ),
                      ),
                      Positioned(
                        right: -30,
                        bottom: -50,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(150),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        top: -50,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(150),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  Opacity(
                    opacity: 0.4,
                    child: Text("Your request for registration has been successful we will notify you once feedback is available.",
                     // S.of(context).your_consultation_has_been_successfully_booked,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 155,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("You can go back to the home page while your application is under review.",
                             /// S.of(context).subtotal,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        //  Helper.getPrice(_con.subTotal, context, style: Theme.of(context).textTheme.subtitle1)
                        ],
                      ),
                      SizedBox(height: 3),

                    /*  Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              S.of(context).total,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Helper.getPrice(_con.total, context, style: Theme.of(context).textTheme.headline6)
                        ],
                      ),*/
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/Pages', arguments: 2);
                          },
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          child: Text(
                            S.of(context).home,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}
