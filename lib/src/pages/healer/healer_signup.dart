import 'package:flutter/material.dart';
import 'package:gogo_online/generated/l10n.dart';
import 'package:gogo_online/src/controllers/healer_controller.dart';
import 'package:gogo_online/src/elements/BlockButtonWidget.dart';
import 'package:gogo_online/src/elements/ProfileAvatarWidget.dart';
import 'package:gogo_online/src/helpers/helper.dart';
import 'package:gogo_online/src/models/healer.dart';
import 'package:gogo_online/src/repository/user_repository.dart';
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

  Healer requestHealer;
  _HealerRegistrationWidgetState(): super(HealerController()){
    _con = controller;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRequestHealer();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
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
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) =>{}, //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText:"Province",  //S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: "Gauteng",// S.of(context).siya_nkosi,
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
                          setState(() {_afrikaansChecked =value;});
                            },
                        title: Text("Afrikaans", style: Theme.of(context).textTheme.caption),
                        selectedTileColor: Theme.of(context).colorScheme.secondary,
                        controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _englishChecked,
                          onChanged: (value){
                            setState(() {_englishChecked =value;});
                          },
                          title: Text("English", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),

                        CheckboxListTile(value: _sepediChecked,
                          onChanged: (value){
                            setState(() {_sepediChecked =value;});
                          },
                          title: Text("Sepedi", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _sesothoChecked,
                          onChanged: (value){
                            setState(() {_sesothoChecked =value;});
                          },
                          title: Text("Sesotho", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _southernNdebeleChecked,
                          onChanged: (value){
                            setState(() {_southernNdebeleChecked =value;});
                          },
                          title: Text("Southern Ndebele", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _swaziChecked,
                          onChanged: (value){
                            setState(() {_swaziChecked =value;});
                          },
                          title: Text("Swazi", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _tsongaChecked,
                          onChanged: (value){
                            setState(() {_tsongaChecked =value;});
                          },
                          title: Text("Tsonga", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _tswanaChecked,
                          onChanged: (value){
                            setState(() {_tswanaChecked =value;});
                          },
                          title: Text("Tswana", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _vendaChecked,
                          onChanged: (value){
                            setState(() {_vendaChecked =value;});
                          },
                          title: Text("Venda", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _xhosaChecked,
                          onChanged: (value){
                            setState(() {_xhosaChecked =value;});
                          },
                          title: Text("Xhosa", style: Theme.of(context).textTheme.caption),
                          selectedTileColor: Theme.of(context).colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,),
                        SizedBox(height: 12,),
                        CheckboxListTile(value: _zuluChecked,
                          onChanged: (value){
                            setState(() {_zuluChecked =value;});
                          },
                          title: Text("Zulu", style: Theme.of(context).textTheme.caption),
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
                          onSaved: (input) =>requestHealer.phone = requestHealer.mobile =input, //_con.user.name = input,
                          decoration: InputDecoration(
                            labelText: "Practice number (optional)",//S.of(context).full_address,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText:"012 566 7685",// S.of(context).siya_nkosi,
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
                            _con.requestRegisterHealer(requestHealer);
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
