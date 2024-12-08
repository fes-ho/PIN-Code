class Member {
  Member({
    required this.username,
    required this.id,
  });

  final String username;
  final String id;

  Member.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      username = json['username'];
}