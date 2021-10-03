class ExercisePlan {
  final String type;
  final String description;
  final String heartRate;
  final int reps;

  ExercisePlan(this.type, this.description, this.heartRate, this.reps);

  String get getType{
    return this.type;
  }

  String get getDescription{
    return this.description;
  }

  String get getHeartRate{
    return this.heartRate;
  }

  int get getReps{
    return this.reps;
  }
}
