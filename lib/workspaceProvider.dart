import 'package:bogo_bar/workspaces.dart';

abstract class WorkspaceProvider{
  List<bool> getIsActive();
  List<BorderType> getBorderType(){
    List<BorderType> borderType = [];
    List<bool> activeWorkspaces = getIsActive()!;

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
}