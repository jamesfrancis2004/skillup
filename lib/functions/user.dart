import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String id;
  String name;
  String email;
  List<dynamic> friends;

  // Constructor
  CurrentUser._({
    required this.id,
    this.name = '',
    this.email = '',
    this.friends = const [],
  });

  static Future<CurrentUser> create(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (doc.exists) {
      final data = doc.data()!;
      return CurrentUser._(
        id: id,
        name: data['name'],
        email: data['email'],
        friends: data['friends'],
      );
    } else {
      throw Exception('User not found!');
    }
  }

  Future<void> addFriends(String newFriendId) async {
    String currentUser = "9iCkGILei2p4sG17tZ7o";

    final DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser);

    DocumentSnapshot userDoc = await userDocRef.get();

    if (userDoc.exists) {
      List<String> friendIds = List<String>.from(userDoc['friendIds'] ?? []);

      if (!friendIds.contains(newFriendId)) {
        // Add the new friend's ID to the list
        friendIds.add(newFriendId);

        // Update the user's document with the new friend list
        await userDocRef.update({
          'friendIds': friendIds,
        });

        print('Friend added successfully!');
      } else {
        print('This user is already your friend.');
      }
    } else {
      print('User document does not exist.');
    }
  }
}
