class Task {
  final int id;
  final String titulo;
  final String descripcion;
  final bool completada;

  Task({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.completada,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        titulo: json['titulo'],
        descripcion: json['descripcion'],
        completada: json['completada'],
      );

  Map<String, dynamic> toJson() => {
    if (id != 0) 'id': id, // excluye id cuando sea creación
    'titulo': titulo,
    'descripcion': descripcion,
    'completada': completada,
  };
}