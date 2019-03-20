import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'package:zwt_life_flutter_app/common/event/HttpErrorEvent.dart';
import 'package:zwt_life_flutter_app/common/localization/DefaultLocalizations.dart';
import 'package:zwt_life_flutter_app/common/localization/GlobalLocalizationsDelegate.dart';
import 'package:zwt_life_flutter_app/common/model/User.dart';
import 'package:zwt_life_flutter_app/common/model/search_history.dart';
import 'package:zwt_life_flutter_app/common/net/Code.dart';
import 'package:zwt_life_flutter_app/common/redux/GlobalState.dart';
import 'package:zwt_life_flutter_app/common/style/GlobalStyle.dart';
import 'package:zwt_life_flutter_app/common/utils/CommonUtils.dart';
import 'package:zwt_life_flutter_app/common/utils/util/shared_preferences.dart';
import 'package:zwt_life_flutter_app/page/MainPage.dart';
import 'package:zwt_life_flutter_app/page/LoginPage.dart';
import 'package:zwt_life_flutter_app/page/WelcomePage.dart';

SpUtil sp;

void main() async {
  runApp(FlutterReduxApp());
  sp = await SpUtil.getInstance();
  new SearchHistoryList(sp);
  PaintingBinding.instance.imageCache.maximumSize = 100;
}

class FlutterReduxApp extends StatelessWidget {
  /// 创建Store，引用 GSYState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<GlobalState>(
    appReducer,

    ///初始化数据
    initialState: new GlobalState(
        userInfo: User.empty(),
        eventList: new List(),
        trendList: new List(),
        themeData: CommonUtils.getThemeData(GlobalColors.ThemeColor),
        locale: Locale('zh', 'CH')),
  );

  FlutterReduxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //通过StoreProvider应用store
    // TODO: implement build
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<GlobalState>(builder: (context, store) {
        return new MaterialApp(
          //多语言实现代理
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalLocalizationsDelegate.delegate,
          ],
          locale: store.state.locale,
          supportedLocales: [store.state.locale],
          theme: store.state.themeData,
          routes: {
            WelcomePage.sName: (context) {
              store.state.platformLocale = Localizations.localeOf(context);
              return WelcomePage();
            },
            LoginPage.sName: (context) {
              return new MyLocalizations(
                child: LoginPage(),
              );
            },
            MainPage.sName: (context) {
              return new MyLocalizations(
                child: MainPage(),
              );
            }
          },
        );
      }),
    );
  }
}

class MyLocalizations extends StatefulWidget {
  final Widget child;

  MyLocalizations({Key key, this.child}) : super(key: key);

  @override
  _MyLocalizations createState() {
    return new _MyLocalizations();
  }
}

class _MyLocalizations extends State<MyLocalizations> {
  StreamSubscription stream;

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GlobalState>(builder: (context, store) {
      ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return new Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    stream = Code.eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error);
        break;
      case 401:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_401);
        break;
      case 403:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_403);
        break;
      case 404:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_404);
        break;
      case Code.NETWORK_TIMEOUT:
        //超时
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_timeout);
        break;
      default:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_unknown +
                " " +
                message);
        break;
    }
  }
}
