import 'package:frontend/src/features/moods/domain/type_of_mood.dart';

class Mood {
  final String id;
  final DateTime day;
  final TypeOfMood typeOfMood;
  final String memberId;

  Mood({
    required this.id,
    required this.day,
    required this.typeOfMood,
    required this.memberId
  });

  Mood.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      day = DateTime.parse(json['day']),
      typeOfMood = typeFromMoodfromJson(json['type_of_mood']),
      memberId = json['member_id'];

}