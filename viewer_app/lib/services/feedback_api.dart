import 'dart:io';
import 'package:dio/dio.dart';
import 'resource_pack_service.dart';

/// Feedback now goes straight to the live backend (no more local-only
/// queueing) since the server is always reachable when there's a
/// connection. If the user is offline, submission simply fails with a
/// clear message — there's nothing to silently queue since this app's
/// job is to work offline for *reading*, not for writing.
class FeedbackApi {
  static Future<void> submit({
    required String description,
    File? image,
    String? topicId,
    String? granthId,
    String? pramanId,
  }) async {
    final dio = Dio();
    final form = FormData.fromMap({
      'description': description,
      if (topicId != null) 'topic_id': topicId,
      if (granthId != null) 'granth_id': granthId,
      if (pramanId != null) 'praman_id': pramanId,
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });
    await dio.post('${ResourcePackService.instance.serverUrl}/api/feedback', data: form);
  }
}
