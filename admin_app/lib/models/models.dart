class Topic {
  final String id;
  String title;
  String description;
  String? image;

  Topic({required this.id, required this.title, this.description = '', this.image});

  factory Topic.fromJson(Map<String, dynamic> j) => Topic(
        id: j['id'].toString(),
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        image: j['image'],
      );
}

class Granth {
  final String id;
  String title;
  String description;
  String? image;
  String? topicId;

  Granth({required this.id, required this.title, this.description = '', this.image, this.topicId});

  factory Granth.fromJson(Map<String, dynamic> j) => Granth(
        id: j['id'].toString(),
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        image: j['image'],
        topicId: j['topic_id']?.toString(),
      );
}

class Praman {
  final String id;
  String title;
  String description;
  String? image;
  String? topicId;
  String? granthId;
  String? youtubeUrl;
  String? youtubeDesc;
  int? youtubeStart;

  Praman({
    required this.id,
    required this.title,
    this.description = '',
    this.image,
    this.topicId,
    this.granthId,
    this.youtubeUrl,
    this.youtubeDesc,
    this.youtubeStart,
  });

  factory Praman.fromJson(Map<String, dynamic> j) => Praman(
        id: j['id'].toString(),
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        image: j['image'],
        topicId: j['topic_id']?.toString(),
        granthId: j['granth_id']?.toString(),
        youtubeUrl: j['youtube_url'],
        youtubeDesc: j['youtube_desc'],
        youtubeStart: j['youtube_start'] is int ? j['youtube_start'] : int.tryParse('${j['youtube_start'] ?? ''}'),
      );
}

class FeedbackItem {
  final String id;
  String description;
  String? image;
  String? createdAt;

  FeedbackItem({required this.id, required this.description, this.image, this.createdAt});

  factory FeedbackItem.fromJson(Map<String, dynamic> j) => FeedbackItem(
        id: j['id'].toString(),
        description: j['description'] ?? '',
        image: j['image'],
        createdAt: j['createdAt'],
      );
}

class AdminAccount {
  final String id;
  final String username;
  final String? createdAt;

  AdminAccount({required this.id, required this.username, this.createdAt});

  factory AdminAccount.fromJson(Map<String, dynamic> j) =>
      AdminAccount(id: j['id'].toString(), username: j['username'] ?? '', createdAt: j['createdAt']);
}
