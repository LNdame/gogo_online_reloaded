import 'package:flutter/material.dart';

class CardsVertCarouselLoaderWidget extends StatelessWidget {
  CardsVertCarouselLoaderWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 5)),
                ],
              ),
              child: Image.asset(
                'assets/img/loading_card.gif',
                fit: BoxFit.contain,
              ),
            );
          }),
    );
  }
}
