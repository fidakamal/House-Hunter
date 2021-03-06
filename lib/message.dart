import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message extends StatefulWidget {
  const Message({Key? key, required this.receiver}) : super(key: key);
  final String receiver;

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String messageText;
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    _firestore.collection("messages").add({
      "people": [_auth.currentUser!.email!, widget.receiver],
      "message": messageText,
      "sender": _auth.currentUser!.email!,
      "time": Timestamp.fromDate(DateTime.now()),
    });
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.cyan[300]),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Back",
                      style: TextStyle(fontSize: 18, color: Colors.cyan[300]),
                    ),
                  ],
                ),
              ),
            ),
            MessageStream(
                user: _auth.currentUser!.email!, receiver: widget.receiver),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 15,
                      bottom: 15,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(60),
                          ),
                          borderSide: BorderSide(
                            color: Colors.cyan[300]!,
                            width: 5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(60),
                          ),
                          borderSide: BorderSide(
                            color: Colors.cyan[300]!,
                            width: 2,
                          ),
                        ),
                      ),
                      controller: messageController,
                      onChanged: (value) => messageText = value,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => sendMessage(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.send_rounded,
                        size: 30,
                        color: Colors.cyan[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key, required this.user, required this.receiver})
      : super(key: key);
  final String user;
  final String receiver;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .where("people", arrayContains: user)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        var messages = snapshot.data?.docs;
        messages = messages!
            .where((message) => message["people"].contains(receiver))
            .toList();
        messages.sort((a, b) => b["time"].compareTo(a["time"]));

        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          final messageText = message["message"];
          final sender = message["sender"];

          final messageBubble = MessageBubble(
            sender: sender,
            text: messageText,
            isMe: sender == user,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender.split("@")[0],
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12.0,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(30.0) : Radius.zero,
              topRight: isMe ? Radius.zero : Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.cyan[300] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
