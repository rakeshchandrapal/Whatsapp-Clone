import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/assets/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/call/controller/call_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_clone/features/chat/widgets/chat_list.dart';
import '../../../assets/info.dart';
import '../../../models/user_model.dart';
import '../../../widgets/appText.dart';
import '../../call/screens/call_pickup_screen.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  void makeCall(WidgetRef ref,BuildContext context){
    ref.read(callControllerProvider).makeCall(context, name, uid, profilePic , isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat ? AppText(text: name): StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: name,
                  ),
                  AppText(
                    text: snapshot.data!.isOnline ? 'Online' : 'Offline',
                    size: 13,
                    weight: FontWeight.normal,
                  ),
                ],
              );
            }),
        actions: [
          IconButton(onPressed:() => makeCall(ref, context ), icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatList(
            receiverUserId: uid,
                  isGroupChat : isGroupChat
          )),
          BottomChatField(
            receiverUserId: uid,
              isGroupChat : isGroupChat,
          ),
        ],
      ),
    ),
    );
  }
}
