enum DayTime {
  morning,
  afternoon,
  evening,
  night,
  anytime,
}

DayTime dayTimefromJson(String json) {
  switch (json) {
    case "morning":
      return DayTime.morning;
    case "afternoon":
      return DayTime.afternoon;
    case "evening":
      return DayTime.evening;
    case "night":
      return DayTime.night;
    case "anytime":
      return DayTime.anytime;
    default:
      throw ArgumentError("Unknown dayTime: $json");
  }
}
