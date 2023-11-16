import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/state_manager.dart';

import '../application/account/account_cubit.dart';
import '../application/auth/login_cubit.dart';
import '../firebase_options.dart';
import 'consts.dart';
import 'widgets/auth_aware.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(FirebaseAuth.instance),
        ),
        BlocProvider(
          create: (context) => AccountCubit(FirebaseFirestore.instance),
        ),
      ],
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

  /// Include fragment for `force=true` args
  static const path = '/login';
  static const pathWithForced = '/login#force';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final LoginCubit loginCubit;

  @override
  void initState() {
    super.initState();
    loginCubit = context.read()..initilize();
  }

  final phoneNumberIsValid = false.obs;
  final phoneNumber = ''.obs;
  late var force = widget.force;
  @override
  Widget build(BuildContext context) {
    var viewSize = MediaQuery.of(context).size;
    var vh = viewSize.height;
    return Scaffold(
      body: SafeArea(
        child: AuthAware(
          child: SingleChildScrollView(
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
      ),
    );
  }

  void onPhoneNumberValidated(PhoneNumber number) {
    phoneNumber.value = number.completeNumber;
    phoneNumberIsValid.value = true;
    force = false;
  }

  void handleLogin() => context.read<LoginCubit>().signIn(phoneNumber.value);

}
