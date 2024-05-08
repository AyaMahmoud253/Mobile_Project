import 'package:assignment/models/restaurant.dart';
import 'package:assignment/screens/restaurant_products_screen.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the restaurant's products screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantProductsPage(restaurant: restaurant),
          ),
        );
      },
      child: Card(
        color: Color.fromARGB(255, 205, 221, 235),
        shadowColor: Colors.grey,
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                restaurant.address,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
