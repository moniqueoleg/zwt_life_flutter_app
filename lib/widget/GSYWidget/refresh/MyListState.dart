import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zwt_life_flutter_app/widget/GSYWidget/refresh/PullLoadWidgetControl.dart';

mixin MyListState<T extends StatefulWidget>
    on State<T>, AutomaticKeepAliveClientMixin<T> {
   final  String TAG = "MyListState: ";
   bool isShow = false;

   bool isLoading = false;

   int page = 1;

   int pageTotal = 2;

   final List dataList = new List();

   final PullLoadWidgetControl pullLoadWidgetControl = new PullLoadWidgetControl();

   final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

   showRefreshLoading() {
     new Future.delayed(const Duration(seconds: 1), () {
//       refreshIndicatorKey.currentState.show().then((e) {});
       return true;
     });
   }

   @protected
   resolveRefreshResult(res) {
     if (res != null && res.result) {
       pullLoadWidgetControl.dataList.clear();
       if (isShow) {
         setState(() {
           pullLoadWidgetControl.dataList.addAll(res.data);
         });
       }
     }
   }

   @protected
   Future<Null> handleRefresh() async {
     if (isLoading) {
       return null;
     }
     isLoading = true;
     page = 1;
     var res = await requestRefresh();
     resolveRefreshResult(res);
     resolveDataResult(res);
     if (res != null) {
       var resNext = await res;
       resolveRefreshResult(resNext);
       resolveDataResult(resNext);
     }
     isLoading = false;
     return null;
   }

   @protected
   Future<Null> onLoadMore() async {
     if (isLoading ) {
       return null;
     }
     isLoading = true;
     page++;
     var res = await requestLoadMore();
     if (res != null && res.result) {
       if (isShow) {
         setState(() {
           pullLoadWidgetControl.dataList.addAll(res.data);
         });
       }
     }
     resolveDataResult(res);
     isLoading = false;
     return null;
   }

   @protected
   resolveDataResult(res) {
     if (isShow) {
       setState(() {
         pullLoadWidgetControl.needLoadMore = (res != null && res.data != null && page < pageTotal);
       });
     }
   }

   @protected
   clearData() {
     if (isShow) {
       setState(() {
         pullLoadWidgetControl.dataList.clear();
       });
     }
   }

   ///下拉刷新数据
   @protected
   requestRefresh() async {}

   ///上拉更多请求数据
   @protected
   requestLoadMore() async {}

   ///是否需要第一次进入自动刷新
   @protected
   bool get isRefreshFirst;

   ///是否需要头部
   @protected
   bool get needHeader => false;

   ///是否需要保持
   @override
   bool get wantKeepAlive => true;

   List get getDataList => dataList;

   @override
   void initState() {
     isShow = true;
     super.initState();
     pullLoadWidgetControl.needHeader = needHeader;
     pullLoadWidgetControl.dataList = getDataList;
     if (pullLoadWidgetControl.dataList.length == 0 && isRefreshFirst) {
       showRefreshLoading();
     }
   }

   @override
   void dispose() {
     isShow = false;
     isLoading = false;
     super.dispose();
   }
}
