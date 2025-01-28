enum Category {
  sleep,
  work,
  hydration,
  exercise,
  food,
}

Category categoryfromJson(String json) {
  switch (json) {
    case "sleep":
      return Category.sleep;
    case "work":
      return Category.work;
    case "hydration":
      return Category.hydration;
    case "exercise":
      return Category.exercise;
    case "food":
      return Category.food;
    default:
      throw ArgumentError("Unknown category: $json");
  }
}