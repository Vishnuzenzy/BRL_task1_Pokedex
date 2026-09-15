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
    _detailsFuture = _pokemonService.fetchPokemonDetails(widget.pokemon.id);
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokemon>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        // Agar data aa gaya toh snapshot.data, warna basic pokemon data use karenge
        final detailedPokemon = snapshot.data ?? widget.pokemon;

        // Pehla type nikal rahe hain (e.g. 'fire', 'psychic')
        final primaryType = detailedPokemon.types.isNotEmpty
            ? detailedPokemon.types.first
            : null;

        // Dynamic theme color
        final themeColor = _getTypeColor(primaryType);

        return Scaffold(
          backgroundColor: themeColor, // <-- Dynamic Background Color
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
              // Top: Hero Animated Image
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

              // Bottom White Sheet with details
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator(color: themeColor))
                      : Column(
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

                            // Dynamic Type Chips
                            Wrap(
                              spacing: 8,
                              children: detailedPokemon.types.map((type) {
                                final chipColor = _getTypeColor(type);
                                return Chip(
                                  backgroundColor: chipColor.withOpacity(0.15),
                                  label: Text(
                                    type.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: chipColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                            // Height & Weight
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatCard('Height', '${detailedPokemon.height / 10} m'),
                                _buildStatCard('Weight', '${detailedPokemon.weight / 10} kg'),
                              ],
                            ),
                            const SizedBox(height: 20),

                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Base Stats',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Scrollable Stats Bars
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  _buildStatBar('HP', detailedPokemon.stats['hp'] ?? 0),
                                  _buildStatBar('Attack', detailedPokemon.stats['attack'] ?? 0),
                                  _buildStatBar('Defense', detailedPokemon.stats['defense'] ?? 0),
                                  _buildStatBar('Sp. Atk', detailedPokemon.stats['special-attack'] ?? 0),
                                  _buildStatBar('Sp. Def', detailedPokemon.stats['special-defense'] ?? 0),
                                  _buildStatBar('Speed', detailedPokemon.stats['speed'] ?? 0),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
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
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  // Single Stat Progress Bar Widget
  Widget _buildStatBar(String label, int value) {
    // 255 is the standard max base stat in Pokemon games
    final double progress = (value / 255.0).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),

          SizedBox(
            width: 35,
            child: Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          // Visual Progress Bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  value >= 70
                      ? Colors.green
                      : value >= 50
                      ? Colors.orange
                      : Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'fire':
        return Colors.orangeAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      case 'psychic':
        return Colors.purpleAccent;
      case 'poison':
        return Colors.deepPurpleAccent;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.indigo;
      case 'dragon':
        return Colors.deepOrange;
      case 'ice':
        return Colors.cyan;
      default:
        return Colors.redAccent; // Fallback default pokeball red
    }
  }
}
