import '../models/pokemon.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemonList({int limit = 400}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pokemon?limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        return results.map((item) => Pokemon.fromJson(item)).toList();
      } else {
        throw Exception('Server ERROR : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('NO Internet Connection : $e');
    }
  }

  Future<Pokemon> fetchPokemonDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final typeList = (data['types'] as List)
            .map((t) => t['type']['name'].toString())
            .toList();

        return Pokemon(
          id: data['id'],
          name: data['name'],
          image:
              data['sprites']['other']['official-artwork']['front_default'] ??
              '',
          types: typeList,
          height: data['height'],
          weight: data['weight'],
        );
      } else {
        throw Exception('Failed to load details');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
