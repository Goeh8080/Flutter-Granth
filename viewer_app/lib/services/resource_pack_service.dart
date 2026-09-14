import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Talks to the live granth-server: checks whether a newer resource pack
/// exists, downloads + extracts it, and serves everything from local
/// disk after that — so the rest of the app works with zero connectivity
/// once a pack is installed. Content updates as soon as the admin
/// publishes changes; the app just needs to check in again.
class ResourcePackService {
  ResourcePackService._();
  static final ResourcePackService instance = ResourcePackService._();

  static const defaultServerUrl = 'https://your-server.example.com';
  static const _kServerUrlKey = 'server_base_url';
  static const _kInstalledVersionKey = 'resource_pack_version';

  final Dio _dio = Dio();
  String _serverUrl = defaultServerUrl;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _serverUrl = prefs.getString(_kServerUrlKey) ?? defaultServerUrl;
  }

  String get serverUrl => _serverUrl;

  Future<void> setServerUrl(String url) async {
    _serverUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kServerUrlKey, _serverUrl);
  }

  Future<Directory> get _rootDir async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'resource_pack'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> get _manifestFile async {
    final root = await _rootDir;
    return File(p.join(root.path, 'manifest.json'));
  }

  Future<File?> resolveImage(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) return null;
    final root = await _rootDir;
    final f = File(p.join(root.path, relativePath));
    return await f.exists() ? f : null;
  }

  Future<int> get installedVersion async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kInstalledVersionKey) ?? 0;
  }

  Future<bool> get hasLocalPack async => (await _manifestFile).exists();

  Future<ResourcePack> loadLocal() async {
    final file = await _manifestFile;
    if (!await file.exists()) return ResourcePack.empty();
    final raw = await file.readAsString();
    return ResourcePack.fromJson(jsonDecode(raw));
  }

  /// Returns {version, url} from the server, or null if unreachable.
  Future<({int version, String? url})?> checkRemoteVersion() async {
    try {
      final res = await _dio.get('$_serverUrl/api/pack/version');
      return (version: res.data['version'] as int, url: res.data['url'] as String?);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isUpdateAvailable() async {
    final remote = await checkRemoteVersion();
    if (remote == null || remote.url == null) return false;
    return remote.version > await installedVersion;
  }

  /// Downloads the pack currently pointed to by the server and installs it,
  /// replacing whatever was there before.
  Future<void> syncNow({void Function(double progress)? onProgress}) async {
    final remote = await checkRemoteVersion();
    if (remote == null || remote.url == null) {
      throw Exception('Could not reach the server. Check the server address and your connection.');
    }

    final tempDir = await getTemporaryDirectory();
    final zipPath = p.join(tempDir.path, 'pack_${DateTime.now().millisecondsSinceEpoch}.zip');

    await _dio.download(
      remote.url!,
      zipPath,
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress?.call(received / total);
      },
    );

    await _installFromZip(File(zipPath));
    await File(zipPath).delete().catchError((_) => File(zipPath));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kInstalledVersionKey, remote.version);
  }

  Future<void> _installFromZip(File zipFile) async {
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final root = await _rootDir;

    if (await root.exists()) await root.delete(recursive: true);
    await root.create(recursive: true);

    for (final entry in archive) {
      final outPath = p.join(root.path, entry.name);
      if (entry.isFile) {
        final outFile = File(outPath);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(entry.content as List<int>);
      } else {
        await Directory(outPath).create(recursive: true);
      }
    }
  }
}
