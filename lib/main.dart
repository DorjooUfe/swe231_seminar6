import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Seminar6(title: 'Семинар 6'),
    );
  }
}

class Seminar6 extends StatefulWidget {
  const Seminar6({super.key, required this.title});

  final String title;

  @override
  State<Seminar6> createState() => Seminar6State();
}

class Seminar6State extends State<Seminar6> {
  Color activeBg = Colors.transparent;
  Color color = Colors.black;
  List<String> fruits = ['apple', "banana", "orange", "lemon"];
  static String _displayStringForOption(String option) => option;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<Color>(
                  value: Colors.red,
                  child: Text('Background red'),
                ),
                const PopupMenuItem<Color>(
                  value: Colors.green,
                  child: Text('Background green'),
                ),
                const PopupMenuItem<Color>(
                  value: Colors.blue,
                  child: Text('Background blue'),
                ),
              ];
            },
            onSelected: (value) => setState(() {
              activeBg = value;
            }),
          )
        ],
        // Here we take the value from the Seminar6 object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        color: activeBg,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Seminar6(context);
              },
              child: Text('Alert', style: TextStyle(color: color)),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Toast'),
                ));
              },
              child: Text('Toast', style: TextStyle(color: color)),
            ),
            TextButton(
                onPressed: () {
                  _showContextMenu(context);
                },
                child: Text('Contextual', style: TextStyle(color: color))),
            TextButton(
                onPressed: () {
                  selectDialog(context);
                },
                child: Text('Select Alert', style: TextStyle(color: color))),
            Autocomplete<String>(
              displayStringForOption: _displayStringForOption,
              // view ээ ингэж сольж болно
              // optionsViewBuilder: (context, onSelected, options) => Material(
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width - 80,
              //     child: ListView.builder(
              //       shrinkWrap: true,
              //       itemCount: options.length,
              //       itemBuilder: (context, index) => Container(
              //         padding: EdgeInsets.symmetric(vertical: 8),
              //         color: Colors.white,
              //         child: Text(
              //           options.elementAt(index),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return fruits.where((String option) {
                  return option
                      .toString()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                debugPrint('{_displayStringForOption(selection)}');
              },
            ),
          ],
        ),
      ),
    );
  }

  Seminar6(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Alert dialog"),
            content: Text("Message"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  void _showContextMenu(BuildContext context) async {
    final result = await showMenu<Color>(
        context: context,

        // Show the context menu at the tap location
        position: RelativeRect.fromSize(Rect.zero, Size.zero),

        // set a list of choices for the context menu
        items: [
          const PopupMenuItem(
            child: Text(
              'Текстийн өнгө солих',
              style: TextStyle(color: Colors.pink),
            ),
          ),
          const PopupMenuItem<Color>(
            value: Colors.red,
            child: Text('Улаан'),
          ),
          const PopupMenuItem<Color>(
            value: Colors.green,
            child: Text('Ногоон'),
          ),
          const PopupMenuItem<Color>(
            value: Colors.blue,
            child: Text('Хөх'),
          ),
        ]);

    if (result != null) {
      setState(() {
        color = result;
      });
    }
  }

  void selectDialog(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select String '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Example 1');
                },
                child: const Text(
                  'Example 1',
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Example 2');
                },
                child: const Text('Example 2'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Example 3');
                },
                child: const Text('Example 3'),
              ),
            ],
          );
        });
    if (result != null) {
      print(result);
    }
  }
}
