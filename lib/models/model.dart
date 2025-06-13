class Model {
  final int id;
  final String name;
  final String desc;
  final String createdAt;

  Model({
    required this.id,
    required this.name,
    required this.desc,
    required this.createdAt,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'desc': desc,
    'createdAt': createdAt,
  };
} 