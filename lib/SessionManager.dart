import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyEmail = 'email';
  static const String _keyType = 'type';
  static const String _keyUid = 'uid';

  static Future<void> saveSession(String email, String type, int uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyType, type);
    await prefs.setInt(_keyUid, uid);
    print('Session saved: email=$email, type=$type, uid=$uid');
  }

  static Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEmail);
    final type = prefs.getString(_keyType);
    final uid = prefs.getInt(_keyUid);

    if (email == null || type == null || uid == null) {
      return null;
    }

    return {
      'email': email,
      'type': type,
      'uid': uid,
    };
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyType);
  }

  static Future<int?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUid);
  }

  static Future<bool> isLoggedIn() async {
    final session = await getSession();
    return session != null;
  }

  static Future<bool> isAdmin() async {
    final type = await getType();
    return type == 'admin';
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyType);
    await prefs.remove(_keyUid);
    print('Session cleared');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All preferences cleared');
  }
}
