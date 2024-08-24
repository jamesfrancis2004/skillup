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
}
