import 'package:flutter/material.dart';
import 'consts.dart';
import 'widgets/logo.dart';
import 'widgets/rounded_elevated_button.dart';

import 'widgets/country_and_phone_number_field.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData.from(colorScheme: mainColorScheme),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewSize = MediaQuery.of(context).size;
    var vh = viewSize.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                SizedBox(
                  height: vh * .28,
                  child: const Center(child: Logo()),
                ),
                CountryAndPhoneNumberField(
                  country: 'IN',
                  onValidated: onPhoneNumberValidated,
                ),
                SizedBox(
                  height: vh * .1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RoundedElevatedTextButton(
                      onPressed: handleLogin,
                      text: 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPhoneNumberValidated(number) {}

  void handleLogin() {}
}
