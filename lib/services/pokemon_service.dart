import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemonList({int limit = 50}) async {
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
}
