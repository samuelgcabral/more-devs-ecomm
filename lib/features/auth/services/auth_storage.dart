import 'dart:convert';

import 'package:more_devs_do_zero/features/auth/models/registered_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthStorage {
  Future<List<RegisteredUser>> readUsers();
  Future<void> saveUsers(List<RegisteredUser> users);
}

class SharedPreferencesAuthStorage implements AuthStorage {
  static const String _usersKey = 'registered_users';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<List<RegisteredUser>> readUsers() async {
    final storedUsers = await _preferences.getString(_usersKey);
    if (storedUsers == null) return [];

    final decodedUsers = jsonDecode(storedUsers) as List<dynamic>;
    return decodedUsers
        .map((user) => RegisteredUser.fromJson(user as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveUsers(List<RegisteredUser> users) async {
    final encodedUsers = jsonEncode(
      users.map((user) => user.toJson()).toList(),
    );
    await _preferences.setString(_usersKey, encodedUsers);
  }
}
