import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentSkill {
  String title;
  String category;
  String challenge1;
  String challenge2;
  String challenge3;
  String description;
  String imageUrl;

  // Constructor
  CurrentSkill._({
    this.title = '',
    this.category = '',
    this.challenge1 = '',
    this.challenge2 = '',
    this.challenge3 = '',
    this.description = '',
    this.imageUrl = '',
  });

  // Create function to find the skill by DateTime
  static Future<CurrentSkill> create(DateTime dateTime) async {
    // Convert the DateTime object to a Firestore Timestamp
    Timestamp timestamp = Timestamp.fromDate(dateTime);

    // Query the Firestore collection to find a document matching the given Timestamp
    final querySnapshot = await FirebaseFirestore.instance
        .collection('skills') // Assuming your collection is named 'skills'
        .where('date', isEqualTo: timestamp) // Replace 'timestampField' with your actual field name
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data();

      return CurrentSkill._(
        title: data['title'] ?? '',
        category: data['category'] ?? '',
        challenge1: data['challenge1'] ?? '',
        challenge2: data['challenge2'] ?? '',
        challenge3: data['challenge3'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['image_url'] ?? '',
      );
    } else {
      throw Exception('Skill not found for the given DateTime!');
    }
  }
}
