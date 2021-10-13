import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    title: 'Guessing Game',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    translations: Messages(),
    locale: const Locale('en','US'),
    fallbackLocale: const Locale('en','US'),
    home: const MyHomePage(),
  ));
}

class Controller extends GetxController {
  var count = 0.obs;
  increment() => count++;

  int _secret = Random().nextInt(10);
  int _chancesLeft = 3;


  _evaluateGuess(myController) {
    String _guess = myController.text;
    debugPrint('guess: $_guess');
    debugPrint('secret: $_secret');

    myController.value = const TextEditingValue(text: "");

    if (_guess == _secret.toString()) {
      //go to success screen  ==> SuccessScreen
      Get.to(SuccessScreen(value: _secret.toString()));
      _secret = Random().nextInt(10);
      _chancesLeft = 3;
    } else {
      if (_chancesLeft <= 1) {
        //go to game over screen screen ==> FailedScreen
        _chancesLeft = 3;
        Get.to(const FailedScreen());
        _secret = Random().nextInt(10);
      } else {
        //try again
        _chancesLeft--;
        createDialog();
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
                padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("dialog_msg".tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5),
                      Text("dialog_pre".tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5),
                      Text("$_chancesLeft",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2),
                      Text("dialog_post".tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 50, 0, 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 100.0)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 50, 200, 255)),
                          ),
                          child: Text('dialog_cta'.tr),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

}

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
          'home_title': 'Guess Me',
          'home_discription':
              'I have a secret number in my mind \nCan you guess it?\nYou have 3 chances to success',
          'home_cta': 'Guess',
          'success_title': 'Congratulations',
          'success_msg': 'You have guessed it right..!\nMy number is',
          'success_cta': 'Play Again',
          'failed_title': 'Oops...!',
          'failed_msg': 'Sorry wrong guess',
          'failed_cta': 'Try Again',
          'dialog_msg': 'Your Guess is wrong',
          'dialog_pre': 'You have only',
          'dialog_post': 'tries left',
          'dialog_cta': 'Guess Again',
        },
        'si_SL': {
          'hello': 'ආයුබෝවන්',
          'home_title': 'Guess Me',
          'home_discription':
              'I have a secret number in my mind \nCan you guess it?\nYou have 3 chances to success',
          'home_cta': 'Guess',
          'success_title': 'Congratulations',
          'success_msg': 'You have guessed it right..!\nMy number is',
          'success_cta': 'Play Again',
          'failed_title': 'Oops...!',
          'failed_msg': 'Sorry wrong guess',
          'failed_cta': 'Try Again',
        }
      };
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Controller controller = Get.put(Controller());
    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 60.0, right: 60.0),
        child: Center(
          widthFactor: 5.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                child: Text(
                  'home_discription'.tr,
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
                onPressed: controller._evaluateGuess(myController),
                child: Text('home_cta'.tr),
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
        title: Text("success_wish".tr),
      ),
      body: Center(
          child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
        child: Column(
          children: [
            Text(
              'success_msg'.tr,
              style: const TextStyle(fontSize: 25, height: 1.5),
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
                Get.back();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 100.0)),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(100, 010, 255, 0)),
              ),
              child: Text('success_cta'.tr),
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
        title: Text("failed_title".tr),
      ),
      body: Center(
          child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
        child: Column(
          children: [
            Text(
              'failed_msg'.tr,
              style: const TextStyle(fontSize: 25, height: 1.5),
            ),
            Container(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 100.0)),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 50, 200, 255)),
              ),
              child: Text('failed_cta'.tr),
            ),
          ],
        ),
      )),
    );
  }
}
