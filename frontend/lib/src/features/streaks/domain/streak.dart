class Streak {
  final DateTime date;
  Streak({required this.date});

  Streak.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']);
}