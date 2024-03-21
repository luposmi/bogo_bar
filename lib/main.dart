import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

import 'workspacesWidget.dart';

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 223, 132, 218),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Stack(
      children: [
        Row(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: left,
          ),
          const Expanded(child: SizedBox())
        ]),
        Container(
          alignment:   Alignment.center,
          child: center,
        ),
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
            borderRadius: const BorderRadius.all(Radius.circular(999999)),
            border: Border.all(color: Colors.transparent),
            color: Colors.transparent),
        child: Scaffold(
            backgroundColor:
                Theme.of(context).colorScheme.background.withAlpha(0),
            body: bar(Workspaces(), Text("asd"), Text("asd"))));
  }
}
