enum TypeOfMood {
  excellent,
  great,
  good,
  neutral,
  poor,
  bad,
}

TypeOfMood typeFromMoodfromJson(String json) {
  switch (json) {
    case "excellent":
      return TypeOfMood.excellent;
    case "great":
      return TypeOfMood.great;
    case "good":
      return TypeOfMood.good;
    case "neutral":
      return TypeOfMood.neutral;
    case "poor":
      return TypeOfMood.poor;
    case "bad":
      return TypeOfMood.bad;
    default:
      throw ArgumentError("Unknown mood: $json");
  }
}
