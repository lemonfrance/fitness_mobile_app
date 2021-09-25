import 'package:circular_countdown_timer/circular_countdown_timer.dart';

String? authToken;
String? uid;
String? accessToken;
String? refreshToken;
String? name;
bool fitBitAccount = false;
int heartRate = 0;
int calories = 0;
int weightloss = 0;
int totalHours = 0;
String? user_id;
int heartRateMin = 0;
int heartRateMax = 0;
List<int> weekActivityMinutes = [];
int pageIndex = 1;

// Clock globals
bool exerciseMode = false;
CountDownController timerController = CountDownController();
int totalTime = 3;
int elapsedTime = 0;
