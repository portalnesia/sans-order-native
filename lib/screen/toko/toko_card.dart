import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/model/portalnesia/toko.dart';
import 'package:sans_order/widget/card.dart';
import 'package:sans_order/utils/main.dart';
import 'package:shimmer/shimmer.dart';

class TokoCard extends StatelessWidget {
  final IToko toko;
  final void Function(IToko toko) onClick;
  final void Function(IToko toko)? viewMoreClick;

  const TokoCard({Key? key,required this.toko,required this.onClick,this.viewMoreClick}) : super(key: key);

  void onTokoClick() {
    onClick(toko);
  }

  void viewMoreTokoClick() {
    if(viewMoreClick != null) viewMoreClick!(toko);
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
            onTap: viewMoreTokoClick,
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
          onTap: onTokoClick,
          borderRadius: cardRadius,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CachedNetworkImage(imageUrl: photoUrl(toko.logo?.url),height: 100,width: double.infinity,fit: BoxFit.contain,cacheKey: 'toko_${toko.id}_card')
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text((toko.name),style: context.theme.textTheme.headline5,overflow: TextOverflow.ellipsis,maxLines: 2),
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
          width: (Get.width/2) - 10,
          height: 100,
          color: context.theme.cardColor,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: (Get.width/2)- 30,
            height: 20,
            color: context.theme.cardColor,
          ),
        )
      ]),
    )
  );
}