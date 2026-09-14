library models;

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

  FeedbackItem({required this.id, required this.description, this.image});

  factory FeedbackItem.fromJson(Map<String, dynamic> j) => FeedbackItem(
        id: j['id'].toString(),
        description: j['description'] ?? '',
        image: j['image'],
      );
}

class ResourcePack {
  final int version;
  final List<Topic> topics;
  final List<Granth> granths;
  final List<Praman> pramans;
  final List<FeedbackItem> feedbacks;

  ResourcePack({
    required this.version,
    required this.topics,
    required this.granths,
    required this.pramans,
    required this.feedbacks,
  });

  factory ResourcePack.empty() => ResourcePack(version: 0, topics: [], granths: [], pramans: [], feedbacks: []);

  factory ResourcePack.fromJson(Map<String, dynamic> j) => ResourcePack(
        version: j['version'] ?? 1,
        topics: ((j['topics'] ?? []) as List).map((e) => Topic.fromJson(e)).toList(),
        granths: ((j['granths'] ?? []) as List).map((e) => Granth.fromJson(e)).toList(),
        pramans: ((j['pramans'] ?? []) as List).map((e) => Praman.fromJson(e)).toList(),
        feedbacks: ((j['feedbacks'] ?? []) as List).map((e) => FeedbackItem.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'topics': topics
            .map((e) => {'id': e.id, 'title': e.title, 'description': e.description, 'image': e.image})
            .toList(),
        'granths': granths
            .map((e) => {'id': e.id, 'title': e.title, 'description': e.description, 'image': e.image, 'topic_id': e.topicId})
            .toList(),
        'pramans': pramans
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'description': e.description,
                  'image': e.image,
                  'topic_id': e.topicId,
                  'granth_id': e.granthId,
                  'youtube_url': e.youtubeUrl,
                  'youtube_desc': e.youtubeDesc,
                  'youtube_start': e.youtubeStart,
                })
            .toList(),
        'feedbacks': feedbacks.map((e) => {'id': e.id, 'description': e.description, 'image': e.image}).toList(),
      };
}
