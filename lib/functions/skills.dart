import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CurrentSkill {
  String category;
  String challenge1;
  String challenge2;
  String challenge3;
  String description;
  String imageUrl;

  // Private constructor
  CurrentSkill._({
    this.category = '',
    this.challenge1 = '',
    this.challenge2 = '',
    this.challenge3 = '',
    this.description = '',
    this.imageUrl = '',
  });

// Create function to find the skill by date
  static Future<CurrentSkill> create() async {
    // Query the Firestore collection to find a document where 'date' is equal to 1
    final querySnapshot = await FirebaseFirestore.instance
        .collection('skills') // Assuming your collection is named 'skills'
        .where('selected',
            isEqualTo:
                1) // Assuming 'date' is the field storing the integer value
        .limit(1) // Get only the first matching document
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      return CurrentSkill._(
        category: data['category'] ?? '',
        challenge1: data['challenge1'] ?? '',
        challenge2: data['challenge2'] ?? '',
        challenge3: data['challenge3'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
      );
    } else {
      throw Exception('Skill not found with date set to 1!');
    }
  }

  static Future<void> updateSkill() async {
    final skills = FirebaseFirestore.instance.collection('skills');

    final zeroSnapshot = await skills.where('selected', isEqualTo: 0).get();
    final zeroSelectedDocs = zeroSnapshot.docs;
    final oneSnapshot = await skills.where('selected', isEqualTo: 1).get();
    final oneSnapshotDocs = oneSnapshot.docs;

    if (zeroSelectedDocs.isEmpty || oneSnapshotDocs.isEmpty) {
      return;
    }

    final randomDoc =
        zeroSelectedDocs[Random().nextInt(zeroSelectedDocs.length)];
    await skills.doc(randomDoc.id).update({'selected': 1});
    await skills.doc(oneSnapshotDocs[0].id).update({'selected': 0});

    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    for (var doc in usersSnapshot.docs) {
      final data = doc.data();
      final challengesCompleted = data['challengesCompleted'];
      if (challengesCompleted[0]) {
        int medalCount = data['bronze'];
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .update({'bronze': medalCount + 1});
      }
      if (challengesCompleted[1]) {
        int medalCount = data['silver'];
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .update({'silver': medalCount + 1});
      }
      if (challengesCompleted[2]) {
        int medalCount = data['gold'];
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .update({'gold': medalCount + 1});
      }
      await FirebaseFirestore.instance.collection('users').doc(doc.id).update({
        'challengesCompleted': [false, false, false],
      });
    }
  }
}
