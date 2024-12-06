import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/features/friendship/application/friendship_service.dart';
import 'package:frontend/src/features/friendship/presentation/friend_component.dart';
import 'package:get_it/get_it.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  List<Member> _friends = [];

  @override
  void initState() {
    super.initState();
    GetIt.I<FriendshipService>().getFriends().then((result) => setState(() {
          _friends = result;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) => Friend(member: _friends[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 10,),
        itemCount: _friends.length),
    );
  }
}
