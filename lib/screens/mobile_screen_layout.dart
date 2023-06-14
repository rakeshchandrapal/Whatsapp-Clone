import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/assets/colors.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/chat/widgets/contacts_list.dart';

import '../features/auth/controller/auth_controller.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> with WidgetsBindingObserver{

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(authControllerProvider).setUserState(true);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0,
            title: const Text("Whatsapp", style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            centerTitle: false,
            actions: [
              IconButton(
                  onPressed: (){}, icon: const Icon(Icons.search, ), color: Colors.grey,
              ),
              IconButton(
                  onPressed: (){}, icon: const Icon(Icons.more_vert),color: Colors.grey,
              ),

            ],
            bottom: const TabBar(
              indicatorWeight: 4,
              indicatorColor: tabColor,
              labelColor: tabColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
                tabs: [
                  Tab(text:'CHATS'),
                  Tab(text:'STATUS'),
                  Tab(text:'CALLS'),
               ]
            ),
          ),
          body: const ContactsList(),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            },
            backgroundColor: tabColor,
            child: const Icon(Icons.chat,color: Colors.white,),
          ),
        )
    );
  }
}