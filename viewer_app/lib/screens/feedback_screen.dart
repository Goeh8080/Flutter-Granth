import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart';
import '../services/feedback_api.dart';
import '../theme/app_theme.dart';
import 'pack_image.dart';

class FeedbackScreen extends StatefulWidget {
  final ResourcePack pack;
  const FeedbackScreen({super.key, required this.pack});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  void _openComposer() {
    final controller = TextEditingController();
    File? image;
    bool sending = false;
    String? error;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Feedback', style: AppTheme.display(size: 18)),
                  const SizedBox(height: 12),
                  if (error != null) ...[
                    Text(error!, style: const TextStyle(color: AppColors.maroon, fontSize: 12.5)),
                    const SizedBox(height: 8),
                  ],
                  TextField(controller: controller, maxLines: 4, decoration: const InputDecoration(hintText: 'Your feedback or reference note…')),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
                      if (picked != null) setSheetState(() => image = File(picked.path));
                    },
                    icon: const Icon(Icons.image_outlined),
                    label: Text(image == null ? 'Attach Photo (optional)' : 'Photo attached'),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: sending
                          ? null
                          : () async {
                              if (controller.text.trim().isEmpty) return;
                              setSheetState(() {
                                sending = true;
                                error = null;
                              });
                              try {
                                await FeedbackApi.submit(description: controller.text.trim(), image: image);
                                if (ctx.mounted) Navigator.pop(ctx);
                                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you — feedback sent!')));
                              } catch (e) {
                                setSheetState(() {
                                  error = 'Could not send. Check your connection and try again.';
                                  sending = false;
                                });
                              }
                            },
                      child: sending
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = widget.pack.feedbacks;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openComposer,
        icon: const Icon(Icons.add),
        label: const Text('Add Feedback'),
      ),
      body: all.isEmpty
          ? const Center(child: Text('No feedback yet', style: TextStyle(color: Colors.black45)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: all.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final f = all[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (f.image != null) ...[PackImage(relativePath: f.image, width: 56, height: 56), const SizedBox(width: 12)],
                        Expanded(child: Text(f.description, style: AppTheme.body(size: 13.5))),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
