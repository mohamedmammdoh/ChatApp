import 'dart:ffi';

import 'package:chat_app/constants.dart';
import 'package:chat_app/models/massagemodel.dart';
import 'package:chat_app/widgets/BubbleChat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChattScreen extends StatefulWidget {
  const ChattScreen({super.key});

  @override
  State<ChattScreen> createState() => _ChattScreenState();
}

class _ChattScreenState extends State<ChattScreen> {
  CollectionReference massages =
      FirebaseFirestore.instance.collection(kMassagesCollections);

  TextEditingController controller = TextEditingController();
  final contoller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: massages.orderBy('createdat', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<MassageModel> massages_list = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            massages_list.add(MassageModel.fromjson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kprimarycolor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assest/scholar.png',
                    width: 40,
                    height: 40,
                  ),
                  const Text(
                    'Chat',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: massages_list.length,
                    controller: contoller,
                    itemBuilder: (context, index) {
                      return (massages_list[index].id == email)
                          ? BubbleChat(
                              massageModel: massages_list[index],
                            )
                          : BubbleChatforFriend(
                              massageModel: massages_list[index],
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      massages.add(
                        {
                          'massages': data,
                          'createdat': DateTime.now(),
                          'id': email
                        },
                      );
                      controller.clear();
                      contoller.animateTo(
                        contoller.position.maxScrollExtent,
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.send)),
                      hintText: 'Send Massage',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Loading......');
        }
      },
    );
  }
}
