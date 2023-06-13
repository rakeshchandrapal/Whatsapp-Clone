import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/assets/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import '../../../widgets/appText.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .singInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    }
    else {
      showSnackBar(context: context, content: 'Fill Out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: "Enter your phone number"),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppText(text: 'Whatsapp need to verify your number.'),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: pickCountry,
                child: const AppText(text: 'Pick Country')),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                if (country != null)
                  AppText(
                    text: '+${country!.phoneCode}',
                  ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(hintText: 'phone number'),
                  ),
                ),
              ],
            ),
            Flexible(
              child: SizedBox(
                height: size.height * 0.5,
              ),
            ),
            SizedBox(
              width: 90,
              child: CustomButton(
                text: 'NEXT ',
                onPressed: sendPhoneNumber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}