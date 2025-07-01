class State {
  final int? id;
  final String name;
  final String acronym;
  final int countryId;

  State({
    this.id,
    required this.name,
    required this.acronym,
    required this.countryId,
  });

  factory State.fromMap(Map<String, dynamic> map) {
    return State(
      id: map['id'] as int?,
      name: map['name'] as String,
      acronym: map['acronym'] as String,
      countryId: map['country_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'acronym': acronym,
      'country_id': countryId,
    };
  }

  State copyWith({
    int? id,
    String? name,
    String? acronym,
    int? countryId,
  }) {
    return State(
      id: id ?? this.id,
      name: name ?? this.name,
      acronym: acronym ?? this.acronym,
      countryId: countryId ?? this.countryId,
    );
  }

  @override
  String toString() {
    return 'State{id: $id, name: $name, acronym: $acronym, countryId: $countryId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          acronym == other.acronym &&
          countryId == other.countryId;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ acronym.hashCode ^ countryId.hashCode;
}
