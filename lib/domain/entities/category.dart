class Category {
  final int? id;
  final String name;
  final String description;
  final String acronym;

  Category({
    this.id,
    required this.name,
    required this.description,
    required this.acronym,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      acronym: map['acronym'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'acronym': acronym,
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? description,
    String? acronym,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      acronym: acronym ?? this.acronym,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, description: $description, acronym: $acronym}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          acronym == other.acronym;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ acronym.hashCode;
}