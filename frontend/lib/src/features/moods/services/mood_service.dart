// import 'dart:convert';

// import 'package:frontend/src/config.dart';
// import 'package:frontend/src/features/authentication/application/member_service.dart';
// import 'package:frontend/src/features/moods/domain/mood.dart';
// import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
// import 'package:frontend/src/utils/date_time_utils.dart';
// import 'package:frontend/src/utils/headers_factory.dart';
// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart';

// class MoodService {
//   MoodService() {
//   }


//   Mood? _todayMood;
//   List<Mood>? _memberMoods;

//   Future<TypeOfMood?> getMood() async {
//     _todayMood ??= await _getMood();

//     return _todayMood?.typeOfMood;
//   }

//   Future<Mood?> _getMood() async {
//     return Mood.fromJson(jsonDecode(response.body));
//   }

//   Future manageMood(TypeOfMood typeOfMood) async{
//     if (_todayMood == null) {
//       await _createMood(typeOfMood);

//       return;
//     }

//     if (_todayMood!.typeOfMood == typeOfMood) {
//       await _deleteMood();
//       return;
//     }

//     await _updateMood(typeOfMood);

//     if (_memberMoods != null) {
//       _memberMoods!.add(_todayMood!);
//     }
//   }

//   Future _createMood(TypeOfMood typeOfMood) async {

//     Mood mood = Mood(
//       id: null, 
//       day: getTodayDate(), 
//       typeOfMood: typeOfMood, 
//       memberId: userId
//     );

//     return _todayMood!;
//   }

//   Future _updateMood(TypeOfMood typeOfMood) async {
//     String moodId = _todayMood!.id!;
//     String typeOfMoodValue = typeOfMood.name;

//     if (response.statusCode == 200) {
//       _todayMood = Mood.fromJson(jsonDecode(response.body));
//     }
//   }

//   Future<List<Mood>> getMemberMoods() async {
//     if (_memberMoods != null) {
//       return _memberMoods!;
//     }

//     String memberId = _memberService.getCurrentUserId();

//     final response = await _client.get(
//       Uri.parse('${Config.apiUrl}/members/$memberId/moods'),
//       headers: await _headersFactory.getDefaultHeaders(),
//     );

//     if (response.statusCode != 200) {
//       return [];
//     }

//     return _memberMoods!;
//   }
  
//   Future _deleteMood() async {
//     if (_todayMood == null) {
//       return;
//     }

//     final response = await _client.delete(
//       Uri.parse('${Config.apiUrl}/members/mood/${_todayMood!.id}'),
//       headers: await _headersFactory.getDefaultHeaders(),
//     );

//     if (response.statusCode == 200) {
//       _todayMood = null;
//     }

//     if (_memberMoods != null && _memberMoods!.any((mood) => mood.id == _todayMood!.id)) {
//       _memberMoods!.removeWhere((mood) => mood.id == _todayMood!.id);
//     }
//   }
// }