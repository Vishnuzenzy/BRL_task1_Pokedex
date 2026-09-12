class Pokemon {
  final int id;
  final String name;
  final String image;


Pokemon({
  required this.id,
  required this.name,
  required this.image,
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