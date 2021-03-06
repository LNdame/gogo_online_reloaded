import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/consultation_summary_controller.dart';
import '../elements/WaitingRoomBottomDetailsWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/NotDeliverableAddressesItemWidget.dart';
import '../elements/PickUpMethodItemWidget.dart';
import '../elements/WaitingRoomButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';

class ConsultationSummaryWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  ConsultationSummaryWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ConsultationSummaryWidgetState createState() => _ConsultationSummaryWidgetState();
}

class _ConsultationSummaryWidgetState extends StateMVC<ConsultationSummaryWidget> {
  ConsultationSummaryController _con;
  String productName ="";
  String healerName = "";
  String consultationDate = "";

  _ConsultationSummaryWidgetState() : super(ConsultationSummaryController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _con.listenForCarts();

  }

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
//      widget.pickup = widget.list.pickupList.elementAt(0);
//      widget.delivery = widget.list.pickupList.elementAt(1);
    }
    return Scaffold(
      key: _con.scaffoldKey,
      bottomNavigationBar: WaitingRoomBottomDetailsWidget(con: _con),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Consultation Summary",
         // S.of(context).delivery_or_pickup,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new WaitingRoomButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30,right: 10),
              child: Container(
                height: 200,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   ListTile(
                     contentPadding: EdgeInsets.symmetric(vertical: 0),
                     leading: Icon(Icons.assistant_rounded,color: Theme.of(context).hintColor,),
                     title: Text(_con.sumCarts.value.isNotEmpty ? _con.sumCarts.value.elementAt(0).product.name : "",maxLines: 1, ///use a set state here
                       overflow: TextOverflow.ellipsis,
                       style: Theme.of(context).textTheme.headline4,
                     ),
                     subtitle: Text(_con.sumCarts.value.isNotEmpty ? _con.sumCarts.value.first.product.healer.name:"",
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                       style: Theme.of(context).textTheme.subtitle1,
                     ),
                   ),
                   SizedBox(height: 16,),
                   ListTile(
                     contentPadding: EdgeInsets.symmetric(vertical: 0),
                     leading: Icon(Icons.calendar_today_outlined,color: Theme.of(context).hintColor,),
                     title: Text("Date: ${_con.sumCarts.value.isNotEmpty ?_con.sumCarts.value.first.consultationDate:""}",maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                       style: Theme.of(context).textTheme.subtitle1,
                     ),
                   ),
                 ],
               ),
              ),
            ),

            PickUpMethodItem(
                paymentMethod: _con.getPickUpMethod(),
                onPressed: (paymentMethod) {
                  _con.togglePickUp();
                }),
            Column(
              children: <Widget>[
                /*Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.map,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).delivery,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: _con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.healer, carts: _con.carts)
                        ? Text(
                            S.of(context).click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          )
                        : Text(
                            S.of(context).deliveryMethodNotAllowed,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                  ),
                ),*/
               /* _con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.healer, carts: _con.carts)
                    ? DeliveryAddressesItemWidget(
                        paymentMethod: _con.getDeliveryMethod(),
                        address: _con.deliveryAddress,
                        onPressed: (Address _address) {
                          if (_con.deliveryAddress.id == null || _con.deliveryAddress.id == 'null') {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.addAddress(_address);
                              },
                            );
                          } else {
                            _con.toggleDelivery();
                          }
                        },
                        onLongPress: (Address _address) {
                          DeliveryAddressDialog(
                            context: context,
                            address: _address,
                            onChanged: (Address _address) {
                              _con.updateAddress(_address);
                            },
                          );
                        },
                      )
                    : NotDeliverableAddressesItemWidget()*/
              ],
            )
          ],
        ),
      ),
    );
  }
}
