import 'package:bogo_bar/hyprlandProvider.dart';
import 'package:bogo_bar/workspacesWidget.dart';
import 'package:meta/meta.dart';
/// if return is false, remove the callback.
typedef WorkspaceUpdateCallback = bool Function(List<BorderType>);

abstract class WorkspaceProvider{
  static WorkspaceProvider? _instance;
  final List<WorkspaceUpdateCallback> _callbacks = [];
  final List<Workspace> _workspaces = [];
  List<Workspace> get workspaces => _workspaces;
    static WorkspaceProvider get instance {
    _instance ??= HyprlandProvider();
    return _instance!;
  }

  List<bool> getIsActive();
  List<BorderType> getBorderType(){
    List<BorderType> borderType = [];
    List<bool> activeWorkspaces = getIsActive();

    for(int i = 0; i< activeWorkspaces.length; i++){
      if( !activeWorkspaces[i]){
        borderType.add(BorderType.disabled);
      }else{

        bool leftIsActive = (i-1 >= 0)? activeWorkspaces[i-1]: false;
        bool rightIsActive = (i+1 <activeWorkspaces.length)? activeWorkspaces[i+1]: false;
        if( leftIsActive & rightIsActive){
          borderType.add(BorderType.both);
        }else if(leftIsActive){
          borderType.add(BorderType.left);
        }else if(rightIsActive){
          borderType.add(BorderType.right);
        }else{
          borderType.add(BorderType.alone);
        }
      }
    }
    return borderType;
  }

  void addUpdateCallback(WorkspaceUpdateCallback callback){
    _callbacks.add(callback);
  }
  void removeCallback(WorkspaceUpdateCallback callback){
    _callbacks.remove(callback);
  }
  @protected
  void doCallbacks(){
    List<BorderType> activeWorkspaces = getBorderType();
    List<WorkspaceUpdateCallback> toRemove = [];
    for(WorkspaceUpdateCallback callback in _callbacks){
      bool result = callback(activeWorkspaces);
      if (!result){
        toRemove.add(callback);
      }
    }
    toRemove.forEach((element) {_callbacks.remove(element);});
  }
}



class Workspace{
  int id;
  String name;
  int activeWindows;
  bool isCurrent;
  Workspace({required this.id, required this.name, required this.activeWindows,this.isCurrent = false} );
}
