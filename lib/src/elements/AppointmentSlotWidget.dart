import 'package:flutter/material.dart';
import '../helpers/app_constants.dart';
import '../utils/ThemeUtil.dart';

class AppointmentSlotWidget extends StatefulWidget {
  final String timeOfDay;
  final List<String> times;
  final String selectedTime;
  final Function setSelectedTime;

  const AppointmentSlotWidget({Key key, this.timeOfDay, this.times, this.selectedTime, this.setSelectedTime})
      : super(key: key);

  @override
  _AppointmentSlotWidgetState createState() => _AppointmentSlotWidgetState();
}

class _AppointmentSlotWidgetState extends State<AppointmentSlotWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            this.widget.timeOfDay,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 12.0),
          Wrap(
            alignment: WrapAlignment.center,
            children: this.widget.times.map(
              (e) {
                return GestureDetector(
                  onTap: () {
                    this.widget.setSelectedTime(e);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 120),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 14.0,
                    ),
                    decoration: BoxDecoration(
                        color: this.widget.selectedTime ==e?
                        Theme.of(context).primaryColorLight: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: ThemeUtil.lightDarkColor(Color.fromRGBO(255, 255, 255, 0.2),
                                  AppConstants.darkBackground, Theme.of(context).brightness)
                          )
                        ],
                        border: Border.all(
                          color: ThemeUtil.lightDarkColor(
                            Colors.grey[300],
                            Colors.grey[900],
                            Theme.of(context).brightness,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(
                          7.0,
                        )),
                    margin: EdgeInsets.only(top: 4.0, right: 4.0, bottom: 4.0),
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}
