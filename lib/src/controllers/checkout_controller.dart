import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/consultation.dart';
import '../models/consultation_status.dart';
import '../models/payment.dart';
import '../models/product_consultation.dart';
import '../repository/consultation_repository.dart' as consultationRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment payment;
  CreditCard creditCard = new CreditCard();
  bool loading = true;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  @override
  void onLoadingCartDone() {
    if (payment != null) addConsultation(carts);
    super.onLoadingCartDone();
  }

  void addConsultation(List<Cart> carts) async {
    Consultation _consultation = new Consultation();
    _consultation.productConsultations = new List<ProductConsultation>();
    _consultation.tax = carts[0].product.healer.defaultTax;
   // _consultation.deliveryFee = payment.method == 'Pay on Pickup' ? 0 : 0;// carts[0].product.healer.deliveryFee;
    ConsultationStatus _orderStatus = new ConsultationStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _consultation.consultationStatus = _orderStatus;
    _consultation.billingAddress = settingRepo.billingAddress.value;
    _consultation.consultationDate = carts[0].consultationDate;
    _consultation.consultationStartTime = carts[0].consultationStartTime;
    _consultation.consultationEndTime = carts[0].consultationEndTime;
    _consultation.hint = ' ';
    carts.forEach((_cart) {
      ProductConsultation _productOrder = new ProductConsultation();
      _productOrder.quantity = _cart.quantity;
      _productOrder.price = _cart.product.price;
      _productOrder.product = _cart.product;
      _productOrder.options = _cart.options;
      _consultation.productConsultations.add(_productOrder);
    });
    consultationRepo.addUserConsultation(_consultation, this.payment).then((value) async {
      settingRepo.coupon = new Coupon.fromJSON({});
      return value;
    }).then((value) {
      if (value is Consultation) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).payment_card_updated_successfully),
      ));
    });
  }
}
