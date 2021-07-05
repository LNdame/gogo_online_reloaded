import 'package:flutter/material.dart';
import 'package:gogo_online/src/controllers/payfast_controller.dart';
import 'package:gogo_online/src/pages/payfast_payment.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class ConsultationSummaryController extends CartController {
  GlobalKey<ScaffoldState> scaffoldKey;
  model.Address deliveryAddress;
  PaymentMethodList list;

  ConsultationSummaryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    super.listenForCarts();
    listenForDeliveryAddress();
    print(settingRepo.billingAddress.value.toMap());
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.billingAddress.value;
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        settingRepo.billingAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.billingAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).the_address_updated_successfully),
      ));
    });
  }

  PaymentMethod getPickUpMethod() {
    return list.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return list.pickupList.elementAt(1);
  }

  void toggleDelivery() {
    list.pickupList.forEach((element) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getDeliveryMethod().selected = !getDeliveryMethod().selected;
    });
  }

  void togglePickUp() {
    list.pickupList.forEach((element) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getPickUpMethod().selected = !getPickUpMethod().selected;
    });
  }

  PaymentMethod getSelectedMethod() {
    return list.pickupList.firstWhere((element) => element.selected);
  }

  @override
  void goCheckout(BuildContext context) {

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PayFastPaymentWidget(carts: carts, total: total,))
    );

   // Navigator.of(context).pushNamed(getSelectedMethod().route);
  }
}
