import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';


class BodyList extends StatelessWidget {
  final Widget child;  
  BodyList({
    @required this.child,    
  });
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            topLeft: Radius.circular(5),
          ),
        ),
        child: child,
        // ClipRRect(
        //   borderRadius: BorderRadius.only(
        //     topRight: Radius.circular(30),
        //     topLeft: Radius.circular(30),
        //   ),
        //   child: child,
        // ),
      ),
    );
  }
}
