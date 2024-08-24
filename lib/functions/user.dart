import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final List<dynamic> friends;

  // Constructor
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.friends,
  });

  // Factory constructor to create a User object from a Firestore document
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name:
          data['name'] ?? '', // Default to an empty string if the name is null
      email: data['email'] ??
          '', // Default to an empty string if the email is null
      friends: data['friends'] ?? [],
    );
  }

  // Method to convert a User object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
    };
  }

  Future<User?> getUser(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return User.fromFirestore(doc.data()!, doc.id);
    } else {
      return null; // Handle the case where the document doesn't exist
    }
  }
}
