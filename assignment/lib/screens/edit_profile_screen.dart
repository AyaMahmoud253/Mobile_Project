import 'package:assignment/widgets/buttomNavigationBar.dart';
import 'package:assignment/widgets/custom_text_field.dart';
import 'package:assignment/widgets/custum_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfilePage> {
  late Future<Map<String, dynamic>> _userDataFuture;


  TextEditingController nameController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController idController = TextEditingController();

  TextEditingController levelController = TextEditingController();

   @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    _userDataFuture = fetchUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyNavigationBar(),
      appBar: AppBar(
        title: Text('Edit your profile',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // User data is available
            Map<String, dynamic> userData = snapshot.data!;
            return ListView(
          children: [
            SizedBox(height: 15,),
          CustomTextField(obsText: false,
          controllerText: nameController,
          hint: 'Update your name',
          icon: Icon(Icons.person),
          label:userData['name']),
          SizedBox(height: 10,),
          CustomTextField(obsText: false,
          controllerText: genderController,
          hint: 'Update your Gender',
          label: userData['gender'],
          icon: Icon(Icons.text_fields),),
          SizedBox(height: 10,),
          CustomTextField(obsText: false,
          controllerText: emailController,
          hint: 'Update your email',
          label: userData['email'],
          icon: Icon(Icons.email),),
          SizedBox(height: 10,),
          /*CustomTextField(obsText: false,
          //controllerText: idController,
          hint: 'i.e, 20200001',
          icon: Icon(Icons.perm_identity),
          label: 'ID',),*/
          SizedBox(height: 10,),
          CustomTextField(obsText: false,
          controllerText: levelController,
          hint: 'Update your level',
          label: userData['level'],
          icon: Icon(Icons.numbers),),
          SizedBox(height: 10,),
          CustomButton(text: 'Save Changes',
          onPressed: (){
            updateUserInformation(
                      nameController.text,
                      genderController.text,
                      emailController.text,
                      levelController.text,
                    );
          },),
          SizedBox(height: 10,),
          CustomButton(text: 'My Profile',
          onPressed: (){
            Navigator.pushNamed(context, 'ProfilePage');
          },)
          ],);
      } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
 
  }

  Future<void> updateUserInformation(
  String name,
  String gender,
  String email,
  String level,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userEmail = prefs.getString('email');

  try {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

     /*final body = json.encode({
      'name': name,
      'gender': gender,
      'email': email,
      'level': level,
    });*/

    final responseName = await http.put(
      Uri.parse('http://10.0.2.2:5266/api/User/UpdateName/$userEmail'),
      headers: headers,
      body: jsonEncode(name),
    );

    final responseGender = await http.put(
      Uri.parse('http://10.0.2.2:5266/api/User/UpdateGender/$userEmail'),
      headers: headers,
      body: jsonEncode(gender),
    );

    final responseLevel = await http.put(
      Uri.parse('http://10.0.2.2:5266/api/User/UpdateLevel/$userEmail'),
      headers: headers,
      body: jsonEncode(level),
    );

    print(responseName.body);
    print(responseName.statusCode);

    print(responseGender.body);
    print(responseGender.statusCode);

print(responseLevel.body);
    print(responseLevel.statusCode);

    if (responseName.statusCode == 200 &&
        responseGender.statusCode == 200 &&
        responseLevel.statusCode == 200) {
      // Handle success scenario
      // Show success message or navigate back
    } else {
      // Handle error scenario
      // Show error message
    }
  } catch (error) {
    print('Error updating user information: $error');
    // Handle error scenario
    // Show error message
  }
}




Future<Map<String, dynamic>> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userEmail = prefs.getString('email');

  if (userEmail != null) {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5266/api/User/ByEmail/$userEmail'),
    );

    print(response.body);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load user data');
    }
  } else {
    // If userEmail is null, throw an exception
    throw Exception('User email not found in SharedPreferences');
  }
}

/*Future<void> _updateUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userEmail = prefs.getString('email');
    // This map will be populated with the current state of your form.
    final Map<String, dynamic> updatedData = {
      'name': nameController.text,
     // Assuming you have a controller for this
      'gender': genderController.text,
      'email': addressController.text,
      'level'
    };

    try {
      final response = await http.put(
        Uri.parse(
            'https://jobcareer.azurewebsites.net/api/UserProfile/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print('User profile updated successfully.');
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(
            'Failed to update user profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // If we encountered an error, handle it.
      print('Error updating user profile: $e');
    }
  }*/