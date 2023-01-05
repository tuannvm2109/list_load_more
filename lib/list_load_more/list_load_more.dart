import 'package:flutter/material.dart';
import 'package:list_load_more/components/list_shimmer_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../components/container_loading.dart';
import '../components/empty_widget.dart';
import '../components/error_widget.dart';
import '../components/loading_more_widget.dart';

enum ListLoadMoreStatus {
  loadRefresh,
  loadMore,
  none,
  error,
}

class ListLoadMore<T> extends StatefulWidget {
  const ListLoadMore({
    Key? key,
    this.onRefresh,
    this.onLoadMore,
    this.emptyWidget,
    this.errorWidget,
    required this.itemBuilder,
    this.scrollDirection,
    this.shimmerWidget,
    this.total = 0,
    this.status = ListLoadMoreStatus.none,
    this.loadingMoreWidget,
  }) : super(key: key);

  final VoidCallback? onRefresh;
  final void Function(int skip)? onLoadMore;
  final num total;
  final ListLoadMoreStatus status;

  final Widget? emptyWidget;
  final Widget? loadingMoreWidget;
  final Widget? errorWidget;
  final Widget? shimmerWidget;
  final Widget Function(T t, int index) itemBuilder;
  final Axis? scrollDirection;

  @override
  ListLoadMoreState<T> createState() => ListLoadMoreState<T>();
}

class ListLoadMoreState<T> extends State<ListLoadMore<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late AutoScrollController _controller;
  late List<T> listData;

  int _deletedItemCount = 0;
  int _addedItemCount = 0;

  final ValueNotifier<bool> _isLoadingMore = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    listData = [];
    _controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerLoading(
      isLoading: widget.status == ListLoadMoreStatus.loadRefresh,
      loadingWidget: widget.shimmerWidget ?? const ListShimmerWidget(),
      child: _mainWidget(),
    );
  }

  Widget _mainWidget() {
    switch (widget.status) {
      case ListLoadMoreStatus.loadRefresh:
        return const SizedBox();
      case ListLoadMoreStatus.error:
        Widget errorWidget = const ErrorListWidget();
        final screenHeight = MediaQuery.of(context).size.height;
        return _wrapWidgetRefresh(SizedBox(
          width: double.infinity,
          height: 0.7 * screenHeight,
          child: errorWidget,
        ));
      case ListLoadMoreStatus.loadMore:
      case ListLoadMoreStatus.none:
        if (widget.total == 0) {
          return _wrapWidgetRefresh(
            widget.emptyWidget ??
                SizedBox(
                    width: double.infinity,
                    child: EmptyWidget(onTapReload: _refresh)),
          );
        } else {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: _listViewWidget(),
          );
        }
    }
  }

  Widget _wrapWidgetRefresh(Widget child) {
    return ScrollConfiguration(
      behavior: _NoGlowBehavior(),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), child: child),
      ),
    );
  }

  Widget _listViewWidget() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: ValueListenableBuilder<bool>(
        builder: (BuildContext context, bool value, Widget? child) {
          return AnimatedList(
            key: _listKey,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: _controller,
            padding: EdgeInsets.zero,
            scrollDirection: widget.scrollDirection ?? Axis.vertical,
            initialItemCount: listData.length + 1,
            itemBuilder: (_, index, animation) {
              if (index < listData.length) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _controller,
                  index: index,
                  child: _buildItem(index, animation),
                );
                //
                // return _buildItem(index, animation);
              } else {
                return value
                    ? widget.loadingMoreWidget ??
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: LoadingMoreWidget(size: 40),
                        )
                    : const SizedBox();
              }
            },
          );
        },
        valueListenable: _isLoadingMore,
      ),
    );
  }

  Widget _buildItem(int index, Animation<double> animation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.5, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(animation),
        child: widget.itemBuilder.call(listData[index], index),
      ),
    );
  }

  void _scrollListener() async {
    if (_isLoadingMore.value) return;
    if (_controller.position.extentAfter < 150 &&
        listData.length <
            (widget.total + _addedItemCount - _deletedItemCount)) {
      await _loadMoreData();
    } else {
      return;
    }
  }

  Future<void> _loadMoreData() async {
    _isLoadingMore.value = true;
    widget.onLoadMore
        ?.call(listData.length + _deletedItemCount - _addedItemCount);
  }

  void focusToIndex(int index) {
    _controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }

  void addData(List<T>? list) {
    if (list == null) return;
    _isLoadingMore.value = false;

    if (list.isEmpty) {
      clearData();
      return;
    }

    // final newItems = list.sublist(listData.length);

    final oldLength = listData.length + 1;
    final newLength = listData.length + list.length;
    listData.addAll(list);

    for (var index = oldLength; index <= newLength; index++) {
      _listKey.currentState
          ?.insertItem(index, duration: const Duration(milliseconds: 300));
    }
  }

  void clearData() {
    for (var i = 0; i <= listData.length - 1; i++) {
      _listKey.currentState?.removeItem(0,
          (BuildContext context, Animation<double> animation) => Container());
    }
    listData.clear();
  }

  Future<void> _refresh() async {
    clearData();
    widget.onRefresh?.call();
  }

  void addItem({
    int index = 0,
    required T item,
  }) {
    listData.insert(index, item);
    _listKey.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 300));
    _addedItemCount++;
  }

  void removeItem({
    required int index,
  }) {
    listData.removeAt(index);
    _listKey.currentState?.removeItem(
        0, (BuildContext context, Animation<double> animation) => Container());
    _deletedItemCount++;
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
