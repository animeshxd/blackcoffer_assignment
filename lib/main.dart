import 'package:blackcoffer_assignment/application/post/post_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/account/account_cubit.dart';
import 'application/auth/login_cubit.dart';
import 'application/camera_bloc/camera_bloc.dart';
import 'application/location_cubit/locations_cubit.dart';
import 'application/location_humanizer/location_humanizer_cubit.dart';
import 'firebase_options.dart';
import 'presentaion/consts.dart';
import 'presentaion/routes/routes.dart';
import 'repository/reverse_geocode_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    try {
      await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    } catch (_) {}
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
        BlocProvider(create: (context) => CameraBloc()),
        BlocProvider(create: (context) => LocationsCubit()),
        BlocProvider(
          create: (context) => PostCubit(
            storage: FirebaseStorage.instance,
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
        BlocProvider(
          create: (context) => LocationHumanizerCubit(ReverseGeocodeClient()),
        )
      ],
      child: MaterialApp.router(
        theme: mainThemeData,
        routerConfig: routes,
      ),
    );
  }
}
