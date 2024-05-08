import 'package:assignment/screens/distance_screen.dart';
import 'package:assignment/screens/edit_profile_screen.dart';
import 'package:assignment/screens/profile_screen.dart';
import 'package:assignment/screens/restaurants_screen.dart';
import 'package:assignment/screens/search_screen.dart';
import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        //backgroundColor: Color.fromARGB(255, 1, 31, 56),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'ProfilePage');
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ),
                );
              },
              icon: Icon(Icons.edit, color: Colors.white),
            ),
            label: 'edit profile',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Builder(
                      builder: (context) {
                        return AllRestaurantsPage(); // Use Builder to access the provider
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.restaurant, color: Colors.white),
            ),
            label: 'Restaurants',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Builder(
            builder: (context) {
              return SearchPage(); // Use Builder to access the provider
            },
          ),
        ),
      );
              },
              icon: Icon(Icons.search, color: Colors.white),
            ),
            label: 'Search',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Builder(
            builder: (context) {
              return CalculateDistancePage(); // Use Builder to access the provider
            },
          ),
        ),
      );
              },
              icon: Icon(Icons.location_on, color: Colors.white),
            ),
            label: 'Distance',
            backgroundColor: Colors.blue,
          ),
        ]);
  }
}
