import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  State<Success> createState() => _SuccessState();
}
class _SuccessState extends State<Success> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Success'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                 Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Text('Successfully Authenticated'),
                        Icon(Icons.emoji_emotions_sharp),
                      ],
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}