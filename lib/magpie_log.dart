import 'package:flutter/material.dart';

import 'file/data_analysis.dart';

//TODO:release modify
//const bool isDebug = const bool.fromEnvironment("dart.vm.product");
const bool globalIsDebug = true;
const bool globalIsPageLogOn = true;
const String globalClientId = "com.wuba.flutter.magpie_log";

typedef LogCallBack = Function(String actionName, Map content);

class MagpieLog {
  // 工厂模式
  factory MagpieLog() => _getInstance();

  static MagpieLog get instance => _getInstance();
  static MagpieLog _instance;

  MagpieLog._internal() {
    // 初始化
  }

  BuildContext logContext;
  LogCallBack logCallBack;

  bool isDebug = globalIsDebug;
  bool isPageLogOn = globalIsPageLogOn;
  List<Route<dynamic>> routeStack = List();

  static bool _isInit = false;

  static MagpieLog _getInstance() {
    if (_instance == null) {
      _instance = new MagpieLog._internal();
    }
    return _instance;
  }

  init(BuildContext context, LogCallBack callBack) {
    //TODO 暂时还没有更好的办法来处理某些只需要初始化一次的函数
    if (!_isInit) {
      logCallBack = callBack;
      logContext = context;
      MagpieDataAnalysis().initMagpieData(context); //初始化圈选数据
      _isInit = true;
    }
  }

  String getCurrentPath() {
    return getCurrentRoute().settings.name;
  }

  Route getCurrentRoute() {
    return routeStack[MagpieLog.instance.routeStack.length - 1];
  }
}

abstract class LogState {
  int get logStatus => _logStatus;
  int _logStatus;

  Map<String, dynamic> toJson();
}

class LogAction {
  static LogAction setUp(actionName, index, actionParams) {
    return LogAction(actionName, index: index, actionParams: actionParams);
  }

  LogAction(this.actionName, {this.index, this.actionParams});

  String actionName;
  int index; //用于列表页position
  Map actionParams; //action拓展参数
}
