import 'package:flutter/material.dart';
import 'package:whatsapp_clone/assets/colors.dart';

import 'package:whatsapp_clone/widgets/web/web_chat_app_bar.dart';
import 'package:whatsapp_clone/widgets/web/web_profile_bar.dart';
import 'package:whatsapp_clone/widgets/web/web_search_bar.dart';
import '../features/chat/widgets/chat_list.dart';
import '../features/chat/widgets/contacts_list.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  // web profile bar
                  WebProfileBar(),
                  // web search bar
                  WebSearchBar(),
                  // ContactList
                  ContactsList(),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.70,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('lib/assets/images/backgroundImage.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              children: [
                // chat app bar
                WebChatAppBar(),
                //   chat list
                Expanded(child: ChatList(receiverUserId: " ",)),
                // message input box
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: dividerColor),
                    ),
                    color: chatBarMessage,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.emoji_emotions_outlined),
                        color: Colors.grey,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.attach_file),
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 15),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: searchBarColor,
                              hintText: 'Type a message',
                              border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const  BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                              ),
                              contentPadding: const EdgeInsets.only(left: 20,),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mic),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //web screen
        ],
      ),
    );
  }
}