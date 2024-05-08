import 'package:assignment/screens/map_view_screen.dart';
import 'package:assignment/widgets/buttomNavigationBar.dart';
import 'package:assignment/widgets/custum_button.dart';
import 'package:flutter/material.dart';
import 'package:assignment/models/restaurant.dart';
import 'package:assignment/bloc/restaurant_bloc.dart'; // Import your RestaurantBloc
import 'package:assignment/widgets/custom_restaurant_card.dart';
import 'package:assignment/widgets/custom_text_field.dart';
import 'package:rxdart/rxdart.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final BehaviorSubject<List<Restaurant>> _restaurantsSubject = BehaviorSubject<List<Restaurant>>();
  late RestaurantBloc _restaurantBloc; // Change to RestaurantBloc

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restaurantBloc = RestaurantBloc.of(context); // Get RestaurantBloc from context
  }

  @override
  void dispose() {
    _restaurantsSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyNavigationBar(),
      appBar: AppBar(
        title: Text(
          'Search by Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 15),
          CustomTextField(
            obsText: false,
            label: 'Search product',
            controllerText: _searchController,
            hint: 'Search for a product',
            icon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                final product = _searchController.text;
                if (product.isNotEmpty) {
                  _fetchRestaurants(product);
                }
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: StreamBuilder<List<Restaurant>>(
              stream: _restaurantsSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No restaurants available for the selected product'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final restaurant = snapshot.data![index];
                      return RestaurantCard(restaurant: restaurant);
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 15),
          CustomButton(
  text: 'Show on map',
  onPressed: () {
    print("Number of restaurants: ${_restaurantsSubject.value?.length}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapViewPage(
                restaurants: _restaurantsSubject.value ?? [],
              ),
            ),
          );
  },
)
        ],
      ),
    );
  }

  void _fetchRestaurants(String product) {
    _restaurantBloc.fetchRestaurantsByProduct(product).then((restaurants) { // Use RestaurantBloc method
      _restaurantsSubject.add(restaurants);
    }).catchError((error) {
      _restaurantsSubject.addError(error);
    });
  }
}
