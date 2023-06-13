import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

import 'common/widgets/error_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/user_information_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings ){
  switch(settings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(builder: (context) =>  OTPScreen(verificationId: verificationId,));
    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => const UserInformationScreen());
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SelectContactsScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String , dynamic>;
       final name = arguments['name'];
       final uid  = arguments['uid'];
      return MaterialPageRoute(builder: (context) =>  MobileChatScreen(
       name: name,
        uid: uid,
      ));

    default:
        return MaterialPageRoute(builder: (context) => const Scaffold(body: ErrorScreen(error: 'This page does\'not exists')) );
  }
}