import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sans_order/model/portalnesia/outlet.dart';
import 'package:sans_order/model/portalnesia/toko.dart';
import 'package:sans_order/screen/apps/logout.dart';
import 'package:sans_order/screen/apps/outlets_pagination.dart';
import 'package:sans_order/screen/apps/transitionappbar.dart';
import 'package:sans_order/screen/outlet/outlet_card.dart';
import 'package:sans_order/screen/toko/toko_card.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/pagination.dart';
import 'package:sans_order/widget/version.dart';
import 'package:sans_order/screen/apps/setting.dart';

import 'apps_pagination.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppsScreen> {
  final RefreshController refreshController = RefreshController();
  final PagingController<int,IToko> tokoController = PagingController(firstPageKey: 1);
  final PagingController<int,IOutlet> outletController = PagingController(firstPageKey: 1);

  Future<void> _getMerchant(int pageKey) async {
    try {
      final items = await portalnesia.request<IToko>(Method.get, '/tokos?pagination[page]=$pageKey');
      final newItems = items.toPaginationModel(TokoModel());
      if(newItems.data.isNotEmpty) {
        newItems.data.add(IToko(id: 0, name: '', slug: 'toko'));
      }
      tokoController.appendLastPage(newItems.data);
    } catch (error) {
      if(error is PortalnesiaException) tokoController.error = error;
    }
  }

  Future<void> _getOutlet(int pageKey) async {
    try {
      final items = await portalnesia.request<IOutlet>(Method.get, '/outlets?pagination[page]=$pageKey');
      final newItems = items.toPaginationModel(OutletModel());
      if(newItems.data.isNotEmpty) {
        newItems.data.add(IOutlet(block: false, busy: false, cod: false, id: 0, name: "", online_payment: false, self_order: false, table_number: false));
      }
      outletController.appendLastPage(newItems.data);
    } catch (error) {
      if(error is PortalnesiaException) outletController.error = error;
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
  final PagingController<int,IOutlet> outletController;

  const HomeScreen({Key? key,required this.tokoController,required this.outletController}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  void onTokoClick(IToko toko) {
    //showSnackbar("Toko Clicked", 'ID: ${toko.id}');
    Get.toNamed("/apps/${toko.slug}");
  }

  void viewMoreTokoClick(IToko toko) {
    Get.to(() => const AppsPagination());
  }

  void onOutletClick(IOutlet outlet) {
    showSnackbar("Outlet Clicked", 'ID: ${outlet.id}');
  }

  void viewMoreOutletClick(IOutlet outlet) {
    Get.to(() => const OutletPagination());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      child: Column(
        children: [
          Row(
            children: const [
              SettingButton(),
              LogoutButton()
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
                itemBuilder: ((_, item, __) => TokoCard(toko: item,onClick: onTokoClick,viewMoreClick: viewMoreTokoClick)),
                firstPageProgressIndicatorBuilder: (_) => Row(children: [
                  TokoCard.shimmer(context),
                  TokoCard.shimmer(context),
                  TokoCard.shimmer(context)
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
            child: PagedListView<int,IOutlet>.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              pagingController: widget.outletController, 
              builderDelegate: CustomPagedChildBuilderDelegate(
                pagingController: widget.outletController,
                itemBuilder: ((_, item, __) => OutletCard(outlet: item,onClick: onOutletClick,viewMoreClick: viewMoreOutletClick)),
                firstPageProgressIndicatorBuilder: (_) => Row(children: [
                  OutletCard.shimmer(context),
                  OutletCard.shimmer(context),
                  OutletCard.shimmer(context)
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