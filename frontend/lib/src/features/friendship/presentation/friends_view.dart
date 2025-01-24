import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/features/friendship/application/friendship_service.dart';
import 'package:frontend/src/features/friendship/presentation/friend_component.dart';
import 'package:frontend/src/features/friendship/presentation/search_friend_view.dart';
import 'package:frontend/src/features/friendship/presentation/leaderboard_view.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Friends', 
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            color: colorScheme.secondary,
          )
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed(SearchFriendView.routeName);
              updateFriendsState();
            },
            heroTag: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LeaderboardView()),
              );
            },
            heroTag: null,
            child: const Icon(Icons.leaderboard),
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => Friend(member: _friends[index], updateFriendsState: updateFriendsState,),
        separatorBuilder: (context, index) => const SizedBox(height: 2,),
        itemCount: _friends.length),
    );
  }
}
