import 'package:assignment/widgets/buttomNavigationBar.dart';
import 'package:assignment/widgets/custom_view_card.dart';
import 'package:assignment/widgets/custum_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:assignment/models/user.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _userDataFuture;
  late Future<String?> _profilePictureFuture;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    _userDataFuture = fetchUserData();
    _profilePictureFuture = _fetchProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<User>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // User data is available
            User user = snapshot.data!;
            return ListView(
              children: [
                SizedBox(height: 30),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      FutureBuilder(
                        future: _fetchProfilePicture(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            String? profilePictureUrl = snapshot.data;
                            return CircleAvatar(
                              backgroundImage: profilePictureUrl != null
                                  ? NetworkImage(profilePictureUrl)
                                  : null,
                              radius: 90,
                              child: profilePictureUrl == null
                                  ? Center(child: Icon(Icons.person))
                                  : null,
                            );
                          } else {
                            return CircleAvatar(
                              radius: 90,
                              child: Icon(Icons.person),
                            );
                          }
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              _showImagePickerDialog();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                CustomCard(
                  title: 'Name',
                  subTitle: user.name,
                ),
                SizedBox(height: 5),
                CustomCard(
                  title: 'Gender',
                  subTitle: user.gender,
                ),
                SizedBox(height: 5),
                CustomCard(
                  title: 'Email',
                  subTitle: user.email,
                ),
                SizedBox(height: 5),
                CustomCard(
                  title: 'Level',
                  subTitle: user.level,
                ),
                SizedBox(height: 15),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Edit Profile',
                  onPressed: () {
                    Navigator.pushNamed(context, 'EditProfilePage');
                  },
                )
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: MyNavigationBar(),
    );
  }

  Future<User> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('email');
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:5266/api/User/ByEmail/$userEmail'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> userData = jsonDecode(response.body);
      return User(
        id: userData['id'],
        name: userData['name'],
        gender: userData['gender'],
        email: userData['email'],
        level: userData['level'],
      );
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _showImagePickerDialog() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Upload the selected image to the server
      _uploadProfilePicture(pickedFile);
    }
  }

  Future<void> _uploadProfilePicture(XFile pickedFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userEmail = prefs.getString('email');

    try {
      final Uri uploadUrl = Uri.parse(
          'http://10.0.2.2:5266/api/UserProfile/upload-profile-picture?email=$userEmail');

      var request = http.MultipartRequest('POST', uploadUrl);
      request.files.add(await http.MultipartFile.fromPath(
          'profilePicture', pickedFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        print(response.statusCode);
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      print('Error uploading profile picture: $error');
    }
  }

  Future<String?> _fetchProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userEmail = prefs.getString('email');

    try {
      final Uri fetchUrl = Uri.parse(
          'http://10.0.2.2:5266/api/UserProfile/profile-picture?email=$userEmail');

      var response = await http.get(fetchUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String? profilePictureUrl = responseData['profilePictureUrl'];
        return profilePictureUrl;
      } else {
        print('Failed to fetch profile picture: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching profile picture: $error');
      return null;
    }
  }
}
