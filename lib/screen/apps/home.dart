import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sans_order/model/portalnesia/toko.dart';
import 'package:sans_order/screen/apps/logout.dart';
import 'package:sans_order/screen/apps/setting.dart';
import 'package:sans_order/screen/apps/transitionappbar.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/pagination.dart';
import 'package:sans_order/widget/version.dart';
import 'package:shimmer/shimmer.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppsScreen> {
  final RefreshController refreshController = RefreshController();
  final PagingController<int,IToko> tokoController = PagingController(firstPageKey: 1);
  final PagingController<int,IToko> outletController = PagingController(firstPageKey: 1);

  Future<void> _getMerchant(int pageKey) async {
    try {
      final newItems = await portalnesia.request(TokoModel(), Method.get, '/toko?per_page=5&type=toko');
      if(newItems.data.isNotEmpty) {
        newItems.data.add(IToko(id: 0, name: '', slug: 'toko'));
      }
      tokoController.appendLastPage(newItems.data);
    } catch (error) {
      if(error is PortalnesiaException) tokoController.error = error.message;
    }
  }

  Future<void> _getOutlet(int pageKey) async {
    try {
      final newItems = await portalnesia.request(TokoModel(), Method.get, '/toko?per_page=5&type=outlet');
      if(newItems.data.isNotEmpty) {
        newItems.data.add(IToko(id: 0, name: '', slug: 'outlet'));
      }
      outletController.appendLastPage(newItems.data);
    } catch (error) {
      if(error is PortalnesiaException) outletController.error = error.message;
    }
  }

  @override
  void initState() {
    tokoController.addPageRequestListener((pageKey) {
      _getMerchant(pageKey);
    });
    outletController.addPageRequestListener((pageKey) {
      _getOutlet(pageKey);
    });
    tokoController.addStatusListener((status) {
      if(status == PagingStatus.completed) refreshController.refreshCompleted();
    });
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    tokoController.dispose();
    outletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      header: const CustomClassicHeader(),
      onRefresh: () {
        tokoController.refresh();
        outletController.refresh();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TransitionAppBarDelegate(
              extent:200
            ),
          ),
           
          SliverList(
            delegate: 
              //SliverChildBuilderDelegate((_,i) => const HomeScreen())
              SliverChildListDelegate([
                HomeScreen(tokoController: tokoController,outletController: outletController,)
              ]),
          )
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final PagingController<int,IToko> tokoController;
  final PagingController<int,IToko> outletController;

  const HomeScreen({Key? key,required this.tokoController,required this.outletController}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

BorderRadius borderRadius = const BorderRadius.all(Radius.circular(15));
ShapeBorder shapeBorder = RoundedRectangleBorder(borderRadius: borderRadius);
BorderRadius cardRadius = const BorderRadius.vertical(bottom: Radius.circular(15));
ShapeBorder cardBorder = RoundedRectangleBorder(borderRadius: cardRadius);

class _HomeState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              SettingButton(borderRadius: borderRadius, shapeBorder: shapeBorder),
              LogoutButton(borderRadius: borderRadius, shapeBorder: shapeBorder)
            ]
          ),
          const SizedBox(height: 30,),

          Align(alignment: Alignment.centerLeft,child: Text('owned_merchant'.tr,style: context.theme.textTheme.headline3,),),
          const Divider(),

          SizedBox(
            height: 170,
            child: PagedListView<int,IToko>.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              pagingController: widget.tokoController, 
              builderDelegate: CustomPagedChildBuilderDelegate(
                pagingController: widget.tokoController,
                itemBuilder: ((_, item, __) => _TokoCard(toko: item)),
                firstPageProgressIndicatorBuilder: (_) => Row(children: [
                  _TokoCard.shimmer(context),
                  _TokoCard.shimmer(context),
                  _TokoCard.shimmer(context)
                ])
              ), 
              separatorBuilder: (_,__) => const SizedBox(width: 5,),
            ),
          ),

          const SizedBox(height: 30,),

          Align(alignment: Alignment.centerLeft,child: Text('managed_merchant'.tr,style: context.theme.textTheme.headline3,),),
          const Divider(),

          SizedBox(
            height: 170,
            child: PagedListView<int,IToko>.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              pagingController: widget.outletController, 
              builderDelegate: CustomPagedChildBuilderDelegate(
                pagingController: widget.outletController,
                itemBuilder: ((_, item, __) => _TokoCard(toko: item)),
                firstPageProgressIndicatorBuilder: (_) => Row(children: [
                  _TokoCard.shimmer(context),
                  _TokoCard.shimmer(context),
                  _TokoCard.shimmer(context)
                ])
              ), 
              separatorBuilder: (_,__) => const SizedBox(width: 5,),
            ),
          ),

          const SizedBox(height: 30,),
          Version(textColor: context.theme.textTheme.bodyText2!.color)
        ],
      )
    );
  }
}

class _TokoCard extends StatelessWidget {
  final IToko toko;

  const _TokoCard({Key? key,required this.toko}) : super(key: key);

  void onClick() {
    showSnackbar("Toko Clicked", 'ID: ${toko.id}');
  }

  void viewMoreClick() {
    Get.toNamed('/apps/lists?type=${toko.slug}');
  }
  
  @override
  Widget build(BuildContext context) {
    if(toko.id == 0) {
      return SizedBox(
        width: 200,
        child: Card(
          elevation: 0,
          shape: cardBorder,
          child: InkWell(
            onTap: viewMoreClick,
            borderRadius: cardRadius,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 10),child: Icon(Icons.read_more,size: 50,color: Colors.grey,)),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('view_all'.tr,style: context.theme.textTheme.headline6),
                ),

              ]
            ),
          ),
        ),
      );
    }
    
    return SizedBox(
      width: 200,
      child: Card(
        elevation: 0,
        shape: cardBorder,
        child: InkWell(
          onTap: onClick,
          borderRadius: cardRadius,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(imageUrl: '${photoUrl(toko.logo)}&watermark=no&export=banner&size=300&no_twibbon=true',height: 100,width: double.infinity,fit: BoxFit.fitWidth,cacheKey: 'toko_${toko.id}_card',),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text((toko.name),style: context.theme.textTheme.headline6,overflow: TextOverflow.ellipsis,maxLines: 2),
              ),

            ]
          ),
        ),
      ),
    );
  }

  static Widget shimmer(BuildContext context) => Card(
    elevation: 0,
    shape: cardBorder,
    child: Shimmer.fromColors(
      baseColor: context.theme.scaffoldBackgroundColor, 
      highlightColor: context.theme.textTheme.caption!.color!,
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
  );
}