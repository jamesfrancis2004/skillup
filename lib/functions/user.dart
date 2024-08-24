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

  Future<bool> sendFriendRequest(String newFriendId) async {
    final friendDocRef =
        FirebaseFirestore.instance.collection('users').doc(newFriendId);
    final friendDoc = await friendDocRef.get();
    if (!friendDoc.exists) {
      return false;
    }

    await friendDocRef.update({
      'inboundRequests': FieldValue.arrayUnion([id])
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newFriendId)
        .update({
      'outboundRequests': FieldValue.arrayUnion([newFriendId])
    });
    outboundRequests.add(newFriendId);

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
      'outboundRequests': FieldValue.arrayRemove([id])
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(acceptedFriendId)
        .update({
      'inboundRequests': FieldValue.arrayRemove([acceptedFriendId])
    });
    inboundRequests.remove(acceptedFriendId);

    return true;
  }
}
