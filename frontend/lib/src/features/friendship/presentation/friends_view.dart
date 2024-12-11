import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/features/friendship/application/friendship_service.dart';
import 'package:frontend/src/features/friendship/presentation/friend_component.dart';
import 'package:frontend/src/features/friendship/presentation/search_friend_view.dart';
import 'package:frontend/src/features/friendship/presentation/leaderboard_view.dart';
import 'package:get_it/get_it.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  List<Member> _friends = [];

  void updateFriendsState() {
    GetIt.I<FriendshipService>().getFriends().then((result) => setState(() {
          _friends = result;
        }));
  }

  @override
  void initState() {
    super.initState();
    updateFriendsState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Friends"),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).pushNamed(SearchFriendView.routeName);
              updateFriendsState();
            }
          ),
          FloatingActionButton(
            child: const Icon(Icons.leaderboard),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LeaderboardView()),
              );
            }
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => Friend(member: _friends[index], updateFriendsState: updateFriendsState,),
        separatorBuilder: (context, index) => const SizedBox(height: 10,),
        itemCount: _friends.length),
    );
  }
}
