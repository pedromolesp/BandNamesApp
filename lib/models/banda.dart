class Banda {
  late String id;
  late String nombre;
  late int votes;
  Banda({required this.id, required this.nombre, required this.votes});

  factory Banda.fromMap(Map<String, dynamic> obj) =>
      Banda(id: obj['id'], nombre: obj['nombre'], votes: obj['votes']);
}
