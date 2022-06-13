import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';

class TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final _radiusAppbar = BorderRadiusTween(begin:  const BorderRadius.vertical(bottom: Radius.circular(30)),end: BorderRadius.zero);
  final double extent;
  final duration = const Duration(microseconds: 200);

  TransitionAppBarDelegate({this.extent = 100});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 34 * maxExtent / 100;
    final progress =  shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final radiusAppbar = _radiusAppbar.lerp(progress);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child : Container(
          decoration: BoxDecoration(color: context.theme.primaryColor.withAlpha(225),borderRadius:radiusAppbar),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AnimatedContainer(
                padding: EdgeInsets.lerp(const EdgeInsets.only(bottom: 25,right: 12), const EdgeInsets.only(top: 25,right: 12), progress), 
                duration: duration,
                alignment: Alignment.lerp(Alignment.bottomRight, Alignment.centerRight, progress),
                child: GetBuilder<OauthControllers>(builder: (u)=>CircleAvatar(
                  radius: lerpDouble(40, 20, progress),
                  backgroundColor: context.theme.backgroundColor,
                  backgroundImage: u.user.picture != null ? CachedNetworkImageProvider(u.user.picture!) : null,
                  child: u.user.picture == null ? const Icon(Icons.person_outline_rounded) : null,
                )),
              ),
              
              AnimatedContainer(duration: duration, 
                padding: EdgeInsets.lerp(const EdgeInsets.only(top: 65), const EdgeInsets.only(top: 25), progress),
                alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, progress),
                child: Text('SansOrder',style: TextStyle.lerp(
                  context.theme.textTheme.headline1!.copyWith(color: Colors.white), 
                  context.theme.textTheme.headline4!.copyWith(color: Colors.white,fontWeight: FontWeight.bold), 
                  progress
                ))
              ),
              
              AnimatedOpacity(
                opacity: lerpDouble(1,0,progress) as double,
                duration: duration,
                child: Container(
                  padding: EdgeInsets.lerp(EdgeInsets.only(top: extent/2 + 20, left: 12), EdgeInsets.only(top: extent/4, left: 12), progress),
                  alignment: Alignment.centerLeft,
                  child: SizedBox(width: Get.width - 110,child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GetBuilder<OauthControllers>(builder: (u) => Text(u.user.name ?? '',overflow: TextOverflow.ellipsis,style: context.theme.textTheme.headline6!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),)),
                    GetBuilder<OauthControllers>(builder: (u) => Text('@${u.user.username}',overflow: TextOverflow.ellipsis,style: context.theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
                  ])),
                )
              ),
            ],
          ),
        )
      )
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent {
    return 84;
  }

  @override
  bool shouldRebuild(TransitionAppBarDelegate oldDelegate) {
    return true;
  }
} 