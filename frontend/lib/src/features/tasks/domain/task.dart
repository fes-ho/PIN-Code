class Task {
  final String? id;
  final String name;
  final String description;
  final String icon;
  final DateTime date;
  bool isCompleted;
  String? memberId;
  int? duration;
  int? estimatedDuration;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.date,
    required this.isCompleted,
    this.memberId,
    this.duration,
    this.estimatedDuration,
  });

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        icon = json['icon'],
        isCompleted = json['is_completed'],
        date = DateTime.parse(json['date']),
        duration = json['duration'],
        estimatedDuration = json['estimated_duration'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'date': date.toIso8601String(),
      'member_id': memberId,
      'is_completed': isCompleted,
      'duration': duration,
      'estimated_duration': estimatedDuration,
    };
  }
}