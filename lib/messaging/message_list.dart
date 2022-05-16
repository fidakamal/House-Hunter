import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:house_hunter/message.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  User? user = FirebaseAuth.instance.currentUser;
  ValueNotifier value = ValueNotifier(FirebaseAuth.instance.currentUser);

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() => user = FirebaseAuth.instance.currentUser);
    });
  }

  void goToDM(String receiver) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Message(receiver: receiver)));
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.person_rounded, size: 80),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                  "Please log in to view your messages.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, height: 1.5, color: Colors.black38)),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.cyanAccent[700],
                      padding:
                      EdgeInsets.symmetric(vertical: 17, horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Provider.of<Navigation>(context, listen:false).updateCurrentPage(PageName.profile),
                  child: Text("Log In")),
            )
          ],
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("messages")
            .where("people", arrayContains: user!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.message_rounded, size: 80),
                  SizedBox(height: 10.0),
                  Text(
                      "No conversations yet. When a landlord messages you about a property, it will show up here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, height: 1.5, color: Colors.black38)),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.cyanAccent[700],
                            padding:
                            EdgeInsets.symmetric(vertical: 17, horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () => Provider.of<Navigation>(context, listen:false).updateCurrentPage(PageName.map),
                        child: Text("Start Browsing")),
                  )
                ],
              ),
            );
          }

          var docs = snapshot.data!.docs;
          docs.sort((a, b) => b["time"].compareTo(a["time"]));
          Set receivers = docs
              .map((doc) =>
                  doc["people"].singleWhere((person) => person != user!.email))
              .toSet();

          return Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Row(
                  //   children: const [
                  //     Icon(Icons.mail_outlined, size: 35.0),
                  //     SizedBox(width: 7.0),
                  //     Text(
                  //       "Messages",
                  //       style: TextStyle(
                  //           fontSize: 30.0, fontFamily: "SignikaNegative"),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: receivers.length,
                    itemBuilder: ((context, index) {
                      return Material(
                        elevation: 1,
                        color: Colors.cyan[50],
                        borderRadius: BorderRadius.circular(40),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          onTap: () => goToDM(receivers.elementAt(index)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Text(
                              receivers.elementAt(index).split("@")[0],
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "SignikaNegative",
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
