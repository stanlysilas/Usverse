import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/features/letters/widgets/letter_composer_bar.dart';
import 'package:usverse/models/daily_letter_model.dart';
import 'package:usverse/services/firebase/daily_letters_service.dart';

class LettersScreen extends StatelessWidget {
  final String relationshipId;

  const LettersScreen({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final service = DailyLettersService();

    double expiryProgress(DateTime start, DateTime end) {
      final total = end.difference(start).inSeconds;
      final remaining = end.difference(DateTime.now()).inSeconds;

      if (total <= 0) return 0;
      if (remaining <= 0) return 0;

      return remaining / total;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Today's Letters"),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: StreamBuilder<List<DailyLetter>>(
          stream: service.watchLettersForDate(relationshipId, DateTime.now()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Letters missing'));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final letters = snapshot.data!;

            if (letters.isEmpty) {
              return const Center(
                child: Text(
                  "No letters scheduled today 💌",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 520),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: letters.length,
                  itemBuilder: (context, index) {
                    final message = letters[index];

                    final isMe =
                        message.senderId ==
                        FirebaseAuth.instance.currentUser!.uid;

                    // final isActive =
                    //     DateTime.now().isAfter(message.startAt) &&
                    //     DateTime.now().isBefore(message.expiresAt);

                    return Card(
                      key: ValueKey(letters[index].id),
                      color: isMe
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                      margin: isMe
                          ? EdgeInsets.only(top: 6, bottom: 6, left: 72)
                          : EdgeInsets.only(top: 6, bottom: 6, right: 72),
                      shape: RoundedRectangleBorder(
                        borderRadius: isMe
                            ? BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0),
                                bottomLeft: Radius.circular(24.0),
                                bottomRight: Radius.circular(0),
                              )
                            : BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(24.0),
                              ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage:
                                      message.senderPhotoUrl.isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          message.senderPhotoUrl,
                                        )
                                      : null,
                                  child: message.senderPhotoUrl.isEmpty
                                      ? const Icon(Icons.person, size: 16)
                                      : null,
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  message.senderDisplayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              message.message,
                              style: const TextStyle(fontSize: 16),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatTime(message.startAt),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: expiryProgress(
                                      message.startAt,
                                      message.expiresAt,
                                    ),
                                    color:
                                        expiryProgress(
                                              message.startAt,
                                              message.expiresAt,
                                            ) <
                                            0.2
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: MessageComposerBar(relationshipId: relationshipId),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final suffix = time.hour >= 12 ? "PM" : "AM";
    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute $suffix";
  }
}
