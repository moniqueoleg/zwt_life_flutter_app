import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zwt_life_flutter_app/common/manager/settingmanager.dart';
import 'package:zwt_life_flutter_app/public.dart';

class BookShelfPage extends StatefulWidget {
  static final String sName = "BookShelf";

  @override
  _BookShelfPageState createState() {
    // TODO: implement createState
    return _BookShelfPageState();
  }
}

class _BookShelfPageState extends State<BookShelfPage>
    with AutomaticKeepAliveClientMixin {
  List<RecommendBooks> recommendBooksList = new List();
  RefreshController _refreshController;
  ScrollController _scrollController;
  final SlidableController slidableController = new SlidableController();

  @override
  void initState() {
    _refreshController = new RefreshController();
    _scrollController = new ScrollController();
    Future.delayed(Duration(seconds: 1), () {
      checkNewUser(context);
    });
    super.initState();
  }

  void scrollTop() {
    _scrollController.animateTo(0.0,
        duration: new Duration(microseconds: 1000), curve: ElasticInCurve());
  }

  void enterRefresh() {
    _refreshController.requestRefresh(true);
  }

  returnUserItem(RecommendBooks item) {
    return new GestureDetector(
      child: new Slidable(
        controller: slidableController,
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.1,
        child: new Container(
          decoration: new BoxDecoration(
              border: new BorderDirectional(
                  bottom:
                      new BorderSide(color: Color(0xFFe1e1e1), width: 1.0))),
          child: InkWell(
            splashColor: Colors.grey,
            onTap: () {
              NavigatorUtils.gotoMessageTalkingPage(context);
            },
            child: new ListTile(
              leading: new ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image(
                  image: NetworkImage(Constant.IMG_BASE_URL + '${item.cover}'),
                  width: ScreenUtil.getInstance().L(50),
                  height: ScreenUtil.getInstance().L(50),
                ),
              ),
              title: new Text('${item.title}'),
              subtitle: new Text(
                '${item.lastChapter}',
                style: TextStyle(fontSize: 11),
              ),
//              trailing: new Text('${item.updated}'),
            ),
          ),
        ),
        secondaryActions: <Widget>[
          new IconSlideAction(
              foregroundColor: Colors.grey,
              color: Colors.grey[50],
              caption: '缓存',
              icon: Icons.file_download,
              onTap: () {}),
          new IconSlideAction(
              foregroundColor: Colors.grey,
              color: Colors.grey[50],
              caption: '养肥', icon: Icons.collections_bookmark, onTap: () {}),
          new IconSlideAction(
              foregroundColor: Colors.grey,
              color: Colors.grey[50],
              caption: '置顶', icon: Icons.vertical_align_top, onTap: () {}),
          new IconSlideAction(
            caption: '删除',
            foregroundColor: Colors.red,
            color: Colors.grey[50],
            icon: Icons.delete_outline,
            onTap: () => ToastUtils.info(context, '成功删除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('书架'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Semantics(
            child: IconButton(
                onPressed: () => {},
                icon: Icon(CupertinoIcons.search, color: Colors.black)),
          ),
        ),
      ),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: SafeArea(
          child: Center(
            child: CupertinoScrollbar(
                child: SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: (up) {
                      if (up) {
                        new Future.delayed(const Duration(milliseconds: 2009))
                            .then((val) {
                          setState(() {
                            _refreshController.sendBack(
                                true, RefreshStatus.completed);
                          });
                        });
                      } else {
                        new Future.delayed(const Duration(milliseconds: 2009))
                            .then((val) {
                          setState(() {
                            _refreshController.sendBack(
                                false, RefreshStatus.idle);
                          });
                        });
                      }
                    },
                    child: new ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: recommendBooksList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return returnUserItem(recommendBooksList[index]);
                        }))),
          ),
        ),
      ),
    );
  }

  void checkNewUser(BuildContext context) {
    if (!SettingManager.getInstance().isUserChooseSex()) {
      CommonUtils.showLickeDialog(context, () {
        setSex(Constant.MALE);
      }, () {
        setSex(Constant.FEMALE);
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  setSex(String sex) async {
    Navigator.pop(context);
//    SettingManager.getInstance().saveUserChooseSex(sex);
    Data data = await dioGetRecommend(sex);
    if (data.result && data.data.toString().length > 0) {
      setState(() {
        recommendBooksList = data.data;
      });
    }
  }
}
