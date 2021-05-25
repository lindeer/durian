import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml_widget/exe_engine.dart';
import 'package:xml_widget/xml_widget.dart';
import 'name_card.dart';

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
      home: ExeEngineWidget(
        engine: ScriptEngine(code: """
let size = 0;
let message = '';
let details = [
 { text: "t11",}
];
function onFloatButtonClick() {
  size++;
  if (size > 1) size = -1;
  console.log(`js: size=\${size}`);
  notifyChange(["size"]);
}

function onMessageButtonClick() {
  details.push({
    text: `t\${details.length}`,
  });
  notifyChange(["details"]);
}
        """),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _ByteDataSink implements Sink<ByteData> {
  final Sink<List<int>> sink;

  _ByteDataSink(this.sink);
  @override
  void add(ByteData data) {
    sink.add(data.buffer.asInt8List());
  }

  @override
  void close() {
    sink.close();
  }
}

class _BDConverter extends Converter<ByteData, List<int>> {
  const _BDConverter();

  @override
  List<int> convert(ByteData input) => input.buffer.asInt8List();

  @override
  Sink<ByteData> startChunkedConversion(Sink<List<int>> sink) {
    return _ByteDataSink(sink);
  }
}

const _bd = const _BDConverter();

final _loading = Container(
  color: Colors.white,
  constraints: const BoxConstraints.tightFor(
    width: 128,
    height: 128,
  ),
  alignment: Alignment.center,
  child: const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(
      Colors.deepOrangeAccent,
    ),
  ),
);

class _MyHomePageState extends State<MyHomePage> {

  void _onPressed(String uri) {
    print("onPressed: $uri");
    final engine = ExeEngineWidget.of(context);
    engine.eval('$uri();');
  }

  @override
  Widget build(BuildContext context) {
    final assembler = WidgetAssembler(
      buildContext: context,
      onPressed: _onPressed,
    );

    return FutureBuilder(
      future: rootBundle.loadString('assets/app.xml').then((s) => assembler.fromSource(s)),
      initialData: _loading,
      builder: (ctx, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Text('error: ${snapshot.error}\n${snapshot.stackTrace}'),
              ),
            );
          } else {
            return Material(
              child: snapshot.requireData,
            );
          }
        } else {
          return _loading;
        }
      },
    );
  }
}
