import 'package:flutter/material.dart';
import 'package:gogo_online/generated/l10n.dart';
import 'package:gogo_online/src/controllers/healer_controller.dart';
import 'package:gogo_online/src/elements/BlockButtonWidget.dart';
import 'package:gogo_online/src/elements/ProfileAvatarWidget.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/helpers/helper.dart';
import 'package:gogo_online/src/models/healer.dart';
import 'package:gogo_online/src/repository/user_repository.dart';
import 'package:gogo_online/src/utils/ValidatorUtil.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class HealerRegistrationWidget extends StatefulWidget {
  @override
  _HealerRegistrationWidgetState createState() => _HealerRegistrationWidgetState();
}

class _HealerRegistrationWidgetState extends StateMVC<HealerRegistrationWidget> {
  HealerController _con;
  bool _afrikaansChecked = false;
  bool _englishChecked = false;
  bool _sepediChecked = false;
  bool _sesothoChecked = false;
  bool _southernNdebeleChecked = false;
  bool _swaziChecked = false;
  bool _tsongaChecked = false;
  bool _tswanaChecked = false;
  bool _vendaChecked = false;
  bool _xhosaChecked = false;
  bool _zuluChecked = false;
  var _provinceList = <DropdownMenuItem>[];
  var _languageList = <String>[];
  var _selectedProvinceValue;
  
