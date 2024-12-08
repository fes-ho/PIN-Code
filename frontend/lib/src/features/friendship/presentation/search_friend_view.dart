import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/features/friendship/application/friendship_service.dart';
import 'package:frontend/src/features/friendship/presentation/add_friend_component.dart';
import 'package:frontend/src/features/friendship/presentation/friend_component.dart';
import 'package:get_it/get_it.dart';

class SearchFriendView extends StatefulWidget {
  const SearchFriendView({super.key});

  static const routeName = "/splashLoading";

  @override
  State<SearchFriendView> createState() => _SearchFriendViewState();
}

class _SearchFriendViewState extends State<SearchFriendView> {
  List<Member> _members = [];

  void _updateMembers(List<Member> members) {
    setState(() {
      _members = members;
    });
  }

  Widget _renderMember(Member member) {
    if (GetIt.I<FriendshipService>().isMemberFriend(member)) {
      return Friend(
        member: member,
        updateFriendsState: ( )=> setState(() {
          
        })
      );
    }

    return AddFriend(
      member: member,
      updateState: () => setState(() {
        
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(
              onChanged: (value) {
                GetIt.I<FriendshipService>()
                  .getMembersByName(value)
                  .then((m) => _updateMembers(m));
              },
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => _renderMember(_members[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 10,),
              itemCount: _members.length
            )
          ],
        ),
      ),
    );
  }
}