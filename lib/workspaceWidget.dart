import 'package:bogo_bar/workspacesWidget.dart';
import 'package:flutter/material.dart';

class WorkspaceWidget extends StatefulWidget {
  final Widget symbol;
  final BorderType type;
  final void Function() wasClicked;
  final bool isCurrent;
  WorkspaceWidget({Key? key,required bool isActive,required this.symbol, required this.type, required this.wasClicked, this.isCurrent = false}) : super(key: key);

  @override
  _WorkspaceWidgetState createState() => _WorkspaceWidgetState();
}

class _WorkspaceWidgetState extends State<WorkspaceWidget> {
  static const double size = 30;
  Color color = Colors.red;
  late BorderType type;
  
  @override
  void initState() {
    type = widget.type;
    super.initState();
  }
  Widget borderFromBorderType(Widget child, BorderType type, Color color){    
    BorderRadius? radius;
    const Radius rad = Radius.circular(size);
    switch (type){
      case BorderType.disabled:
      case BorderType.alone : {radius = const BorderRadius.all(rad);}
      case BorderType.both: {radius = null;}
      case BorderType.right: {radius = const BorderRadius.only(topLeft:  rad,bottomLeft:  rad);}
      case BorderType.left: {radius = const BorderRadius.only(topRight:  rad,bottomRight:  rad);}


      default : {}
    }
    if (widget.isCurrent){
      //return Hero(tag: "currentActiveWindow", child: AnimatedContainer( duration: Duration(milliseconds:400), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer,borderRadius: radius ), child: child));
      return  AnimatedContainer( duration: const Duration(milliseconds:200), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,borderRadius: radius ), child: child);
    }
    return AnimatedContainer( duration: const Duration(milliseconds:200), decoration: BoxDecoration(color: type == BorderType.disabled ?null : color,borderRadius: radius ), child: child);
 
  }

  Widget workspaceRounding(Widget child){
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(shape: BoxShape.circle),

        child: child);
  }

  @override
  Widget build(BuildContext context) {
    return borderFromBorderType(workspaceRounding(widget.symbol), widget.type, Theme.of(context).colorScheme.primaryContainer);
  }
}
