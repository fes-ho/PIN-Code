enum Frequency {
  daily,
  weekly,
  monthly
}

Frequency frequencyfromJson(String json) {
  switch (json) {
    case "daily":
      return Frequency.daily;
    case "weekly":
      return Frequency.weekly;
    case "monthly":
      return Frequency.monthly;
    default:
      throw ArgumentError("Unknown frequency: $json");
  }
}