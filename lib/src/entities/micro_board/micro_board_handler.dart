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
}
