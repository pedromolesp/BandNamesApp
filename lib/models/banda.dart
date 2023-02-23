class Banda {
  late String id;
  late String name;
  late int vote;
  Banda({required this.id, required this.name, required this.vote});

  factory Banda.fromMap(Map<String, dynamic> obj) => Banda(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-nombre',
      vote: obj.containsKey('vote') ? obj['vote'] : 'no-votes');
}
