import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import '../../../assets/colors.dart';
import '../../../widgets/appText.dart';

class OTPScreen extends ConsumerWidget {
  final String verificationId;
  static const String routeName = '/otp-screen';
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyOTP(WidgetRef ref,BuildContext context,String userOTP){
    ref.read(authControllerProvider).verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: "Verifying your number"),
        backgroundColor: backgroundColor,
      ),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            const AppText(text: 'We have sent an SMS with code.',),
            SizedBox(
              width: size.width*0.5,
              child:  TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val){
                  if(val.length == 6){
                    verifyOTP(ref, context, val.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}