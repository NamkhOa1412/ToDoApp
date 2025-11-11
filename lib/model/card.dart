class CardModel {
  final String id;
  final String boardId;
  final String listId;
  final String title;
  final String? description;
  final bool archived;
  final DateTime? dueAt;

  CardModel({
    required this.id,
    required this.boardId,
    required this.listId,
    required this.title,
    this.description,
    required this.archived,
    this.dueAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      boardId: json['board_id'],
      listId: json['list_id'],
      title: json['title'],
      description: json['description'],
      archived: json['archived'] ?? false,
      dueAt: json['due_at'] != null ? DateTime.parse(json['due_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'board_id': boardId,
      'list_id': listId,
      'title': title,
      'description': description,
      'archived': archived,
      'due_at': dueAt?.toIso8601String(),
    };
  }
}
