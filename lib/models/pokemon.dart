class Pokemon {
  final int id;
  final String name;
  final String image;
  final List<String> types;
  final int height;
  final int weight;


Pokemon({
  required this.id,
  required this.name,
  required this.image,
  this.types = const [],
  this.height = 0,
  this.weight = 0,
});

factory Pokemon.fromJson(Map<String, dynamic> json) {
  
    final url = json['url'] as String;
    final segments = url.trim().split('/');
    final id = int.parse(segments[segments.length - 2]);
    
  return Pokemon(
    id : id, 
    name : json['name'],
    image : 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
  );
}
}