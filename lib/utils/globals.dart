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
var weekActivityMinutes = [0, 0, 0, 0, 0, 0, 0];
var workoutHeartRates = List.filled(30, heartRates('', 0));
var workoutHeartRatesDB = List.filled(30, 0);
var dayHeartRates = List.filled(24, heartRates('', 0));

class heartRates {
  heartRates(this.time, this.value);
  final String time;
  final int value;
}
