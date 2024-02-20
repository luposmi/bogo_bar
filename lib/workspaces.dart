import 'package:bogo_bar/hyprlandProvider.dart';
import 'package:bogo_bar/workspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Workspaces extends StatefulWidget {
  Workspaces({Key? key}) : super(key: key);

  @override
  _WorkspacesState createState() => _WorkspacesState();
}

class _WorkspacesState extends State<Workspaces> {
  List<Key> keys = [];
  Key key = UniqueKey();
  @override
  void initState() {
    for(int i = 0; i<HyprlandProvider().getBorderType().length ; i++){
      keys.add(UniqueKey());
    }
    super.initState();
  }
  BorderType type = BorderType.alone;
  //static const int widgetCount = 3;
  
  Widget getWorkspaces(){
    List<Widget> workspaces = [];
    List<BorderType> borderTypes = HyprlandProvider().getBorderType();
    int currentActive = HyprlandProvider().getCurrent();
    for (int i =0; i<borderTypes.length; i++){
      workspaces.add(Workspace(isActive: true,symbol: Text((i+1).toString()),type: borderTypes[i],key: keys[i],wasClicked: (){}, isCurrent: i == currentActive-1,));

    }
    
    
    return Row(children: workspaces,);
  }
  
  @override
  Widget build(BuildContext context) {

        //HyprlandProvider().getInformationWorkspaces();
    Future.delayed(Duration(milliseconds: 1000)).then((value ){setState((){});});

    //return Workspace(isActive: true,symbol: Text(5.toString()),type: type,key: key);
    return  Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withAlpha(100),borderRadius: BorderRadius.all(Radius.circular(999))),
      padding: EdgeInsets.all(5),

      child: getWorkspaces());
  }
}


enum BorderType{
  disabled,
  alone,
  left,
  right,
  both
}