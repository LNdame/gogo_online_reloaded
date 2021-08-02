import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/product.dart';

typedef ProductBoolFunc = void Function(Product product, {bool reset});

class AddToWaitingRoomAlertDialogWidget extends StatelessWidget {
  final Product oldProduct;
  final Product newProduct;
  final ProductBoolFunc onPressed;

  const AddToWaitingRoomAlertDialogWidget({
    Key key,
    @required this.oldProduct,
    @required this.newProduct,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text( 'Reset Waiting Room?'),// S.of(context).reset_waiting_room),
      contentPadding: EdgeInsets.symmetric(vertical: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
            child: Text('You must add consultations of the same healer. Choose from one healer only!',
            //  S.of(context).you_must_add_products_of_the_same_healers_choose_one,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          InkWell(
            splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              onPressed(newProduct, reset: true);
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), blurRadius: 5, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'new_market' + this.newProduct?.healer?.id,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(image: NetworkImage(this.newProduct?.healer?.image?.thumb), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.newProduct.healer.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              SizedBox(height: 8),
                              Text(  'Reset your waiting room and add consultation from this healer',
                            //    S.of(context).reset_your_waiting_and_consultation_from_this_healer,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), blurRadius: 5, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'old_market' + this.oldProduct.healer.id,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(image: NetworkImage(this.oldProduct.healer.image.thumb), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.oldProduct.healer.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              SizedBox(height: 8),
                              Text( 'Keep your old consultations from this healer',
                               // S.of(context).keep_your_old_consultations_of_this_healer,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text('Reset'),// S.of(context).reset),
          onPressed: () {
            onPressed(newProduct, reset: true);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: new Text('Close'),//S.of(context).close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
