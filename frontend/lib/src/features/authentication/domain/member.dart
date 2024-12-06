class Member {
  Member({
    required this.username,
    required this.id,
    this.picture
  });

  final String username;
  final String id;
  final String? picture;

  Member.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      username = json['username'],
      picture = json['picture'];
}