import 'package:bogo_bar/hyprlandProvider.dart';
import 'package:bogo_bar/workspaceProvider.dart';
import 'package:bogo_bar/workspaceWidget.dart';
import 'package:flutter/material.dart';

class Workspaces extends StatefulWidget {
  Workspaces({Key? key}) : super(key: key);

  @override
  _WorkspacesState createState() => _WorkspacesState();
}

class _WorkspacesState extends State<Workspaces> {
  List<Key> keys = [];
  late List<BorderType> borderType;
  Key key = UniqueKey();
  @override
  void initState() {
    borderType = WorkspaceProvider.instance.getBorderType();
    for (int i = 0; i < borderType.length; i++) {
      keys.add(UniqueKey());
    }
    WorkspaceProvider.instance.addUpdateCallback((t) {
      setState(() {
        borderType = t;
      });
      return true;
    });
    super.initState();
  }

  BorderType type = BorderType.alone;

  Widget getWorkspaces() {
    List<Widget> workspaces = [];
    int currentActive = HyprlandProvider().getCurrent();
    for (int i = 0; i < borderType.length; i++) {
      workspaces.add(WorkspaceWidget(
        isActive: true,
        symbol: Text(((i + 1) % 10).toString()),
        type: borderType[i],
        key: keys[i],
        wasClicked: () {},
        isCurrent: i == currentActive - 1,
      ));
    }

    return Row(
      children: workspaces,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background.withAlpha(100),
            borderRadius: BorderRadius.all(Radius.circular(999))),
        padding: EdgeInsets.all(5),
        child: getWorkspaces());
  }
}

enum BorderType { disabled, alone, left, right, both }
