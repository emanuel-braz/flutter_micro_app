class MicroBoardWebview {
  final String? name;
  final String? description;
  final String? parentName;

  MicroBoardWebview(
      {required this.name,
      required this.description,
      required this.parentName});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'parentName': parentName,
    };
  }

  factory MicroBoardWebview.fromMap(Map<String, dynamic> map) {
    return MicroBoardWebview(
      name: map['name'],
      description: map['description'],
      parentName: map['parentName'],
    );
  }
}
