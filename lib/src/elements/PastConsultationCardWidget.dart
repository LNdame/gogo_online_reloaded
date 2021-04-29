import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/models/consultation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';

class PastConsultationCardWidget extends StatefulWidget {
  final Consultation consultation;

  const PastConsultationCardWidget({Key key, this.consultation}) : super(key: key);

  @override
  _PastConsultationCardWidgetState createState() => _PastConsultationCardWidgetState();
}

class _PastConsultationCardWidgetState extends State<PastConsultationCardWidget> {
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
      height: ScreenUtil().setHeight(180.0),
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
                            text: "01 Jan 2020",
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
                            text: "03:00 PM",
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
                            text: "Nafiz Kamal",
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
                            text: "${S.of(context).type}\n", style: Theme.of(context).textTheme.bodyText2),
                        TextSpan(
                            text: "Dentist",
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${S.of(context).place}\n", style: Theme.of(context).textTheme.bodyText2),
                        TextSpan(
                            text: "New City Clinic",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .merge(TextStyle(fontWeight: FontWeight.bold, height: 1.5))
                        ),
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
                      child: Text(S.of(context).reschedule,
                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.white))
                      ),
                      color: AppConstants.primaryColor,
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
