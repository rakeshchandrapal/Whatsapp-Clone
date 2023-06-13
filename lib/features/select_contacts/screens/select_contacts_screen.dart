import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_clone/widgets/appText.dart';

import '../../../common/widgets/loader.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = "/select-contacts ";
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(WidgetRef ref , Contact selectedContact,BuildContext context){
     ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Select contact',

        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) => ListView.builder(
                itemBuilder: (context, index) {
                   var contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(ref,contact,context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: ListTile(
                        title: AppText(
                          text: contact.displayName,
                          size:  18,
                        ),
                        leading: contact.photo == null ? null : CircleAvatar(
                          backgroundImage: MemoryImage(contact.photo!),
                          radius: 30,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: contactList.length,
              ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const Loader()),
    );
  }
}