import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/healer.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/category_repository.dart';
import '../repository/healer_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';

class HomeController extends ControllerMVC {
  List<Category> categories = <Category>[];
  List<Healer> topHealers = <Healer>[];
  List<Healer> popularHealers = <Healer>[];
  List<Healer> allHealers = <Healer>[];
  List<Review> recentReviews = <Review>[];
  List<Product> trendingProducts = <Product>[];

  HomeController() {
    listenForTopHealers();
   // listenForTrendingProducts();
    //listenForCategories();
    listenForPopularHealers();
    listenForAllHealers();
    listenForRecentReviews();
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForTopHealers() async {
    final Stream<Healer> stream = await getNearHealers(billingAddress.value, billingAddress.value);
    stream.listen((Healer _market) {
      setState(() => topHealers.add(_market));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForPopularHealers() async {
    final Stream<Healer> stream = await getPopularHealers(billingAddress.value);
    stream.listen((Healer _market) {
      setState(() => popularHealers.add(_market));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForAllHealers() async {
    final Stream<Healer> stream = await getAllHealers(billingAddress.value);
    stream.listen((Healer _market) {
      setState(() => allHealers.add(_market));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForTrendingProducts() async {
    final Stream<Product> stream = await getTrendingProducts(billingAddress.value);
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      billingAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    setState(() {
      categories = <Category>[];
      topHealers = <Healer>[];
      popularHealers = <Healer>[];
      recentReviews = <Review>[];
      trendingProducts = <Product>[];
    });
    await listenForTopHealers();
   // await listenForTrendingProducts();
   // await listenForCategories();
    await listenForPopularHealers();
    await listenForRecentReviews();
  }
}
