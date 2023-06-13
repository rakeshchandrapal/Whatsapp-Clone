import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/assets/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/theme/theme.dart';

import '../../../assets/info.dart';
import '../../../widgets/appText.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Loader();
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatContactData = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MobileChatScreen(
                          name: chatContactData.name,
                          uid: chatContactData.contactId,
                        )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: AppText(text:chatContactData.name,
                               size: 18,),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: AppText(
                              text: chatContactData.lastMessage,
                              size:  15,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                             chatContactData.profilePic,
                            ),
                            radius: 30,
                          ),
                          trailing: AppText(
                           text: DateFormat.Hm().format(chatContactData.timeSent),
                           size: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }, separatorBuilder: (BuildContext context, int index) {
                return const Divider(color: dividerColor,indent: 85,);
            },
            );
          }
        ));
  }
}