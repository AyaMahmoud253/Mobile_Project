import 'package:rxdart/rxdart.dart';
import 'package:assignment/models/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc {
  late BehaviorSubject<User> _userSubject;
  late User _user;
  final Dio _dio = Dio();
  static const String _register_url = 'http://10.0.2.2:5266/api/Auth/signup';
  static const String _login_url = 'http://10.0.2.2:5266/api/Auth/login';

  UserBloc() {
    _user = User();
    _userSubject = BehaviorSubject<User>.seeded(_user);
  }

  Stream<User> get userStream => _userSubject.stream;

  void updateUserData(User user) {
    _user = user;
    _userSubject.add(_user);
  }

  Future<void> registerUser() async {
    try {
      final response = await _dio.post(
        _register_url,
        data: _user.toJson(),
      );
      print(response.statusCode);
      print(response.data);
      print('rrrrrrrrrrr');
      if (response.statusCode == 200) {
        //final id = response.data['id'];
        //final token = response.data['token'];
        final email = response.data['email'];

        // Saving id, token, and email to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        //await prefs.setString('id', id);
        //await prefs.setString('token', token);
        await prefs.setString('email', email);
        //print(id);
        print('email: ${email}');
        //print('token: {$token}');

        // Notify listeners that registration was successful
        _userSubject.add(_user);
      } else {
        // Handle registration failure
        throw Exception('Registration failed');
      }
    } catch (error) {
      // Handle errors
      throw error;
    }
  }

  Future<void> loginUser(User user) async {
    try {
      final response = await _dio.post(
        _login_url,
        data: user.toJson(),
      );
      print(response.data);
      print(response.statusCode);
      print('hhhhhhhhhh');

      if (response.statusCode == 200) {
        final String email = response.data['email'];
        // Store the token locally using shared_preferences or flutter_secure_storage
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);

        // Notify listeners that login was successful
        _userSubject.add(user);
      } else {
        // Handle unsuccessful login
        throw Exception('Login failed');
      }
    } catch (error) {
      // Handle errors
      throw error;
    }
  }

  void dispose() {
    _userSubject.close();
  }
}
