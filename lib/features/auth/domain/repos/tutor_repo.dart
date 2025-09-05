abstract class TutorRepo {
  Future<void> updateUser(Map<String, dynamic> fields); //to update time_in and time_out
  Future<void> setSchedule(Map<String, dynamic> fields, String tutorId); //to update time_in and time_out
}