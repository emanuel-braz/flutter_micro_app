class MicroBoardHandler {
  final String type;
  final String parentName;
  final List<String> channels;

  MicroBoardHandler({
    required this.type,
    required this.parentName,
    required this.channels,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'parentName': parentName,
      'channels': channels,
    };
  }

  factory MicroBoardHandler.fromMap(Map<String, dynamic> map) {
    return MicroBoardHandler(
      type: map['type'],
      parentName: map['parentName'],
      channels: List<String>.from(map['channels']),
    );
  }
}
