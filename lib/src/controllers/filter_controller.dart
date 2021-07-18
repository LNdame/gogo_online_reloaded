import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/models/province.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/field.dart';
import '../models/filter.dart';
import '../repository/field_repository.dart';

class FilterController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Field> fields = [];
  List<Province> provinces = [];
  Filter filter;
  Cart cart;

  FilterController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();

    listenForFilter().whenComplete(() {
      listenForFields();
      populateProvinces();
    });
  }

  Future<void> listenForFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    });
  }

  Future<void> saveFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filter.fields = this.fields.where((_f) => _f.selected).toList();
    prefs.setString('filter', json.encode(filter.toMap()));
  }

  void listenForFields({String message}) async {
    fields.add(new Field.fromJSON({'id': '0', 'name': S.of(state.context).all, 'selected': true}));
    final Stream<Field> stream = await getFields();
    stream.listen((Field _field) {
      setState(() {
        if (filter.fields.contains(_field)) {
          _field.selected = true;
          fields.elementAt(0).selected = false;
        }
        fields.add(_field);
      });
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

  void populateProvinces() {
    provinces =
    [new Province(name:"All", selected: false ),
      new Province(name:AppConstants.EASTERN_CAPE, selected: false ),
    new Province(name:AppConstants.FREE_STATE, selected: false ),
    new Province(name:AppConstants.GAUTENG, selected: false ),
    new Province(name:AppConstants.KWAZULU_NATAL, selected: false ),
    new Province(name:AppConstants.LIMPOPO, selected: false ),
    new Province(name:AppConstants.MPUMALANGA, selected: false ),
    new Province(name:AppConstants.NORTHERN_CAPE, selected: false ),
    new Province(name:AppConstants.NORTH_WEST, selected: false ),
    new Province(name:AppConstants.WESTERN_CAPE, selected:false)];
    filter.provinces = provinces;

  }

  Future<void> refreshFields() async {
    fields.clear();
    listenForFields(message: S.of(state.context).addresses_refreshed_successfuly);
  }

  void clearFilter() {
    setState(() {
      filter.open = false;
      filter.delivery = false;
      resetFields();
      resetProvinces();
    });
  }

  void resetFields() {
    filter.fields = [];
    fields.forEach((Field _f) {
      _f.selected = false;
    });
    fields.elementAt(0).selected = true;
  }

  void resetProvinces() {
    filter.provinces = [];
    provinces.forEach((Province _p) {
      _p.selected = false;
    });
    provinces.elementAt(0).selected = true;
  }

  void onChangeFieldsFilter(int index) {
    if (index == 0) {
      // all
      setState(() {
        resetFields();
      });
    } else {
      setState(() {
        fields.elementAt(index).selected = !fields.elementAt(index).selected;
        fields.elementAt(0).selected = false;
      });
    }
  }

  void onChangeProvincesFilter(int index) {
    if (index == 0) {
      // all
      setState(() {
        resetProvinces();
      });
    } else {
      setState(() {
        provinces.elementAt(index).selected = !provinces.elementAt(index).selected;
        provinces.elementAt(0).selected = false;
      });
    }
  }
}
