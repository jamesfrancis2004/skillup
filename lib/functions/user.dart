import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String id;
  String name;
  String email;
  List<dynamic> friends;
  List<dynamic> inboundRequests;
  List<dynamic> outboundRequests;

  // Constructor
  CurrentUser._({
    required this.id,
    this.name = '',
    this.email = '',
    this.friends = const [],
    this.inboundRequests = const [],
    this.outboundRequests = const [],
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
        inboundRequests: data['inboundRequests'],
        outboundRequests: data['outboundRequests'],
      );
    } else {
      throw Exception('User not found!');
    }
  }

  static Future<bool> getNameFromId(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!doc.exists) {
      return false;
    }

    return doc.data()!['name'];
  }

  Future<bool> updateName(String newName) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(id);
    final doc = await docRef.get();

    if (!doc.exists) {
      return false;
    }

    docRef.update({'name': newName});

    return true;
  }

  Future<bool> rejectFriendRequest(String friendId) async {
    final friendDocRef =
        FirebaseFirestore.instance.collection('users').doc(friendId);
    final friendDoc = await friendDocRef.get();
    if (!friendDoc.exists) {
      return false;
    }

    await friendDocRef.update({
      'outboundRequests': FieldValue.arrayRemove([id])
    });
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'inboundRequests': FieldValue.arrayRemove([friendId])
    });
    inboundRequests.remove(friendId);
    return true;
  }

  Future<bool> cancelFriendRequest(String friendId) async {
    final friendDocRef =
        FirebaseFirestore.instance.collection('users').doc(friendId);
    final friendDoc = await friendDocRef.get();
    if (!friendDoc.exists) {
      return false;
    }

    await friendDocRef.update({
      'inboundRequests': FieldValue.arrayRemove([id])
    });
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'outboundRequests': FieldValue.arrayRemove([friendId])
    });
    outboundRequests.remove(friendId);
    return true;
  }

  Future<bool> sendFriendRequest(String friendId) async {
    if (friendId == id) {
      return false;
    }

    final friendDocRef =
        FirebaseFirestore.instance.collection('users').doc(friendId);
    final friendDoc = await friendDocRef.get();
    if (!friendDoc.exists) {
      return false;
    }

    await friendDocRef.update({
      'inboundRequests': FieldValue.arrayUnion([id])
    });
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'outboundRequests': FieldValue.arrayUnion([friendId])
    });
    outboundRequests.add(friendId);

    return true;
  }

  Future<bool> acceptFriendRequest(String friendId) async {
    final friendDocRef =
        FirebaseFirestore.instance.collection('users').doc(friendId);
    final friendDoc = await friendDocRef.get();
    if (!friendDoc.exists) {
      return false;
    }

    await friendDocRef.update({
      'outboundRequests': FieldValue.arrayRemove([id])
    });
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'inboundRequests': FieldValue.arrayRemove([friendId])
    });
    inboundRequests.remove(friendId);

    return true;
  }

  Future<void> addFriends(String newFriendId) async {
    final docRef =
        FirebaseFirestore.instance.collection('users').doc(id);

    final doc = await docRef.get();
    if (doc.exists) {
      List<String> friendIds = List<String>.from(doc['friendIds'] ?? []);

      if (!friendIds.contains(newFriendId)) {
        // Add the new friend's ID to the list
        friendIds.add(newFriendId);

        // Update the user's document with the new friend list
        await docRef.update({
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

  Future<void> deleteUserFromFirestore() async {
    try {
      // Reference to the user's document in Firestore
      final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(id);

      // Delete the user's document
      await userDocRef.delete();

      print('User document with ID $id deleted successfully from Firestore.');
    } catch (e) {
      print('Failed to delete user document: $e');
    }
  }

  // Method to remove the user from all friends lists
// Method to remove the user from all friends lists
  Future<void> removeUserFromAllFriendsLists() async {
    try {
      final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

      // Query all user documents where 'friends' contains this user's UID
      QuerySnapshot querySnapshot = await usersRef.where('friends', arrayContains: id).get();

      // Iterate over all documents that contain this user's UID in their 'friends' list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        List<String> friends = List<String>.from(doc['friends']);
        friends.remove(id);

        // Update the document with the new friends list
        await doc.reference.update({
          'friends': friends,
        });
      }

      print('User with ID $id removed from all friends lists successfully!');
    } catch (e) {
      print('Failed to remove user from friends lists: $e');
    }
  }
}
