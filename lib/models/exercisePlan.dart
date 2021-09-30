class ExercisePlan {
  final String type;
  final String description;
  final String heartRate;
  final String duration;

  ExercisePlan(this.type, this.description, this.heartRate, this.duration);

  String get getType{
    return this.type;
  }

  String get getDescription{
    return this.description;
  }

  String get getHeartRate{
    return this.heartRate;
  }

  String get getDuration{
    return this.duration;
  }
}
