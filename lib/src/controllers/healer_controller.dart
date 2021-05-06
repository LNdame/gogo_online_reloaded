
import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/category.dart';
import '../models/gallery.dart';
import '../models/healer.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/category_repository.dart';
import '../repository/gallery_repository.dart';
import '../repository/healer_repository.dart' ;
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';

class HealerController extends ControllerMVC {
  Healer healer;
  List<Gallery> galleries = <Gallery>[];
  List<Product> products = <Product>[];
  List<Category> categories = <Category>[];
  List<Product> trendingProducts = <Product>[];
  List<Product> featuredProducts = <Product>[];
  List<Review> reviews = <Review>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<FormState> registerFormKey;
  OverlayEntry loader;

  HealerController() {
    registerFormKey = new  GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForHealer({String id, String message}) async {
    final Stream<Healer> stream = await getHealer(id, billingAddress.value);
    stream.listen((Healer _healer) {
      setState(() => healer = _healer);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForGalleries(String idHealer) async {
    final Stream<Gallery> stream = await getGalleries(idHealer);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForHealerReviews({String id, String message}) async {
    final Stream<Review> stream = await getHealerReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForProducts(String idHealer, {List<String> categoriesId}) async {
    final Stream<Product> stream = await getProductsOfHealer(idHealer, categories: categoriesId);
    stream.listen((Product _product) {
      setState(() => products.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      healer..name = products?.elementAt(0)?.healer?.name;
    });
  }

  void listenForTrendingProducts(String idHealer) async {
    final Stream<Product> stream = await getTrendingProductsOfHealer(idHealer);
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedProducts(String idHealer) async {
    final Stream<Product> stream = await getFeaturedProductsOfHealer(idHealer);
    stream.listen((Product _product) {
      setState(() => featuredProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories(String healerId) async {
    final Stream<Category> stream = await getCategoriesOfHealer(healerId);
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      categories.insert(0, new Category.fromJSON({'id': '0', 'name': S.of(state.context).all}));
    });
  }

  Future<void> selectCategory(List<String> categoriesId) async {
    products.clear();
    listenForProducts(healer.id, categoriesId: categoriesId);
  }

  Future<void> refreshHealer() async {
    var _id = healer.id;
    healer = new Healer();
    galleries.clear();
    reviews.clear();
    featuredProducts.clear();
    listenForHealer(id: _id, message: S.of(state.context).healer_refreshed_successfuly);
    listenForHealerReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedProducts(_id);
  }

  void requestRegisterHealer(Healer healer) async{
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    //if(registerFormKey.currentState.validate()){
      registerFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      registerHealer(healer).then( (value){
        if(value!=null){
          //TODO navigate to request success
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text("Registered!!"),
          ));
        }else{
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text("Error!!"),
          ));
        }
      }).catchError((error){
        loader.remove();
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text("Error!!"),
        ));
      }).whenComplete(() => Helper.hideLoader(loader));


    }
  //}
}
