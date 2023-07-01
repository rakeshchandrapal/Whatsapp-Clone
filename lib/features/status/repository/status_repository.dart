import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

import '../../../models/status_model.dart';
import '../../../models/user_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageurl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
        '/status/$statusId$uid',
        statusImage,
      );
      List<String> uidWhoCanSee = [];

      var userSnapshot = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('Friends').doc('IDS').get();
      print(List.from(userSnapshot.data()!['friends']));

      uidWhoCanSee = List.from(userSnapshot.data()!['friends']);
      // print(uidWhoCanSee);

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
        'uid',
        isEqualTo: auth.currentUser!.uid,
      ).get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageurl];
      }

      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      var statusSnapshot = await firestore.collection('status').get();
      for (var status in statusSnapshot.docs) {
        var temp = Status.fromMap(status.data());
        print(temp.createdAt.hour);
        for (var i in temp.whoCanSee) {
          if (i == auth.currentUser!.uid) {
            statusData.add(temp);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }

  Future<void> getWhoCanSee() async {
    try {
      List<String> friends = [];
      List<Contact> phoneContacts = [];
      if (await FlutterContacts.requestPermission()) {
        phoneContacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (int i = 0; i < phoneContacts.length; i++) {
        if (phoneContacts[i].phones.isNotEmpty) {
          var num = phoneContacts[i].phones[0].number.replaceAll(' ', '');
          if(num.length == 10) {
            num = '+91$num';
          }
          var userSnapshot = await firestore
              .collection('users')
              .where('phoneNumber',
              isEqualTo: num)
              .get();

          if (userSnapshot.docs.isNotEmpty) {
            var userData = UserModel.fromMap(userSnapshot.docs[0].data());
            print(userData.name);
            print(userData.phoneNumber);
            if (!friends.contains(userData.uid)) {
              friends.add(userData.uid);
            }
          }
        }
      }
      if(!friends.contains(auth.currentUser!.uid)){
        friends.add(auth.currentUser!.uid);
      }
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('Friends').doc('IDS').set({'friends': friends});
      print("UIDS : $friends");
    }
    catch (e) {
      print(e.toString());
    }
  }
}
