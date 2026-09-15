import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailsScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  final PokemonService _pokemonService = PokemonService();
  late Future<Pokemon> _detailsFuture;

  @override
  void initState() {
    super.initState();
    // Screen open hote hi is specific Pokemon ki details fetch hongi
    _detailsFuture = _pokemonService.fetchPokemonDetails(widget.pokemon.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          widget.pokemon.name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Part: Pokemon Big Image
          const SizedBox(height: 10),
          Hero(
            tag: widget.pokemon.id,
            child: CachedNetworkImage(
              imageUrl: widget.pokemon.image,
              height: 180,
              width: 180,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.catching_pokemon,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Bottom Sheet: White rounded card with info
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: FutureBuilder<Pokemon>(
                future: _detailsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading details: ${snapshot.error}'),
                    );
                  }

                  final detailedPokemon = snapshot.data ?? widget.pokemon;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Pokemon ID
                      Text(
                        '#${detailedPokemon.id.toString().padLeft(3, '0')}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Types badges (e.g. Grass, Poison)
                      Wrap(
                        spacing: 8,
                        children: detailedPokemon.types.map((type) {
                          return Chip(
                            backgroundColor: Colors.redAccent[80],
                            label: Text(
                              type.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Height and Weight Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard('Height', '${detailedPokemon.height / 10} m'),
                          _buildStatCard('Weight', '${detailedPokemon.weight / 10} kg'),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Chhota helper widget stats clean dikhane ke liye
  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }
}