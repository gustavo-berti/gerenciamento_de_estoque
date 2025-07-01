class City {
  final int? id;
  final String name;
  final int stateId;
  
  City({
    this.id,
    required this.name,
    required this.stateId,
  });

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] as int?,
      name: map['name'] as String,
      stateId: map['state_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state_id': stateId,
    };
  }

  City copyWith({
    int? id,
    String? name,
    int? stateId,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      stateId: stateId ?? this.stateId,
    );
  }

  @override
  String toString() {
    return 'City{id: $id, name: $name, stateId: $stateId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          stateId == other.stateId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ stateId.hashCode;
}