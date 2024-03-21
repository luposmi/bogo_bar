import 'dart:convert';
import 'dart:io';

import 'package:bogo_bar/workspaceProvider.dart';

class HyprlandProvider extends WorkspaceProvider{
  @override
  List<bool> getIsActive() {
    List<Map<String, dynamic>> workspaces = getInformationWorkspaces()!;
    List<bool> isActive= [];
    for(Map<String, dynamic> workspace in workspaces){
      isActive.add( (workspace["windows"] != 0));
    }
    return isActive;
  }
  int getCurrent(){
  ProcessResult processResult = Process.runSync('hyprctl', ['activeworkspace', '-j']);
  if (processResult.exitCode != 0){
    return 1;
  }
    Map<String, dynamic> current = Map<String, dynamic>.from(json.decode(processResult.stdout));
    return (current["id"]);


  }
  HyprlandProvider(){
    startReading();
  }
  startReading() async{
    var hyprlandInstanceSignature = Platform.environment['HYPRLAND_INSTANCE_SIGNATURE'];
    if (hyprlandInstanceSignature == null) {
      throw Exception();
    }

    var socketPath = "/tmp/hypr/$hyprlandInstanceSignature/.socket2.sock";
    final host = InternetAddress(socketPath, type: InternetAddressType.unix);
    var socket = await Socket.connect(host,0);

   socket.listen((List<int> data) {
         doCallbacks();
    //print('Received: ${String.fromCharCodes(data)}');
  });
  }


  List<Map<String,dynamic>>? getInformationWorkspaces(){

  ProcessResult processResult = Process.runSync('hyprctl', ['workspaces', '-j']);
  if (processResult.exitCode != 0){
    return null;
  }
  List<Map<String, dynamic>> workspaceWindows = List<Map<String, dynamic>>.from(json.decode(processResult.stdout));
  Map<String, dynamic> workspaceWindowsMap = {};
  for (var workspace in workspaceWindows) {
    workspaceWindowsMap[workspace['id'].toString()] = workspace['windows'];
  }

  // Creating a list of workspace ids from 1 to 10
  List<int> workspaceIds = List<int>.generate(10, (index) => index + 1);

  // Creating a list of workspace objects containing id and windows information
  List<Map<String, dynamic>> result = [];
  for (var id in workspaceIds) {
    Map<String, dynamic> workspace = {
      'id': id.toString(),
      'windows': workspaceWindowsMap[id.toString()] ?? 0,
    };
    result.add(workspace);
  }
  return result;
  }

}
