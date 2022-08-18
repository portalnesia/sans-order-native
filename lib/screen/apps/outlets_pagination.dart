import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sans_order/model/portalnesia/outlet.dart';
import 'package:sans_order/screen/outlet/outlet_card.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/appbar.dart';
import 'package:sans_order/widget/back.dart';
import 'package:sans_order/widget/pagination.dart';
import 'package:sans_order/widget/screen.dart';

class OutletPagination extends StatefulWidget {
  const OutletPagination({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppsState();
}

class _AppsState extends State<OutletPagination> {
  final RefreshController refreshController = RefreshController();
  final PagingController<int,IOutlet> pageController = PagingController(firstPageKey: 1);

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
      final items = await portalnesia.request<IOutlet>(Method.get, '/outlets?page=$pageKey&pageSize=12');
      final newItems = items.toPaginationModel(OutletModel());
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

  void onOutletClick(IOutlet toko) {
    showSnackbar("Outlet Clicked", 'ID: ${toko.id}');
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
                title: "Outlet",
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: const MyBackButton(),
                ),
              )),

              SliverList(delegate: SliverChildListDelegate([
                const SizedBox(height: 10,)
              ])),

              PagedSliverGrid<int,IOutlet>(pagingController: pageController,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: (200 / 70)
                ),
                showNoMoreItemsIndicatorAsGridChild: false,
                showNewPageErrorIndicatorAsGridChild: false,
                builderDelegate: CustomPagedChildBuilderDelegate(
                  itemType: "Outlet",
                  pagingController: pageController,
                  itemBuilder: ((_, item, __) => OutletCard(outlet: item,onClick: onOutletClick)),
                  newPageProgressIndicatorBuilder: (_) => OutletCard.shimmer(_),
                  firstPageProgressIndicatorBuilder: (_) => Column(children: [
                    Row(children: [
                      OutletCard.shimmer(context),
                      OutletCard.shimmer(context),
                    ]),
                    Row(children: [
                      OutletCard.shimmer(context),
                      OutletCard.shimmer(context),
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