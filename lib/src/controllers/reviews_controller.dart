import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/consultation.dart';
import '../models/consultation_status.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/healer_repository.dart' as marketRepo;
import '../repository/consultation_repository.dart';
import '../repository/product_repository.dart' as productRepo;

class ReviewsController extends ControllerMVC {
  Review marketReview;
  List<Review> productsReviews = [];
  Consultation order;
  List<Product> productsOfOrder = [];
  List<ConsultationStatus> orderStatus = <ConsultationStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ReviewsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.marketReview = new Review.init("0");
  }

  void listenForOrder({String orderId, String message}) async {
    final Stream<Consultation> stream = await getConsultation(orderId);
    stream.listen((Consultation _order) {
      setState(() {
        order = _order;
        productsReviews = List.generate(order.productConsultations.length, (_) => new Review.init("0"));
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      getProductsOfOrder();
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addProductReview(Review _review, Product _product) async {
    productRepo.addProductReview(_review, _product).then((value) {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).the_product_has_been_rated_successfully),
      ));
    });
  }

  void addMarketReview(Review _review) async {
    marketRepo.addHealerReview(_review, this.order.productConsultations[0].product.healer).then((value) {
      refreshOrder();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).the_healer_has_been_rated_successfully),
      ));
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(orderId: order.id, message: S.of(state.context).reviews_refreshed_successfully);
  }

  void getProductsOfOrder() {
    this.order.productConsultations.forEach((_productOrder) {
      if (!productsOfOrder.contains(_productOrder.product)) {
        productsOfOrder.add(_productOrder.product);
      }
    });
  }
}
