import 'package:flutter/material.dart';
import 'package:pawfect_bites/sqldb.dart';

class FoodSearchDelegate extends SearchDelegate<DBanimals> {
  final List<DBanimals> animals;

  FoodSearchDelegate(this.animals);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context,
            animals.first); // Return any item when closing without selection
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter animals based on search query
    final results = animals
        .where((animal) =>
            animal.foodName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text('No food found for "$query"'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final animal = results[index];
        return ListTile(
          title: Text(animal.foodName),
          subtitle: Text('Toxicity: ${animal.toxicityLevel}'),
          onTap: () {
            close(context, animal);
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(255, 212, 197, 1),
        foregroundColor: Colors.black,
        elevation: 4.0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as user types
    if (query.isEmpty) {
      return const Center(
        child: Text('Search for foods'),
      );
    }

    final suggestions = animals
        .where((animal) =>
            animal.foodName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final animal = suggestions[index];
        return ListTile(
          title: Text(animal.foodName),
          subtitle: Text('Toxicity: ${animal.toxicityLevel}'),
          onTap: () {
            query = animal.foodName;
            showResults(context);
            close(context, animal);
          },
        );
      },
    );
  }
}

class SearchPageResults extends StatelessWidget {
  const SearchPageResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
