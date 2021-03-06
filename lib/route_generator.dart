import 'package:flutter/material.dart';
import 'package:gogo_online/src/controllers/cart_controller.dart';
import 'package:gogo_online/src/models/cart.dart';
import 'package:gogo_online/src/pages/consultations.dart';
import 'package:gogo_online/src/pages/healer/healer_signup.dart';
import 'package:gogo_online/src/pages/healer/healer_signup_success.dart';
import 'package:gogo_online/src/pages/netcash_payment.dart';
import 'package:gogo_online/src/pages/scheduler.dart';
import 'src/pages/healer/healer_pages.dart';
import 'src/pages/onboarding.dart';

import 'src/models/route_argument.dart';
import 'src/pages/paystack_payment.dart';
import 'src/pages/waiting_room.dart';
import 'src/pages/category.dart';
import 'src/pages/checkout.dart';
import 'src/pages/debug.dart';
import 'src/pages/delivery_addresses.dart';
import 'src/pages/consultation_summary.dart';
import 'src/pages/details.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/login.dart';
import 'src/pages/menu_list.dart';
import 'src/pages/consultation_success.dart';
import 'src/pages/pages.dart';
import 'src/pages/payment_methods.dart';
//import 'src/pages/paypal_payment.dart';
import 'src/pages/product.dart';
import 'src/pages/profile.dart';
//import 'src/pages/razorpay_payment.dart';
import 'src/pages/reviews.dart';
import 'src/pages/settings.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/tracking.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Onboarding':
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      case '/HealerPages':
        return MaterialPageRoute(builder: (_) => HealerPagesWidget(currentTab: args));
      case '/HealerRegister':
        return MaterialPageRoute(builder: (_) => HealerRegistrationWidget());
      case '/HealerRegisterSuccess':
        return MaterialPageRoute(builder: (_) => HealerSignUpSuccessWidget());
      case '/Details':
        return MaterialPageRoute(builder: (_) => DetailsWidget(routeArgument: args));
      case '/Menu':
        return MaterialPageRoute(builder: (_) => MenuWidget(routeArgument: args as RouteArgument));
      case '/Product':
        return MaterialPageRoute(builder: (_) => ProductWidget(routeArgument: args as RouteArgument));
      case '/Category':
        return MaterialPageRoute(builder: (_) => CategoryWidget(routeArgument: args as RouteArgument));
      case '/Cart':
        return MaterialPageRoute(builder: (_) => WaitingRoomWidget(routeArgument: args as RouteArgument));
      case '/Consultation':
        return MaterialPageRoute(builder: (_) => ConsultationsWidget());
      case '/Tracking':
        return MaterialPageRoute(builder: (_) => TrackingWidget(routeArgument: args as RouteArgument));
      case '/Reviews':
        return MaterialPageRoute(builder: (_) => ReviewsWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/DeliveryAddresses':
        return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget());
      case '/ConsultationSummary':
        return MaterialPageRoute(builder: (_) => ConsultationSummaryWidget(routeArgument: args as RouteArgument));
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/CashOnDelivery':
        return MaterialPageRoute(builder: (_) => ConsultationSuccessWidget(routeArgument: RouteArgument(param: 'Cash on Delivery')));
      case '/PayOnPickup':
        return MaterialPageRoute(builder: (_) => ConsultationSuccessWidget(routeArgument: RouteArgument(param: 'Pay on Pickup')));
      case '/NetCash':
        return MaterialPageRoute(builder: (_) => NetCashPaymentWidget(routeArgument: args as RouteArgument));
      case '/PayStack':
        return MaterialPageRoute(builder: (_) => PayStackPaymentWidget(routeArgument: args as RouteArgument));
     /* case '/RazorPay':
        return MaterialPageRoute(builder: (_) => RazorPayPaymentWidget(routeArgument: args as RouteArgument));*/
      case '/OrderSuccess':
        return MaterialPageRoute(builder: (_) => ConsultationSuccessWidget(routeArgument: args as RouteArgument));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/Scheduler':
        var cart = settings.arguments as Cart;
        var con = settings.arguments as CartController;
        return MaterialPageRoute(builder: (_)=> SchedulerWidget(cart: cart, con: con ));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
