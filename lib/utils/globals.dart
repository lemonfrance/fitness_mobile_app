import 'dart:math';

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
double heartRatePeak = 0;
double heartRatePit = 0;
int averageHeartRate = 0;
int restingHeartRate = 0;
int pageIndex = 1;
int level = 0;
bool firstFitbit = false;
//added rewards: TODO must get values from DB
int solarOrbsGained = 0;
int waterDropsGained = 0;

var weekPlan = [];
var weekActivityMinutes = [0, 0, 0, 0, 0, 0, 0];
var workoutHeartRates = List.filled(weekPlan[0].getReps * 2, heartRates('', 0));
var workoutHeartRatesDB = List.filled(weekPlan[0].getReps * 2, 0);
var dayHeartRates = List.filled(24, heartRates('', 0));
bool exercisedToday = false;

class heartRates {
  heartRates(this.time, this.value);
  final String time;
  final int value;
}

void heartRateWorkoutCalcs() {
  heartRatePeak = workoutHeartRatesDB.reduce(max).toDouble();
  heartRatePit = heartRatePeak;
  for (int i in workoutHeartRatesDB) {
    if (i != 0 && i < heartRatePit) {
      heartRatePit = i.toDouble();
    }
  }

  int count = 0;
  int value = 0;
  for (int i in workoutHeartRatesDB) {
    if (i != 0) {
      value += i;
      count++;
    }
  }

  averageHeartRate = (value / count).toInt();
}

void heartRateDayCalcs() {
  heartRatePeak = dayHeartRates.map((m) => m.value).reduce(max) as double;
  heartRatePit = dayHeartRates.map((m) => m.value).reduce(min) as double;
}
