class Task {
  final String id;
  final String name;
  final String description;
  final String icon;
  final DateTime date;
  String? memberId;

  Task ({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.date,
    this.memberId,
  });

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        icon = json['icon'],
        date = DateTime.parse(json['date'],);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'date': date.toIso8601String(),
      'member_id': memberId,
    };
  }
}