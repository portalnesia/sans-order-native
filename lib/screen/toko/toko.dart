
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sans_order/model/portalnesia/outlet.dart';
import 'package:sans_order/model/portalnesia/toko.dart';
import 'package:sans_order/screen/outlet/outlet_card.dart';
import 'package:sans_order/utils/api.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/appbar.dart';
import 'package:sans_order/widget/back.dart';
import 'package:sans_order/widget/button_menu.dart';
import 'package:sans_order/widget/dialog.dart';
import 'package:sans_order/widget/loading.dart';
import 'package:sans_order/widget/markdown.dart';
import 'package:sans_order/widget/pagination.dart';
import 'package:sans_order/widget/screen.dart';

class TokoHome extends StatefulWidget {
  const TokoHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppsState();
}

class _AppsState extends State<TokoHome> {
  final Api api = Api();
  final RefreshController refreshController = RefreshController();
  final PagingController<int,IOutlet> pageController = PagingController(firstPageKey: 1);
  final _formMerchantKey = GlobalKey<FormState>();
  final _formOutletKey = GlobalKey<FormState>();
  bool canBack = true;

  PortalnesiaResponseModel<IToko>? data;
  PortalnesiaException? err;

  String? tokoId;
  Map input = {};

  Future<void> _getData(bool? refresh) async {
    try {
      final toko = await api.get<IToko>("/tokos/$tokoId",controller: refreshController, refresh: refresh);
      setState(() {
        data = data = toko?.toModel(TokoModel());
      });
    } on PortalnesiaException catch(e) {
      setState(() {
        err = e;
      });
    }
  }

  Future<void> _getOutlet(int pageKey) async {
    try {
      if(data != null) {
        final items = await portalnesia.request<IOutlet>(Method.get, '/tokos/${data?.data.slug}/outlets?page=$pageKey&pageSize=12');
        final newItems = items.toPaginationModel(OutletModel());
        if(newItems.meta.pagination.page == newItems.meta.pagination.pageCount) {
          pageController.appendLastPage(newItems.data);
        } else {
          pageController.appendPage(newItems.data, newItems.meta.pagination.page+1);
        }
      }
    } catch(e) {
      pageController.error = e;
    }
  }

  @override
  void initState() {
    tokoId = Get.parameters['toko_id'];
    if(tokoId == null) {
      backAction();
    } else {
      _getData(null);
    }
    pageController.addPageRequestListener((pageKey) {
      _getOutlet(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void onOutletClick(IOutlet outlet) {
    showSnackbar("Outlet Clicked", 'ID: ${outlet.id}');
  }

  Future<void> handleEdit() async {
    inspect(input);

    if (_formMerchantKey.currentState!.validate()) {
      showDialog(barrierDismissible: false,context: context, builder: createLoadingDialog);
      try {
        await api.put("/tokos/${data!.data.id}", input);
        Get.close(2);
        showSnackbar("success".tr, "saved_what".trParams({"what":"Data"}));
      } catch(_) {
        
      }
    }
  }

  Future<void> handleAddOutlet() async {
    inspect(input);

    if (_formOutletKey.currentState!.validate()) {
      showDialog(barrierDismissible: false,context: context, builder: createLoadingDialog);

      try {
        await api.post("/outlets", {...input,"toko": data!.data.id});
        Get.close(2);
        showSnackbar("success".tr, "saved_what".trParams({"what":"Data"}));
      } catch(_) {
        
      }
    }
  }

  Widget modalMerchant(BuildContext context) {
    final focus1 = FocusNode();
    return StatefulBuilder(builder: (context,internalSetState) {
      return MyDialog(
        canBack: canBack,
        title: "Edit Merchant",
        actions: [
          CupertinoButton(onPressed: handleEdit, child: Text("save".tr.toUpperCase(),style: const TextStyle(color: Colors.white)))
        ],
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Form(
              key: _formMerchantKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "name_what".trParams({"what":"Merchant"})
                    ),
                    initialValue: input['name'] ?? "",
                    onChanged: (text) {
                      setState(() {
                        input['name'] = text.isNotEmpty ? text : null;
                        canBack = false;
                      });
                      internalSetState(() {
                        canBack = false;
                      });
                    },
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(focus1);
                    },
                    validator: (text) {
                      if(text == null || text.isEmpty) {
                        return "required".tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomMarkdownEditor(
                    initialValue: input["description"] ?? "",
                    onChange: (text) {
                      setState(() {
                        input['description'] = text.isNotEmpty ? text : null;
                        canBack = false;
                      });
                      internalSetState(() {
                        canBack = false;
                      });
                    }, 
                    label: "description".tr,
                    focusNode: focus1,
                  ),
                ],
              )
            )
          ),
        ],
      );
    });
  }

