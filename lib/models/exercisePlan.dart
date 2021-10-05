class ExercisePlan {
  String type;
  String description;
  String heartRate;
  int reps;
  int rest;

  ExercisePlan(this.type, this.description, this.heartRate, this.reps, this.rest);

  String get getType{
    return this.type;
  }

  set setType(String type){
    this.type = type;
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

  set setReps(int reps){
    this.reps = reps;
  }

  int get getRest{
    return this.rest;
  }

  set setRest(int rest){
    this.rest = rest;
  }

}
