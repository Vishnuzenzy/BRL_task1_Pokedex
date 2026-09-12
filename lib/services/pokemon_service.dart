import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonService {
  String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemonList({int limit = 50}) async {
    final url = Uri.parse('$baseUrl/Pokemon?limit= $limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      List results = data['results'];

      return results.map((item) => Pokemon.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Pokemon List');
    }
  }
}