  Widget modalOutlet(BuildContext context, Animation<double> b_, Animation<double> a_) {
    final focus1 = FocusNode();
    final focus2 = FocusNode();
    return StatefulBuilder(builder: (context,internalSetState) {
      return MyDialog(
        canBack: canBack,
        title: "add_what".trParams({"what":"Outlet"}),
        actions: [
          CupertinoButton(onPressed: handleAddOutlet, child: Text("save".tr.toUpperCase(),style: const TextStyle(color: Colors.white)))
        ],
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Form(
              key: _formOutletKey,
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "name_what".trParams({"what":"Outlet"})
                    ),
                    onChanged: (text) {
                      setState(() {
                        input['name'] = text.isNotEmpty ? text : null;
                        canBack = false;
                      });
                      internalSetState(() {
                        canBack = false;
                      });
                    },
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(focus1);
                    },
                    validator: (text) {
                      if(text == null || text.isEmpty) {
                        return "required".tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "address".tr
                    ),
                    onChanged: (text) {
                      setState(() {
                        input['address'] = text.isNotEmpty ? text : null;
                        canBack = false;
                      });
                      internalSetState(() {
                        canBack = false;
                      });
                    },
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(focus2);
                    },
                    keyboardType: TextInputType.streetAddress,
                    focusNode: focus1,
                  ),
                  const SizedBox(height: 20),
                  CustomMarkdownEditor(
                    onChange: (text) {
                      setState(() {
                        input['description'] = text.isNotEmpty ? text : null;
                      });
                      internalSetState(() {
                        canBack = false;
                        canBack = false;
                      });
                    }, 
                    label: "description".tr,
                    focusNode: focus2,
                  ),
                ],
              )
            ),
          ),
        ]
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    void showMerchantWindow() {
      setState(() {
        canBack = true;
        input = {
          "name": data?.data.name ?? "",
          "description": data?.data.description ?? ""
        };
      });
      showCupertinoModalPopup(context: context, builder: modalMerchant);
    }
    void showOutletWindow() {
      setState(() {
        canBack = true;
        input = {
          "name": null,
          "description": null,
          "address": null
        };
      });
      showGeneralDialog(context: context, pageBuilder: modalOutlet);
    }

    return Scaffold(
      body: Screen(
        child: SmartRefresher(
          controller: refreshController,
          header: const CustomClassicHeader(),
          onRefresh: () {
            _getData(true);
            pageController.refresh();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(pinned: true,delegate: SliversDelegate(
                title: data != null? data!.data.name : "Merchant",
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: const MyBackButton(),
                  actions: const [SettingActionButton()],
                ),
              )),
              SliverList(delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                ...(data == null && err == null ? [
                  SizedBox(
                    height: Get.height - 200,
                    child: const LoadingProgress(),
                  )
                ] : [
                  Row(
                    children: [
                      _EditBtn(onPress: showMerchantWindow),
                      _AddOutletBtn(onPress: showOutletWindow)
                    ]
                  ),
                  Row(
                    children: const [
                      _WalletBtn(),
                      _RemoveBtn()
                    ]
                  ),
                ]),

                const SizedBox(height: 40),

                Padding(padding: const EdgeInsets.symmetric(horizontal:10),child: Align(alignment: Alignment.centerLeft,child: Text("Outlets",style: context.theme.textTheme.headline3))),
                const Divider(),

                const SizedBox(height: 10),
              ])),

              ...(data != null ? [
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
                    newPageProgressIndicatorBuilder: (_) => OutletCard.shimmer(context),
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
              ] : [])
            ],
          ),
        )
      ),
    );
  }

}

class _EditBtn extends StatelessWidget {
  final void Function() onPress;
  const _EditBtn({Key? key,required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonMenu(
      icon: Icon(Icons.edit_note,size: 35,color: context.theme.textTheme.headline1!.color,), 
      text: Text("Edit Merchant",style: TextStyle(fontSize: 22,color: context.theme.textTheme.headline1!.color),),
      onPress: onPress,
    );
  }
}

class _AddOutletBtn extends StatelessWidget {
  final void Function() onPress;
  const _AddOutletBtn({Key? key,required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonMenu(
      icon: Icon(Icons.add_business_rounded,size: 35,color: context.theme.textTheme.headline1!.color,), 
      text: Text("add_what".trParams({'what':'Outlet'}),style: TextStyle(fontSize: 22,color: context.theme.textTheme.headline1!.color),),
      onPress: onPress,
    );
  }
}

class _WalletBtn extends StatelessWidget {
  const _WalletBtn({Key? key}) : super(key: key);

  void onPress() {
    showSnackbar("Under Maintenance", "This feature is under maintenance");
  }

  @override
  Widget build(BuildContext context) {
    return ButtonMenu(
      icon: Icon(Icons.wallet,size: 35,color: context.theme.textTheme.headline1!.color,), 
      text: Text("wallet".tr,style: TextStyle(fontSize: 22,color: context.theme.textTheme.headline1!.color),),
      onPress: onPress,
    );
  }
}

class _RemoveBtn extends StatelessWidget {
  const _RemoveBtn({Key? key}) : super(key: key);

  void onPress() {
    showSnackbar("Under Maintenance", "This feature is under maintenance");
  }

  @override
  Widget build(BuildContext context) {
    return ButtonMenu(
      icon: Icon(Icons.wallet,size: 35,color: context.theme.errorColor), 
      text: Text("remove_what".trParams({'what':'Merchant'}),style: TextStyle(fontSize: 22,color: context.theme.errorColor)),
      onPress: onPress,
    );
  }
}