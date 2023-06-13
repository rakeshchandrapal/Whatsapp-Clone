import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../models/user_model.dart';
import '../../chat/screens/mobile_chat_screen.dart';


final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact , BuildContext context) async{
    try{
     var userCollection = await firestore.collection('users').get();
     bool isFound = false;

     for(var document in userCollection.docs){
       var userData = UserModel.fromMap(document.data());
       String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(' ', '');
       if(selectedPhoneNum.length <= 10){
         selectedPhoneNum = '+91$selectedPhoneNum';
       }
       if(selectedPhoneNum == userData.phoneNumber){
         isFound = true;
         Navigator.pushNamed(context, MobileChatScreen.routeName,arguments: {
           'name' : userData.name,
           'uid'  : userData.uid,
         });
       }
     }

     if(!isFound){
       showSnackBar(
         context: context,
         content: 'This number is not exist on this app'
       );
     }

    }
    catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }
}