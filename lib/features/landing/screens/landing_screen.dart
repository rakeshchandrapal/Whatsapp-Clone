import 'package:flutter/material.dart';
import 'package:whatsapp_clone/assets/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';

import '../../../widgets/appText.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context){
    Navigator.pushNamed(context,LoginScreen.routeName);
  }
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const SizedBox(height: 50,),
             const Center(child:  AppText(text:'Welcome to WhatsApp',size :33 ,weight: FontWeight.w600,)),
              SizedBox(height: size.height/9,),
              Image.asset('lib/assets/images/bg.png',height: 340,width: 340,color: tabColor,),
              SizedBox(height: size.height/9,),
              const Padding(
                padding:  EdgeInsets.all(15.0),
                child:  AppText(text:'Read ur privacy policy. Tap "Agree and Continue " to accept the terms and services.',color: greyColor,align: TextAlign.center,),
              ),

              SizedBox(
                  width: size.width*0.75,
                  child: CustomButton(text: 'AGREE AND CONTINUE',onPressed: () => navigateToLoginScreen(context ),))

            ],

        ),
      ),
    );
  }
}