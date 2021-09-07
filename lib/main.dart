import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Screens/wrapper.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;

import 'Services/fitbit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Future getRefreshToken() async {
  await FitBitService().getRefreshToken(global.refreshToken);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (global.fitBitAccount) {
      getRefreshToken();
    }
    return MaterialApp(
      title: 'Wearable Intelligence',
      theme: AppTheme.theme,
      home: Wrapper(),
    );
  }
}
