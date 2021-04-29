import 'package:flutter/material.dart';
import 'package:gogo_online/src/controllers/cart_controller.dart';
import 'package:gogo_online/src/elements/AppointmentSlotWidget.dart';
import 'package:gogo_online/src/elements/BlockButtonWidget.dart';
import 'package:gogo_online/src/helpers/helper.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';
import '../../generated/l10n.dart';

class SchedulerWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final Cart cart;
  final CartController _con;
  const SchedulerWidget({Key key, @required this.cart, this.routeArgument, @required CartController con}) : _con=con, super(key: key);


  @override
  _SchedulerWidgetState createState() => _SchedulerWidgetState();
}

class _SchedulerWidgetState extends State<SchedulerWidget> {

  Map<DateTime, List<dynamic>> _events;
  String selectedTime = "";
  List<dynamic> _selectedEvents;
  DateTime _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  DateTime kNow ;
  DateTime kFirstDay ;
  DateTime kLastDay ;

  @override
  void initState() {
    super.initState();

    _events = {};
    _selectedEvents = [];
    _selectedDate = new DateTime.now();

    kNow =  DateTime.now();
    kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
    kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  Future<void> saveConsultationDateTime(String selectedTime, DateTime date) async {
    widget.cart.consultationStartTime = selectedTime;
    String selectedDate = "${date.year}-${date.month}-${date.day}";
    widget.cart.consultationDate = selectedDate;
   await widget._con.updateDateTime(widget.cart);

  }

  @override
  Widget build(BuildContext context) {
    final setSelectedTime = (String val) {
      setState(() {
        selectedTime = val;
      });
    };

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true ,
        leading: IconButton(
          onPressed: () {
            if (widget.routeArgument != null) {
              Navigator.of(context).pushReplacementNamed(widget.routeArgument.param, arguments: RouteArgument(id: widget.routeArgument.id));
            } else {
              Navigator.of(context).pushNamed('/Cart', arguments: RouteArgument(param: '/Pages', id: '2'));
            }
          },
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).hintColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).scheduler,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
        child: BlockButtonWidget(
          text: Text(
            S.of(context).set_consultation_date,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () async{
            await saveConsultationDateTime(selectedTime, _selectedDate).then((value) {
              Navigator.of(context).pushNamed('/Cart', arguments: RouteArgument(param: '/Pages', id: '2'));
            }, onError: (e)=>print(e));
          },
        )
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(padding:  EdgeInsets.only(top: 15, left: 20, right: 20),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.calendar_today_rounded,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(widget.cart.product.name , style: Theme.of(context).textTheme.headline2,),
                subtitle: Helper.getPrice(widget.cart.product.price, context, style: Theme.of(context).textTheme.bodyText2, zeroPlaceholder: 'Free'),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppointmentSlotWidget(
                timeOfDay: "Appointment Slot",
                times: [
                  "07:00",
                  "08:00",
                  "09:00",
                  "10:00",
                  "11:00",
                  "12:00",
                  "13:00",
                  "14:00",
                  "15:00",
                  "16:00",
                  "17:00",
                  "18:00",
                  "19:00",
                  "20:00",
                  "21:00"
                ],
                setSelectedTime: setSelectedTime,
                selectedTime: selectedTime,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.twoWeeks,
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Colors.orange,
                  selectedColor: Theme.of(context).accentColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: true,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events, holidays){
                setState(() {
                  _selectedDate = date;
                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _calendarController,
            ),*/