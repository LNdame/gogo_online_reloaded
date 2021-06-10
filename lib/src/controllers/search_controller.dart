import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/address.dart';
import '../models/healer.dart';
import '../models/product.dart';
import '../repository/healer_repository.dart';
import '../repository/product_repository.dart';
import '../repository/search_repository.dart';
import '../repository/settings_repository.dart';

class SearchController extends ControllerMVC {
  List<Healer> healers = <Healer>[];
  List<Product> products = <Product>[];

  SearchController() {
    listenForHealers();
   // listenForProducts();
  }

  void listenForHealers({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = billingAddress.value;
    final Stream<Healer> stream = await searchHealers(search, _address);
    stream.listen((Healer _market) {
      setState(() => healers.add(_market));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForProducts({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = billingAddress.value;
    final Stream<Product> stream = await searchProducts(search, _address);
    stream.listen((Product _product) {
      setState(() => products.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      healers = <Healer>[];
      products = <Product>[];
    });
    listenForHealers(search: search);
    listenForProducts(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
