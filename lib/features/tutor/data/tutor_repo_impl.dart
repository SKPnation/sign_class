import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/features/tutor/domain/tutor_repo.dart';

abstract class _Keys {
  static const tutors = 'tutors';
}

class TutorRepoImpl extends TutorRepo {
  final CollectionReference tutorsCollection = FirebaseFirestore.instance
      .collection('tutors');
  final CollectionReference availabilityCollection = FirebaseFirestore.instance
      .collection('tutor_availability');

  @override
  Future<void> updateUser(Map<String, dynamic> fields) async {
    final data = Map<String, dynamic>.from(fields)..remove('id');
    await tutorsCollection.doc(fields['id']).update(data);
  }

  // @override
  // Future<void> setSchedule(Map<String, dynamic> fields, String tutorId) async {
  //   final data = Map<String, dynamic>.from(fields);
  //   final docRef = availabilityCollection.doc(tutorId);
  //
  //   final docSnapshot = await docRef.get();
  //
  //   if (docSnapshot.exists) {
  //     await docRef.update(data);
  //   } else {
  //     await docRef.set(data);
  //   }
  // }

  @override
  Future getMyAvailability(String tutorId) async{
    final docRef = availabilityCollection.doc(tutorId);
    final docSnapshot = await docRef.get();
    final result = docSnapshot.data();

    if (result != null && result is Map<String, dynamic>) {
      return result;
    }
    return {};
  }


}
