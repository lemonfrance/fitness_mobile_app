const String pain = "Pain out of 10?";

// Level 1
const String walkBlock = "I can walk 1km";
const String climbStairs = "I can climb a flight of stairs";


// Level 2
const String runBlock = "I can run 1km";

// Level 3
const String runDistance = "I can run beyond 1km";
const String swimDistance = "I can swim beyond 1km";
const String bikeDistance = "I can bike beyond 1km";

List levelOneQuestions = [
  {"question": walkBlock, "selected": false, "type": "expandedPain", "pain": 0.0},
  {"question": climbStairs, "selected": false, "type": "expandedPain", "pain": 0.0},
];

// List of level 2 questions
List levelTwoQuestions = [
  {"question": runBlock, "selected": false, "type": "expandedPain", "pain": 0.0}
];

// List of level 3 questions
List levelThreeQuestions = [
  {"question": runDistance, "selected": false, "type": "expandedDistance", "distance": 0.0},
  {"question": swimDistance, "selected": false, "type": "expandedDistance", "distance": 0.0},
  {"question": bikeDistance, "selected": false, "type": "expandedDistance", "distance": 0.0},
];
