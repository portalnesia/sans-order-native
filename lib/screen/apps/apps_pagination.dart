import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sans_order/model/portalnesia/toko.dart';
import 'package:sans_order/screen/apps/home.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/appbar.dart';
import 'package:sans_order/widget/back.dart';
import 'package:sans_order/widget/pagination.dart';
import 'package:sans_order/widget/screen.dart';
import 'package:shimmer/shimmer.dart';

class AppsPagination extends StatefulWidget {
  const AppsPagination({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppsState();
}

class _AppsState extends State<AppsPagination> {
  final RefreshController refreshController = RefreshController();
  final PagingController<int,IToko> pageController = PagingController(firstPageKey: 1);
  String type = 'toko';
  String typeLabel = 'Merchant';

  @override
  void initState() {
    final type = Get.parameters['type'];
    if(type is String && ['toko','outlet'].contains(type)) {
      setState(() {
        this.type = type;
        typeLabel = type == 'toko' ? 'Merchant' : type;
      });
    } else {
      backAction();
    }
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
      final items = await portalnesia.request<IToko>(Method.get, '/toko?page=$pageKey&per_page=12&type=$type');
      final newItems = items.toPaginationModel(TokoModel());
      if(newItems.meta.pagination.page <= newItems.meta.pagination.pageCount) {
        pageController.appendPage(newItems.data, newItems.meta.pagination.page+1);
      } else {
        pageController.appendLastPage(newItems.data);
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
                title: typeLabel.capitalizeFirst ?? typeLabel,
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
                ),
                showNoMoreItemsIndicatorAsGridChild: false,
                showNewPageErrorIndicatorAsGridChild: false,
                builderDelegate: CustomPagedChildBuilderDelegate(
                  itemType: typeLabel,
                  pagingController: pageController,
                  itemBuilder: ((_, item, __) => _TokoCard(toko: item)),
                  newPageProgressIndicatorBuilder: (_) => _TokoCard.shimmer(_),
                  firstPageProgressIndicatorBuilder: (_) => Column(children: [
                    Row(children: [
                      _TokoCard.shimmer(context),
                      _TokoCard.shimmer(context),
                    ]),
                    Row(children: [
                      _TokoCard.shimmer(context),
                      _TokoCard.shimmer(context),
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

class _TokoCard extends StatelessWidget {
  final IToko toko;

  const _TokoCard({Key? key,required this.toko}) : super(key: key);

  void onClick() {
    showSnackbar("Toko Clicked", 'ID: ${toko.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: cardBorder,
      child: InkWell(
        onTap: onClick,
        borderRadius: cardRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: photoUrl(toko.logo?.url),height: 100,width: double.infinity,fit: BoxFit.fitWidth,cacheKey: 'toko_${toko.id}_card',),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text((toko.name),style: context.theme.textTheme.headline6),
            ),
          ]
        ),
      ),
    );
  }

  static Widget shimmer(BuildContext context) => SizedBox(
    width: Get.width/2,
    child: Card(
      elevation: 0,
      shape: cardBorder,
      child: Shimmer.fromColors(
        baseColor: context.theme.scaffoldBackgroundColor, 
        highlightColor: context.theme.textTheme.caption!.color!.withAlpha(50),
        child: Column(children: [
          Container(
            width: 200,
            height: 100,
            color: context.theme.cardColor,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 180,
              height: 20,
              color: context.theme.cardColor,
            ),
          )
        ]),
      )
    )
  );
}