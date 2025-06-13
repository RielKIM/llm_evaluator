class Dataset {
  final int id;
  final String name;
  final String desc;
  final String createdAt;

  Dataset({
    required this.id,
    required this.name,
    required this.desc,
    required this.createdAt,
  });

  factory Dataset.fromJson(Map<String, dynamic> json) {
    return Dataset(
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