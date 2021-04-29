import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../generated/l10n.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreenWidget extends StatefulWidget {
  @override
  _OnboardingScreenWidgetState createState() => _OnboardingScreenWidgetState();
}

class _OnboardingScreenWidgetState extends State<OnboardingScreenWidget> {
  PageController _controller = PageController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: PageView(
              controller: _controller,
              children: [
                _slideTemplate(
                    title: S.of(context).welcome_text,
                    subtitle: S.of(context).welcome_subtitle,
                    lottieAsset: "assets/anims/ehealthuser.json"),
                _slideTemplate(
                    title: S.of(context).book_appointment,
                    subtitle: S.of(context).book_appointment_subtitle,
                    lottieAsset: "assets/anims/calendarappointment.json"),
                _slideTemplate(
                  title: S.of(context).chat_with_specialists,
                  subtitle: S.of(context).chat_specialist_subtitle,
                  lottieAsset: "assets/anims/chat.json",
                ),
              ],
            ),
          ),
        ),
        SmoothPageIndicator(
          count: 3,
          controller: _controller,
          effect: WormEffect(
            dotWidth: 10.0,
            dotHeight: 10.0,
            dotColor: Colors.grey[300],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget _slideTemplate({String title, String subtitle, String lottieAsset}) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      constraints: BoxConstraints(maxWidth: _size.width * 0.8),
      child: Column(
        children: [
          Expanded(
            child: Lottie.asset(lottieAsset),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          SizedBox(height: 5.0),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget _slideTemplateImg({String title, String subtitle, String asset}) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      constraints: BoxConstraints(maxWidth: _size.width * 0.8),

      child: Column(
        children: [
          Expanded(
            child: Image.asset(asset),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          SizedBox(height: 5.0),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
