abstract class IUserDataStore {
  Map<String, dynamic> get user;
  set user(Map<String, dynamic> val);

  String get userType;
  set userType(String val);
}
