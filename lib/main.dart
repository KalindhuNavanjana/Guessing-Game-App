import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guessing Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Guess Me'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _secret = Random().nextInt(10);
  int _chancesLeft = 3;
  final TextEditingController myController = TextEditingController();

  void reserSecret() {
    _secret = Random().nextInt(10);
  }

  void _evaluateGuess() {
    String _guess = myController.text;
    debugPrint('guess: $_guess');
    debugPrint('secret: $_secret');

    myController.value = const TextEditingValue(text: "");

    if (_guess == _secret.toString()) {
      //go to success screen  ==> SuccessScreen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SuccessScreen(value: _secret.toString())),
      ).then((value) => {
        _secret = value,
        _chancesLeft = 3
      });
    } else {
      if (_chancesLeft <= 1) {
        //go to game over screen screen ==> FailedScreen
        _chancesLeft = 3;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FailedScreen()),
        );
        _secret = Random().nextInt(10);
      } else {
        _chancesLeft--;
        //try again
        createDialog(context);
      }
    }
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              elevation: 5.0,
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Your Guess is wrong",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5),
                      Text("You have only",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5),
                      Text("$_chancesLeft",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2),
                      Text("tries left",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 50, 0, 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 100.0)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 50, 200, 255)),
                          ),
                          child: const Text('Guess Again'),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 60.0, right: 60.0),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          widthFactor: 5.5,
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                child: Text(
                  'I have a secret number in my mind \nCan you guess it?\nYou have 3 chances to success',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextField(
                  controller: myController,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    // hintText: '0-9',
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 100.0)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(100, 010, 255, 0)),
                ),
                onPressed: _evaluateGuess,
                child: const Text('Guess'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Congratulations"),
      ),
      body: Center(
          child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
        child: Column(
          children: [
            const Text(
              'You have guessed it right..!\nMy number is',
              style: TextStyle(fontSize: 25, height: 1.5),
            ),
            Container(
              height: 50,
            ),
            Text(value, style: const TextStyle(fontSize: 100, height: 1.5)),
            Container(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(Random().nextInt(10));
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 100.0)),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(100, 010, 255, 0)),
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      )),
    );
  }
}

class FailedScreen extends StatelessWidget {
  const FailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oops...!"),
      ),
      body: Center(
          child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
        child: Column(
          children: [
            const Text(
              'Sorry wrong guess',
              style: TextStyle(fontSize: 25, height: 1.5),
            ),
            Container(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 100.0)),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 50, 200, 255)),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      )),
    );
  }
}
