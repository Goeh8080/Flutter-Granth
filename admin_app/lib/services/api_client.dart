import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// One place that knows how to reach the backend. Change [defaultBaseUrl]
/// once you've deployed the server, or let the admin set it at runtime
/// from the Settings screen (stored in SharedPreferences either way).
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const defaultBaseUrl = 'https://your-server.example.com';
  static const _kBaseUrlKey = 'api_base_url';
  static const _kTokenKey = 'auth_token';

  late Dio _dio;
  String? _token;
  String _baseUrl = defaultBaseUrl;

  String get baseUrl => _baseUrl;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString(_kBaseUrlKey) ?? defaultBaseUrl;
    _token = prefs.getString(_kTokenKey);
    _buildDio();
  }

  void _buildDio() {
    _dio = Dio(BaseOptions(
      baseUrl: '$_baseUrl/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: _token != null ? {'Authorization': 'Bearer $_token'} : {},
    ));
  }

  Future<void> setBaseUrl(String url) async {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBaseUrlKey, _baseUrl);
    _buildDio();
  }

  bool get isLoggedIn => _token != null;

  Future<void> _setToken(String? token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove(_kTokenKey);
    } else {
      await prefs.setString(_kTokenKey, token);
    }
    _buildDio();
  }

  Future<void> logout() => _setToken(null);

  // ---- Auth ----
  Future<String> login(String username, String password) async {
    final res = await _dio.post('/auth/login', data: {'username': username, 'password': password});
    await _setToken(res.data['token']);
    return res.data['username'];
  }

  Future<List<AdminAccount>> listAdmins() async {
    final res = await _dio.get('/auth/admins');
    return (res.data as List).map((e) => AdminAccount.fromJson(e)).toList();
  }

  Future<void> createAdmin(String username, String password) =>
      _dio.post('/auth/admins', data: {'username': username, 'password': password});

  Future<void> deleteAdmin(String id) => _dio.delete('/auth/admins/$id');

  // ---- Topics ----
  Future<List<Topic>> getTopics() async {
    final res = await _dio.get('/topics');
    return (res.data as List).map((e) => Topic.fromJson(e)).toList();
  }

  Future<void> saveTopic({String? id, required String title, required String description, File? image}) async {
    final form = FormData.fromMap({
      'title': title,
      'description': description,
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });
    if (id == null) {
      await _dio.post('/topics', data: form);
    } else {
      await _dio.put('/topics/$id', data: form);
    }
  }

  Future<void> deleteTopic(String id) => _dio.delete('/topics/$id');

  // ---- Granths ----
  Future<List<Granth>> getGranths() async {
    final res = await _dio.get('/granths');
    return (res.data as List).map((e) => Granth.fromJson(e)).toList();
  }

  Future<void> saveGranth({
    String? id,
    required String title,
    required String description,
    String? topicId,
    File? image,
  }) async {
    final form = FormData.fromMap({
      'title': title,
      'description': description,
      'topic_id': topicId ?? '',
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });
    if (id == null) {
      await _dio.post('/granths', data: form);
    } else {
      await _dio.put('/granths/$id', data: form);
    }
  }

  Future<void> deleteGranth(String id) => _dio.delete('/granths/$id');

  // ---- Pramans ----
  Future<List<Praman>> getPramans() async {
    final res = await _dio.get('/pramans');
    return (res.data as List).map((e) => Praman.fromJson(e)).toList();
  }

  Future<void> savePraman({
    String? id,
    required String title,
    required String description,
    String? topicId,
    String? granthId,
    String? youtubeUrl,
    String? youtubeDesc,
    int? youtubeStart,
    File? image,
  }) async {
    final form = FormData.fromMap({
      'title': title,
      'description': description,
      'topic_id': topicId ?? '',
      'granth_id': granthId ?? '',
      'youtube_url': youtubeUrl ?? '',
      'youtube_desc': youtubeDesc ?? '',
      'youtube_start': youtubeStart?.toString() ?? '',
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });
    if (id == null) {
      await _dio.post('/pramans', data: form);
    } else {
      await _dio.put('/pramans/$id', data: form);
    }
  }

  Future<void> deletePraman(String id) => _dio.delete('/pramans/$id');

  // ---- Feedback ----
  Future<List<FeedbackItem>> getFeedback() async {
    final res = await _dio.get('/feedback');
    return (res.data as List).map((e) => FeedbackItem.fromJson(e)).toList();
  }

  Future<void> deleteFeedback(String id) => _dio.delete('/feedback/$id');

  /// Resolves an "images/xyz.jpg" pack-relative path into a full URL
  /// pointing at the server's static uploads folder, for previewing
  /// images inside the Admin app.
  String imageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) return '';
    return '$_baseUrl/uploads/$relativePath';
  }
}
