import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/widgets/appText.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);
  
  void cancelReply(WidgetRef ref ){
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageRely = ref.watch(messageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  text: messageRely!.isMe ? 'Me' : 'Opposite',
                  weight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                child: const Icon(Icons.close, size: 16),
                onTap: () => cancelReply(ref),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          AppText(
            text: messageRely.message ,
          ),
        ],
      ),
    );
  }
}
