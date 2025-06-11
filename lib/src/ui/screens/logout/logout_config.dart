import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'jwtToken';

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  Future<void> setToken(String tokenValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, tokenValue);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
  }

  Future<bool> isTokenExpired() async {
    String token = await getToken();
    return JwtDecoder.isExpired(token);
  }
}
