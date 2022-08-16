import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sans_order/model/portalnesia/toko.dart';
import 'package:sans_order/screen/toko/toko_card.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/appbar.dart';
import 'package:sans_order/widget/back.dart';
import 'package:sans_order/widget/pagination.dart';
import 'package:sans_order/widget/screen.dart';

class AppsPagination extends StatefulWidget {
  const AppsPagination({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppsState();
}

class _AppsState extends State<AppsPagination> {
  final RefreshController refreshController = RefreshController();
  final PagingController<int,IToko> pageController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    pageController.addPageRequestListener((pageKey) {
      _getData(pageKey);
    });
    pageController.addStatusListener((status) {
      if(status == PagingStatus.completed) refreshController.refreshCompleted();
    });
    super.initState();
  }

  Future<void> _getData(int pageKey) async {
    try {
      final items = await portalnesia.request<IToko>(Method.get, '/tokos??page=$pageKey&pageSize=12');
      final newItems = items.toPaginationModel(TokoModel());
      if(newItems.meta.pagination.page == newItems.meta.pagination.pageCount) {
        pageController.appendLastPage(newItems.data);
      } else {
        pageController.appendPage(newItems.data, newItems.meta.pagination.page+1);
      }
    } catch (error) {
      pageController.error = error;
    }
  }

  @override
  void dispose() {
    refreshController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void onTokoClick(IToko toko) {
    //showSnackbar("Toko Clicked", 'ID: ${toko.id}');
    Get.toNamed("/apps/${toko.slug}");
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      //appBar: HomeAppbar(),
      body: Screen(
        child: SmartRefresher(
          controller: refreshController,
          header: const CustomClassicHeader(),
          onRefresh: () {
            pageController.refresh();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(pinned: true,delegate: SliversDelegate(
                title: "Merchant",
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: const MyBackButton(),
                ),
              )),

              SliverList(delegate: SliverChildListDelegate([
                const SizedBox(height: 10,)
              ])),

              PagedSliverGrid<int,IToko>(pagingController: pageController,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: (200 / 170)
                ),
                showNoMoreItemsIndicatorAsGridChild: false,
                showNewPageErrorIndicatorAsGridChild: false,
                builderDelegate: CustomPagedChildBuilderDelegate(
                  itemType: "Merchant",
                  pagingController: pageController,
                  itemBuilder: ((_, item, __) => TokoCard(toko: item,onClick: onTokoClick)),
                  newPageProgressIndicatorBuilder: (_) => TokoCard.shimmer(_),
                  firstPageProgressIndicatorBuilder: (_) => Column(children: [
                    Row(children: [
                      TokoCard.shimmer(context),
                      TokoCard.shimmer(context),
                    ]),
                    Row(children: [
                      TokoCard.shimmer(context),
                      TokoCard.shimmer(context),
                    ])
                  ])
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}