import 'package:flutter/material.dart';
import 'consts.dart';
import 'widgets/main_app_body.dart';
import 'widgets/rounded_elevated_button.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: mainThemeData,
      home: const GPSPermissionPage(),
    );
  }
}

class GPSPermissionPage extends StatelessWidget {
  const GPSPermissionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MainAppBody(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: RoundedElevatedTextButton(
            text: 'Allow GPS Permisson',
            onPressed: onAllowGPSPermissionRequested,
          ),
        ),
      ),
    );
  }

  void onAllowGPSPermissionRequested() {}
}
