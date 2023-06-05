import 'package:flutter/material.dart';
import 'constants.dart';
import 'model.dart';
import 'response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String prompt;

  late bool isLoading = false;

  final _scrollcontroller = ScrollController();

  final List<ChatMessage> _messages = [];

  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color.fromRGBO(47, 43, 83, 1),
            title: Text('chat violet'),
          ),
          backgroundColor: Color.fromRGBO(47, 43, 83, 0.8),
          body: SafeArea(
            child: Column(
              children: [
                Visibility(
                  visible: isLoading,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(child: _buildList()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            prompt = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      Visibility(
                        visible: !isLoading,
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Container(
                            child: IconButton(
                              onPressed: () {
                                //display user input
                                setState(() {
                                  _messages.add(ChatMessage(
                                      text: messageTextController.text,
                                      chatMessageType: ChatMessageType.user));
                                  isLoading = true;
                                });
                                var input = messageTextController.text;
                                messageTextController.clear();
                                Future.delayed(Duration(milliseconds: 50))
                                    .then((value) => _scrollDown());
                                //call api here
                                getResponse(input).then((value){
                                  setState(() {
                                    isLoading=false;
                                    _messages.add(ChatMessage(text: value, chatMessageType: ChatMessageType.bot));
                                  });
                                });
                                messageTextController.clear();
                                Future.delayed(Duration(milliseconds: 50)).then((value) => _scrollDown());
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.purpleAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scrollDown() {
    _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  ListView _buildList() {
    return ListView.builder(
        itemCount: _messages.length,
        controller: _scrollcontroller,
        itemBuilder: ((context, index) {
          var message = _messages[index];
          return ChatMessageWidget(
            text: message.text,
            chatMessageType: message.chatMessageType,
          );
        }));
  }
}

class ChatMessageWidget extends StatelessWidget {
  late final String text;
  late final ChatMessageType chatMessageType;
  ChatMessageWidget({required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: chatMessageType == ChatMessageType.bot
            ? Colors.black26
            : Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Image.asset(
                      'assets/violet.jpg',
                      scale: 1.5,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    child: Icon(
                      Icons.account_circle,
                    ),
                  )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
