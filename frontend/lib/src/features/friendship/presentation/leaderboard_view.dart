import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/features/friendship/application/friendship_service.dart';
import 'package:frontend/src/features/friendship/presentation/leaderboard_component.dart';
import 'package:frontend/src/features/streaks/services/streak_service.dart';
import 'package:get_it/get_it.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  List<Member> _friends = [];
  List<(Member, int)> _friendsByCurrentStreak = [];
  List<int> _streaks = [];

  void updateFriendsState() {
    GetIt.I<FriendshipService>().getFriends().then((result) => setState(() {
          _friends = result;
        }));
  }

  void updateStreaksState(List<Member> members) {
    _streaks = [];
    for (Member member in members){
      GetIt.I<StreakService>().getStreaksByUserId(member.id).then((result) => setState(() {
          _streaks.add(result.length);
        }));
    }
  }

  void sortFriendsByCurrentStreak() {
    _friendsByCurrentStreak = [];

    for (int i = 0; i < _friends.length; i++){
      _friendsByCurrentStreak.add((_friends[i], _streaks[i]));
    }
    
    _friendsByCurrentStreak.sort(((a, b) => (a.$2).compareTo(b.$2)));
  }

  @override
  void initState() {
    super.initState();
    updateFriendsState();
    updateStreaksState(_friends);
    sortFriendsByCurrentStreak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Leaderboard"),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => LeaderboardComponent(member: _friendsByCurrentStreak[index].$1, currentStreak: _friendsByCurrentStreak[index].$2),
        separatorBuilder: (context, index) => const SizedBox(height: 10,),
        itemCount: _friends.length),
    );
  }
}