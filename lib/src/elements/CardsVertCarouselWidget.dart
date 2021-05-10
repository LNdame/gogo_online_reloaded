import 'package:flutter/material.dart';
import 'package:gogo_online/src/elements/CardsVertCarouselLoaderWidget.dart';
import 'package:gogo_online/src/models/healer.dart';
import 'package:gogo_online/src/models/route_argument.dart';

import 'CardWidget.dart';

// ignore: must_be_immutable
class CardsVertCarouselWidget extends StatefulWidget {
  List<Healer> healersList;
  String heroTag;

  CardsVertCarouselWidget({Key key, this.healersList, this.heroTag})
      : super(key: key);

  @override
  _CardsVertCarouselWidgetState createState() =>
      _CardsVertCarouselWidgetState();
}

class _CardsVertCarouselWidgetState extends State<CardsVertCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.healersList.isEmpty
        ? CardsVertCarouselLoaderWidget()
        : Container(
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.healersList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/Details',
                          arguments: RouteArgument(
                            id: widget.healersList.elementAt(index).id,
                            heroTag: widget.heroTag,
                          ));
                    },
                    child: CardWidget(
                        healer: widget.healersList.elementAt(index),
                        heroTag: widget.heroTag),
                  );
                }),
          );
  }
}
