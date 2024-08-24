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

  Future<bool> sendFriendRequest(String newFriendId) async {
    final friendDocRef =
        FirebaseFirestore.instance.collection('users').doc(newFriendId);
    final friendDoc = await friendDocRef.get();
    if (!friendDoc.exists) {
      return false;
    }

    await friendDocRef.update({
      'inbound_requests': FieldValue.arrayUnion([id])
    });

    return true;
  }

  Future<bool> acceptFriendRequest(String acceptedFriendId) async {
    final friendDocRef =
        FirebaseFirestore.instance.collection('users').doc(acceptedFriendId);
    final friendDoc = await friendDocRef.get();
    if (!friendDoc.exists) {
      return false;
    }

    await friendDocRef.update({
      'outbound_requests': FieldValue.arrayRemove([id])
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(acceptedFriendId)
        .update({
      'inbound_requests': FieldValue.arrayRemove([acceptedFriendId])
    });
    return true;
  }

  Future<void> addFriends(String newFriendId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (doc.exists) {
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
