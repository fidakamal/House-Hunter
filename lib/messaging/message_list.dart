import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/profile/pre_logged_in_profile.dart';

class MessageList extends StatefulWidget {
  MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  User? user = FirebaseAuth.instance.currentUser;

  void goToDM(String receiver) {

  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return PreLoggedInProfile(setUser: (newUser) {
        setState(() => user = FirebaseAuth.instance.currentUser);
      });
    }

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("messages")
            .where("people", arrayContains: user!.email).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          var docs = snapshot.data!.docs;
          docs.sort((a, b) => b["time"].compareTo(a["time"]));
          Set receivers = docs.map((doc) => doc["people"]
              .singleWhere((person) => person != user!.email)).toSet();

          return Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.message_rounded, size: 35.0),
                      SizedBox(width: 7.0),
                      Text(
                        "Messages",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: "SignikaNegative"
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: receivers.length,
                    itemBuilder: ((context, index) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () => goToDM(receivers.elementAt(index)),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(receivers.elementAt(index)),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}