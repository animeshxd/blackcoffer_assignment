import '../application/auth/login_cubit.dart';
import 'otp_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/state_manager.dart';

import '../firebase_options.dart';
import 'consts.dart';
import 'widgets/country_and_phone_number_field.dart';
import 'widgets/logo.dart';
import 'widgets/rounded_elevated_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  }
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(FirebaseAuth.instance),
      child: MaterialApp(
        title: 'Material App',
        theme: ThemeData.from(colorScheme: mainColorScheme),
        routes: {
          '/': (context) => const SignInPage(),
        },
        initialRoute: '/',
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, this.force = false});
  final bool force;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final LoginCubit loginCubit;

  @override
  void initState() {
    super.initState();
    loginCubit = context.read();
  }

  final phoneNumberIsValid = false.obs;
  final phoneNumber = ''.obs;
  late var force = widget.force;
  @override
  Widget build(BuildContext context) {
    var viewSize = MediaQuery.of(context).size;
    var vh = viewSize.height;
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        var messenger = ScaffoldMessenger.maybeOf(context);
        switch (state) {
          case LoginOTPRequired(confirmationResult: var confirmationResult):
            if (force) return;
            goToOtpPage(context, confirmationResult);
            break;
          case LoginFailedConnection():
            messenger?.showSnackBar(const SnackBar(
              content: Text('Connection Failed! Please check connecton'),
            ));
          default:
        }
      },
      builder: (context, state) {
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
                      onChanged: (value) => phoneNumberIsValid.value = false,
                    ),
                    SizedBox(
                      height: vh * .1,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Obx(() {
                          return RoundedElevatedTextButton(
                            onPressed:
                                phoneNumberIsValid.isFalse ? null : handleLogin,
                            text: 'Next',
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onPhoneNumberValidated(PhoneNumber number) {
    phoneNumber.value = number.completeNumber;
    phoneNumberIsValid.value = true;
    force = false;
  }

  void handleLogin() => context.read<LoginCubit>().signIn(phoneNumber.value);

  void goToOtpPage(
      BuildContext context, XConfirmationResult confirmationResult) {
    Navigator.maybeOf(context)?.pushReplacement(MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: loginCubit,
        child: OTPPage(
          confirmationResult: confirmationResult,
          phoneNumber: phoneNumber.value,
        ),
      ),
    ));
  }
}
