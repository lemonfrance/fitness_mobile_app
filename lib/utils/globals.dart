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
int restingHeartRate = 0;
int pageIndex = 1;
int level = 0;
bool firstFitbit = false;

var weekPlan = [];
var weekActivityMinutes = [];

// Clock globals
CountDownController restController = CountDownController();
CountDownController exerciseController = CountDownController();

bool exerciseMode = false;
bool paused = false;
bool ended = false;
bool rest = false;
bool start = true;
int reps = 2;
int exerciseTime = 10;
int restTime = 5;
int elapsedTime = 0;
