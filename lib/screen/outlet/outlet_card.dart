import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/model/portalnesia/outlet.dart';
import 'package:sans_order/widget/card.dart';
import 'package:shimmer/shimmer.dart';

class OutletCard extends StatelessWidget {
  final IOutlet outlet;
  final void Function(IOutlet outlet) onClick;
  final void Function(IOutlet outlet)? viewMoreClick;

  const OutletCard({Key? key,required this.outlet,required this.onClick,this.viewMoreClick}) : super(key: key);
  
  void onOutletClick() {
    onClick(outlet);
  }

  void viewMoreOutletClick() {
    if(viewMoreClick != null) viewMoreClick!(outlet);
  }

  @override
  Widget build(BuildContext context) {
    if(outlet.id == 0) {
      return SizedBox(
        width: 200,
        child: Card(
          elevation: 0,
          shape: cardBorder,
          child: InkWell(
            onTap: viewMoreOutletClick,
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
          onTap: onOutletClick,
          borderRadius: cardRadius,
          child:  Padding(
            padding: const EdgeInsets.all(10),
            child: Text((outlet.name),style: context.theme.textTheme.headline5,overflow: TextOverflow.ellipsis,maxLines: 2),
          ),
        ),
      ),
    );
  }

  static Widget shimmer(BuildContext context) => SizedBox(
    height: 70,
    child: Card(
      elevation: 0,
      shape: cardBorder,
      child: Shimmer.fromColors(
        baseColor: context.theme.scaffoldBackgroundColor, 
        highlightColor: context.theme.textTheme.caption!.color!,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left:10,bottom:5,right:10,top:10),
            child: Container(
              width: (Get.width/2) - 30,
              height: 15,
              color: context.theme.cardColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10,bottom:10,right:10,top:5),
            child: Container(
              width: (Get.width/2) - 30,
              height: 15,
              color: context.theme.cardColor,
            ),
          )
        ]),
      )
    )
  );
}