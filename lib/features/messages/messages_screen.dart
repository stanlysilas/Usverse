import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/models/daily_message_model.dart';
import 'package:usverse/services/firebase/daily_message_service.dart';

class MessagesScreen extends StatelessWidget {
  final String relationshipId;

  const MessagesScreen({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final service = DailyMessageService();

    double expiryProgress(DateTime start, DateTime end) {
      final total = end.difference(start).inSeconds;
      final remaining = end.difference(DateTime.now()).inSeconds;

      if (total <= 0) return 0;
      if (remaining <= 0) return 0;

      return remaining / total;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Today's Messages")),
      body: StreamBuilder<List<DailyMessage>>(
        stream: service.watchMessagesForDate(relationshipId, DateTime.now()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Messages missing'));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final messages = snapshot.data!;

          if (messages.isEmpty) {
            return const Center(
              child: Text(
                "No messages scheduled today 💌",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 520),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  final isMe =
                      message.senderId ==
                      FirebaseAuth.instance.currentUser!.uid;

                  // final isActive =
                  //     DateTime.now().isAfter(message.startAt) &&
                  //     DateTime.now().isBefore(message.expiresAt);

                  return Card(
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
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final suffix = time.hour >= 12 ? "PM" : "AM";
    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute $suffix";
  }
}