  void loadProvinces(){
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.EASTERN_CAPE), value: AppConstants.EASTERN_CAPE_LAT_LON,));
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.FREE_STATE), value: AppConstants.FREE_STATE_LAT_LON,));
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.GAUTENG), value: AppConstants.GAUTENG_LAT_LON,));
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.KWAZULU_NATAL), value: AppConstants.KWAZULU_NATAL_LAT_LON,));
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.LIMPOPO), value: AppConstants.LIMPOPO_LAT_LON,));
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.MPUMALANGA), value: AppConstants.MPUMALANGA_LAT_LON,));
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.NORTHERN_CAPE), value: AppConstants.NORTHERN_CAPE_LAT_LON,));
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.NORTH_WEST), value: AppConstants.NORTH_WEST_LAT_LON,));
    _provinceList.add(DropdownMenuItem(child: Text(AppConstants.WESTERN_CAPE), value: AppConstants.WESTERN_CAPE_LAT_LON,));
  }


  Healer requestHealer;
  _HealerRegistrationWidgetState(): super(HealerController()){
    _con = controller;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRequestHealer();
    loadProvinces();
  }

  void initRequestHealer(){
    requestHealer = new Healer();
    requestHealer.name = currentUser.value.name;
    requestHealer.latitude ="-26.2708";
    requestHealer.longitude ="28.1123";
    requestHealer.closed = false;
    requestHealer.adminCommission = 10.0;
    requestHealer.defaultTax = 15;
    requestHealer.information = "Work hours \n";
  }

  void setLatLongFromProvince(String value){
    var valueSplit = value.split(',');
    if (valueSplit!=null){
       requestHealer.latitude = valueSplit[0] ?? "-26.2708";
       requestHealer.longitude = valueSplit[1] ?? "28.1123";
       print("${requestHealer.latitude} ${requestHealer.longitude}");
    }
  }

  void addElementToLanguageList(String lang){
   _languageList.add(lang);
  }

  void removeElementToLanguageList(String lang){
   if (_languageList.contains(lang)) _languageList.remove(lang);
  }

  void addLanguagesList(){
    String langs = "\n Consultation language:\n";
    langs += _languageList.join(", ");
    requestHealer.information += langs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).register_as_healer,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ProfileAvatarWidget(user: currentUser.value),
                SizedBox(height: 30,),
                Form(key: _con.registerFormKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (input)=>ValidatorUtil.genericEmptyValidator(input, "Please enter an address"),
                          onSaved: (input) =>requestHealer.address = input, //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText: S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: S.of(context).siya_nkosi,
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.location_on_outlined, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30,),
                        DropdownButtonFormField(
                          value: _selectedProvinceValue,
                          items: _provinceList,
                           validator:    (value) => value == null ? 'field required' : null,
                          onChanged: (value) {
                            setLatLongFromProvince(value);
                          },
                          decoration: InputDecoration(
                            labelText:"Province",  //S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.location_on_outlined, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                      ),

                        SizedBox(height: 30,),
                        Text("Consultation language", style: Theme.of(context).textTheme.headline4,),
                        SizedBox(height: 16,),
                        CheckboxListTile(value: _afrikaansChecked,
                            onChanged: (value){
                          setState(() {_afrikaansChecked =value;
                          value == true ? addElementToLanguageList("Afrikaans" ):removeElementToLanguageList("Afrikaans");});
                            },
                        title: Text("Afrikaans", style: Theme.of(context).textTheme.caption),
                        selectedTileColor: Theme.of(context).colorScheme.secondary,
                        controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _englishChecked,
                          onChanged: (value){
                            setState(() {_englishChecked =value;
                            value == true ? addElementToLanguageList("English" ):removeElementToLanguageList("English");
                            });
                          },
                          title: Text("English", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),

                        CheckboxListTile(value: _sepediChecked,
                          onChanged: (value){
                            setState(() {_sepediChecked =value;
                            value == true ? addElementToLanguageList("Sepedi" ):removeElementToLanguageList("Sepedi");});
                          },
                          title: Text("Sepedi", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _sesothoChecked,
                          onChanged: (value){
                            setState(() {_sesothoChecked =value;
                            value == true ? addElementToLanguageList("Sesotho" ):removeElementToLanguageList("Sesotho");});
                          },
                          title: Text("Sesotho", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _southernNdebeleChecked,
                          onChanged: (value){
                            setState(() {_southernNdebeleChecked =value;
                            value == true ? addElementToLanguageList("isiNdebele" ):removeElementToLanguageList("isiNdebele");});
                          },
                          title: Text("isiNdebele", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _swaziChecked,
                          onChanged: (value){
                            setState(() {_swaziChecked =value;
                            value == true ? addElementToLanguageList("siSwati" ):removeElementToLanguageList("siSwati");});
                          },
                          title: Text("siSwati", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _tsongaChecked,
                          onChanged: (value){
                            setState(() {_tsongaChecked =value;
                            value == true ? addElementToLanguageList("Xitsonga" ):removeElementToLanguageList("Xitsonga");});
                          },
                          title: Text("Xitsonga", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _tswanaChecked,
                          onChanged: (value){
                            setState(() {_tswanaChecked =value;
                            value == true ? addElementToLanguageList("Setswana" ):removeElementToLanguageList("Setswana");});
                          },
                          title: Text("Setswana", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _vendaChecked,
                          onChanged: (value){
                            setState(() {_vendaChecked =value;
                            value == true ? addElementToLanguageList("Tshivenda" ):removeElementToLanguageList("Tshivenda");});
                          },
                          title: Text("Tshivenda", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _xhosaChecked,
                          onChanged: (value){
                            setState(() {_xhosaChecked =value;
                            value == true ? addElementToLanguageList("isiXhosa" ):removeElementToLanguageList("isiXhosa");});
                          },
                          title: Text("isiXhosa", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _zuluChecked,
                          onChanged: (value){
                            setState(() {_zuluChecked =value;
                            value == true ? addElementToLanguageList("isiZulu" ):removeElementToLanguageList("isiZulu");
                            });
                          },
                          title: Text("isiZulu", style: Theme.of(context).textTheme.caption),
                       //   selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),

                        TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          onSaved: (input) =>requestHealer.description = input, //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText: "Description of services",//S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: S.of(context).siya_nkosi,
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.notes_outlined, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (input)=>ValidatorUtil.genericEmptyValidator(input, "Please enter time range"),
                          onSaved: (input) =>requestHealer.information += "Week day working hours\n $input \n", //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText: "Week day working hours",// S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: "8:00 - 17:00",// S.of(context).siya_nkosi,
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.timelapse_outlined, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (input)=>ValidatorUtil.genericEmptyValidator(input, "Please enter time range"),
                          onSaved: (input) =>requestHealer.information += "Saturday working hours\n $input \n", //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText: "Saturday working hours",//S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: "8:00 - 17:00",//S.of(context).siya_nkosi,
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.timelapse_outlined, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (input)=>ValidatorUtil.genericEmptyValidator(input, "Please enter time range"),
                          onSaved: (input) =>requestHealer.information += "Sunday working hours\n $input \n", //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText: "Sunday working hours",//S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText:"8:00 - 17:00",// S.of(context).siya_nkosi,
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.timelapse_outlined, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (input)=>ValidatorUtil.genericEmptyValidator(input, "Please enter an amount"),
                          onSaved: (input) =>{}, //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText: "Consultation price (per hour)",//S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText:"R500",// S.of(context).siya_nkosi,
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.money, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: ValidatorUtil.phoneValidator,
                          onSaved: (input) =>requestHealer.phone = requestHealer.mobile =input, //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText: "Practice number (optional)",//S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText:"012 566 7685",
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30,),
                        BlockButtonWidget(
                          text: Text(
                            S.of(context).register,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                          if (_languageList.length > 0) {
                            addLanguagesList();
                            _con.requestRegisterHealer(requestHealer);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please select a language"),
                            ));
                          }
                        },
                      ),
                      ],
                    )
                )
              ],
            ),

      )


    );
  }
}
