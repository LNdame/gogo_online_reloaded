import 'package:flutter/material.dart';
import '../helpers/app_constants.dart';
import '../models/consultation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';

class UpcomingConsultationsCardWidget extends StatefulWidget {
  final Consultation consultation;
  final ValueChanged<void> onCanceled;

  const UpcomingConsultationsCardWidget({Key key, this.consultation, this.onCanceled}) : super(key: key);

  @override
  _UpcomingConsultationsCardWidgetState createState() => _UpcomingConsultationsCardWidgetState();
}

class _UpcomingConsultationsCardWidgetState extends State<UpcomingConsultationsCardWidget> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        bottom: 12.0,
        top: 0.0,
      ),
      height: ScreenUtil().setHeight(150.0),
      width: _size.width,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${S.of(context).date}\n",
                            style: Theme.of(context).textTheme.bodyText2 //merge(other)

                            ),
                        TextSpan(
                            text: "${widget.consultation.consultationDate}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .merge(TextStyle(fontWeight: FontWeight.bold, height: 1.5))),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${S.of(context).time}\n", style: Theme.of(context).textTheme.bodyText2),
                        TextSpan(
                            text: "${widget.consultation.consultationStartTime}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .merge(TextStyle(fontWeight: FontWeight.bold, height: 1.5))),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${S.of(context).healer}\n", style: Theme.of(context).textTheme.bodyText2),
                        TextSpan(
                            text: "${widget.consultation.productConsultations[0].product.healer.name}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .merge(TextStyle(fontWeight: FontWeight.bold, height: 1.5))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              "." * _size.width.ceil() * 2,
              maxLines: 1,
              style: TextStyle(
                color: Color.fromRGBO(190, 216, 245, 1),
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${S.of(context).name}\n", style: Theme.of(context).textTheme.bodyText2),
                        TextSpan(
                            text: "${widget.consultation.productConsultations[0].product.name}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .merge(TextStyle(fontWeight: FontWeight.bold, height: 1.5))),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    height: ScreenUtil().setHeight(38.0),
                    child: FlatButton(
                      child: Text(S.of(context).cancel,
                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.white))),
                      color: AppConstants.dangerColor,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
