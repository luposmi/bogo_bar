import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

import 'workspaces.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final waylandLayerShellPlugin = WaylandLayerShell();
  bool isSupported = await waylandLayerShellPlugin.initialize(500, 40);
  if (!isSupported) {
    runApp(const MaterialApp(home: Center(child: Text('Not supported'))));
    return;
  }
  await waylandLayerShellPlugin
      .setKeyboardMode(ShellKeyboardMode.keyboardModeNone);
  await waylandLayerShellPlugin.setAnchor(ShellEdge.edgeTop, true);
  await waylandLayerShellPlugin.setAnchor(ShellEdge.edgeLeft, true);
  await waylandLayerShellPlugin.setAnchor(ShellEdge.edgeRight, true);
  await waylandLayerShellPlugin.enableAutoExclusiveZone();
  await waylandLayerShellPlugin.setMargin(ShellEdge.edgeTop, 5);
  await waylandLayerShellPlugin.setMargin(ShellEdge.edgeRight, 5);
  await waylandLayerShellPlugin.setMargin(ShellEdge.edgeLeft, 5);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 223, 132, 218), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void setExclusiveZone() async {
    const methodChannel = MethodChannel('wayland_layer_shell');

    Map<String, dynamic> arguments = {
      'width': 1280,
      'height': 720,
    };
    await methodChannel.invokeMethod('enableAutoExclusiveZone');

    arguments = {
      'layer': 0,
    };

    await methodChannel.invokeMethod('setLayer', arguments);
    arguments = {'edge': 1, 'margin_size': 100};
    await methodChannel.invokeMethod('setMargin', arguments);
  }

  @override
  void initState() {
    //setExclusiveZone();
    super.initState();
  }

  Widget bar(Widget left, Widget center, Widget right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: left,
        ),
        Expanded(child:Center(
          child: center,
        )),
        Container(
          alignment: Alignment.centerRight,
          child: right,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(999999)),
            border: Border.all(color: Colors.transparent),
            color: Colors.transparent),
        child: Scaffold(
            backgroundColor:
                Theme.of(context).colorScheme.background.withAlpha(0),
            body: bar(Workspaces(), Text("asd"), Text("asd"))));
  }
}
