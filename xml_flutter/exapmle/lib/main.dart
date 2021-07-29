import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:xml_flutter/xml_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<String> _html;
  String _xml = '';

  @override
  void initState() {
    super.initState();

    _html = rootBundle.loadString('assets/juice-detail.wxml');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final processor = PreProcessor(media.size.width);
    print("width = ${media.size.width}");
    return Scaffold(
      body: FutureBuilder<String>(
        future: _html,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _loading;
          } else if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Text('error: ${snapshot.error}\n${snapshot.stackTrace}'),
              ),
            );
          } else {
            final data = snapshot.requireData;
            final text = processor.preprocess(ctx, data);
            _xml = text;
            return _buildView(ctx, text);
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final content = _genXml(context, _xml);
          final f = File('gen.xml');
          f.writeAsStringSync(content);
          ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
            content: Text("'${f.absolute}' generate!"),
          ));
        },
      ),
    );
  }

  Widget _buildView(BuildContext context, String html) {
    final root = AssembleReader.fromSource(html);
    final tank = AssembleTank();
    return tank.build(context, root);
  }

  String _genXml(BuildContext context, String html) {
    final root = AssembleReader.fromSource(html);
    final tank = AssembleTank();
    return tank.gen(root);
  }
}

const _loading = const Center(
  child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(
      Colors.deepOrangeAccent,
    ),
  ),
);
