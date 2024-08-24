import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String id;
  String name;
  String email;
  List<dynamic> friends;
  List<dynamic> inboundRequests;
  List<dynamic> outboundRequests;
  List<dynamic> challengesCompleted;

  // Constructor
  CurrentUser._({
    required this.id,
    this.name = '',
    this.email = '',
    this.friends = const [],
    this.inboundRequests = const [],
    this.outboundRequests = const [],
    this.challengesCompleted = const [false, false, false],
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
        challengesCompleted: data['challengesCompleted'],
      );
    } else {
      throw Exception('User not found!');
    }
  }

  static Future<String?> getNameFromId(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!doc.exists) {
      return null;
    }

    return doc.data()!['name'];
  }

  static Future<String?> getIdFromName(String name) async {
    final users = FirebaseFirestore.instance.collection('users');
    final snapshot = await users.get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final String tempName = data['name'];
      if (name == tempName) {
        return doc.id;
      }
    }
    return null;
  }

  Future<bool> toggleChallengeComplete(int challengeNumber) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(id);
    final doc = await docRef.get();

    if (!doc.exists) {
      return false;
    }

    challengesCompleted[challengeNumber] =
        !challengesCompleted[challengeNumber];
    docRef.update({'challengesCompleted': challengesCompleted});

    return true;
  }

  Future<bool> updateName(String newName) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(id);
    final doc = await docRef.get();

    if (!doc.exists) {
      return false;
    }

    docRef.update({'name': newName});
    name = newName;

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

  Future<bool> sendFriendRequest(String friendName) async {
    if (friendName == name) {
      return false;
    }

    final friendId = await getIdFromName(friendName);
    if (friendId == null) {
      return false;
    }

    final friendDocRef =
        FirebaseFirestore.instance.collection('users').doc(friendId);
    final friendDoc = await friendDocRef.get();
    if (!friendDoc.exists) {
      return false;
    }
    if (friendDoc['outboundRequests'].includes(friendId)) {
      final status = await acceptFriendRequest(friendId);
      return status;
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
      'outboundRequests': FieldValue.arrayRemove([id]),
      'friends': FieldValue.arrayUnion([id])
    });
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'inboundRequests': FieldValue.arrayRemove([friendId]),
      'friends': FieldValue.arrayUnion([friendId])
    });
    inboundRequests.remove(friendId);
    
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'friends': FieldValue.arrayUnion([friendId])
    });
    friends.add(friendId);

    await FirebaseFirestore.instance.collection('users').doc(friendId).update({
      'friends': FieldValue.arrayUnion([id])
    });

    return true;
  }

  Future<void> deleteUserFromFirestore() async {
    try {
      // Reference to the user's document in Firestore
      final DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(id);

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
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      // Query all user documents where 'friends' contains this user's UID
      QuerySnapshot querySnapshot =
          await usersRef.where('friends', arrayContains: id).get();

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
