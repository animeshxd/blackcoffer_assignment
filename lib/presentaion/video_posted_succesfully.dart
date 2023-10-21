import 'package:flutter/material.dart';

import 'consts.dart';
import 'widgets/main_app_body.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: mainThemeData,
      home: const VideoPostedSuccesfullPage(),
    );
  }
}

class VideoPostedSuccesfullPage extends StatelessWidget {
  const VideoPostedSuccesfullPage({
    super.key,
  }); 
  
  @override
  Widget build(BuildContext context) {
    return const MainAppBody(
      body: Center(
        child: Text(
          'Your video posted succesfully.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
