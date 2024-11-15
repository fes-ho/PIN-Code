import 'package:frontend/src/domain/type_of_mood.dart';

const Map<TypeOfMood, String> _moodEmojis = {
  TypeOfMood.excellent: "🌟",
  TypeOfMood.great: "😄",
  TypeOfMood.good: "😊",
  TypeOfMood.neutral: "😐",
  TypeOfMood.poor: "😕",
  TypeOfMood.bad: "😞",
};

extension MoodEmojiConverter on TypeOfMood {
  String getEmoji() {
    return _moodEmojis[this] ?? '';
  }
}
