import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:wearable_intelligence/utils/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wearable Intelligence',
      theme: AppTheme.theme,
      home: Wrapper(),
    );
  }
}
