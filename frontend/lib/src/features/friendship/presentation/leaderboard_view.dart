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
  List<MapEntry<String, int>> _orderedFriendEntries = [];
  Map<String, int> _friendIdStreakMap = {};

  void updateFriendsState() {
    GetIt.I<FriendshipService>().getFriendsAndActualMember().then((result) => setState(() {
          _friends = result;
          updateStreaksState(_friends);

        }));
  }

  void updateStreaksState(List<Member> members) {
    for (Member member in members){
      GetIt.I<StreakService>().getCurrentStreaksByUserId(member.id).then((result) => setState(() {
          _friendIdStreakMap.putIfAbsent(member.id, () => result);
          sortFriendsByCurrentStreak();
        }));
    }
  }

  void sortFriendsByCurrentStreak() {
    _orderedFriendEntries = _friendIdStreakMap.entries.toList();
    _orderedFriendEntries.sort((a, b) => b.value.compareTo(a.value));
  }

  Member _getMemberById(String id) {
    return _friends.firstWhere((f) => f.id == id);
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
        title: const Text("Leaderboard"),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => LeaderboardComponent(
          member: _getMemberById(_orderedFriendEntries[index].key), 
          currentStreak: _orderedFriendEntries[index].value,
          position: index + 1,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 10,),
        itemCount: _orderedFriendEntries.length),
    );
  }
}