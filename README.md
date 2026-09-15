# ⚡ Pokédex App (Flutter)

A high-performance, visually polished Pokédex mobile application built with Flutter and Dart. The app consumes the public [PokéAPI](https://pokeapi.co/) to showcase over 400 Pokémon with real-time name searching, shared-element Hero transitions, dynamic type-based adaptive theming, and detailed base stat visualizations.

---

## 📱 Features

- **Dynamic Type-Based Theming**: The detail screen background and type chips dynamically adapt their color palette based on the primary Pokémon type (e.g., Fire $\rightarrow$ Orange, Water $\rightarrow$ Blue, Psychic $\rightarrow$ Purple).
- **Smooth Shared Element Transitions**: Fluid `Hero` animations connecting thumbnail sprites on the home grid to the high-res official artwork on the detail view.
- **Instant Search Filtering**: Real-time name search filtering powered by `TextEditingController` with one-tap clear functionality.
- **Rich Metric Conversions & Base Stats**: Custom visual stat bars displaying HP, Attack, Defense, Special Attack, Special Defense, and Speed with normalized progress scaling and clean metric conversions (decimeters $\rightarrow$ meters, hectograms $\rightarrow$ kilograms).
- **Engineered Memory Optimization**: Utilizes `cached_network_image` configured with constrained `memCacheHeight` and `memCacheWidth` to ensure zero memory thrashing and buttery smooth 60fps scrolling across 400+ entries.
- **Defensive Error Handling**: Full network failure handling, custom loaders, and graceful error fallbacks for offline or flaky connection states.

---

## 📸 Screenshots

| Home Grid & Search | Details & Base Stats (Psychic) | Details & Adaptive Theming (Fire) |
| :---: | :---: | :---: |
| https://github.com/user-attachments/assets/21b2f573-7f5b-4840-9216-9b68e642acd8 | https://github.com/user-attachments/assets/fbb4399a-b81e-4927-b431-af6384d62c51 | https://github.com/user-attachments/assets/50c1d6aa-b5ea-45d1-a4f5-e1481f5b0f9d |

---

## 🏗️ Architecture & Project Structure

The project follows a clean, decoupled **Model-Service-UI** pattern to maintain high readability, maintainability, and testability:

```text
lib/
├── models/
│   └── pokemon.dart             # Unified data model with JSON serialization & default stat fallbacks
├── services/
│   └── pokemon_service.dart     # HTTP client layer communicating with PokéAPI v2
├── screens/
│   ├── pokemon_list_screen.dart # Home view featuring search bar and 2-column responsive GridView
│   └── pokemon_details_screen.dart # Detail view with dynamic theming, metrics, and base stat bars
├── widgets/
│   └── pokemon_card.dart        # Reusable card widget with InkWell ripple effect and Hero sprite
└── main.dart                    # Application entry point