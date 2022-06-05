import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sans_order/controllers/oauth.dart';

class TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  late Tween<double> _avatarTop;
  final _avatarLeft = Tween<double>(begin: 45,end: 12);
  final _avatarSize = Tween<double>(begin: 40,end: 24);
  final _radiusAppbar = BorderRadiusTween(begin:  const BorderRadius.vertical(bottom: Radius.circular(30)),end: BorderRadius.zero);
  final _titleTheme = TextStyleTween(
    begin: Get.textTheme.headline1!.copyWith(color: Colors.white),
    end: Get.textTheme.headline4!.copyWith(color: Colors.white,fontWeight: FontWeight.normal)
  );
  final _titleAlign = AlignmentTween(begin: Alignment.topCenter,end: Alignment.center);
  final _profileFade = Tween<double>(begin: 1,end: 0);
  late EdgeInsetsTween _titlePadding;
  late EdgeInsetsTween _profilePadding;
  final double extent;

  TransitionAppBarDelegate({this.extent = 100}) {
    _avatarTop = Tween<double>(begin: (extent/2)-10,end: 32);
    _titlePadding = EdgeInsetsTween(begin: const EdgeInsets.only(top: 35), end: const EdgeInsets.only(top: 25));
    _profilePadding = EdgeInsetsTween(begin: EdgeInsets.only(top: extent/2 + 10, right: 12),end: EdgeInsets.only(top: extent/4, right: 12));
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 34 * maxExtent / 100;
    //double fadeProgressTempVal = 20 * maxExtent / 100;

    final progress =  shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    //final fadeProgress =  shrinkOffset > fadeProgressTempVal ? 1.0 : shrinkOffset / fadeProgressTempVal;

    if (kDebugMode) {
      //print("Objechjkf === $progress $shrinkOffset $tempVal");
      //print(Get.statusBarHeight);
    }
    final avatarTop = _avatarTop.transform(progress);
    final avatarLeft = _avatarLeft.transform(progress);
    final avatarSize = _avatarSize.transform(progress);
    final radiusAppbar = _radiusAppbar.lerp(progress);
    final titleTheme = _titleTheme.lerp(progress);
    final titleAlign = _titleAlign.transform(progress);
    final titlePadding = _titlePadding.lerp(progress);
    final profileFade = _profileFade.transform(progress);
    final profilePadding = _profilePadding.transform(progress);

    return Container(
      decoration: BoxDecoration(color: Get.theme.primaryColor,borderRadius:radiusAppbar),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: avatarTop,
            left: avatarLeft,
            child: GetBuilder<OauthControllers>(builder: (u)=>CircleAvatar(
              radius: avatarSize,
              backgroundColor: Get.theme.backgroundColor,
              backgroundImage: u.user.picture != null ? CachedNetworkImageProvider(u.user.picture!) : null,
              child: u.user.picture == null ? const Icon(Icons.person_outline_rounded) : null,
            ))
          ),
          Padding(
            padding: titlePadding,
            child: Align(
              alignment: titleAlign,
              child: Text('SansOrder',style: titleTheme),
            ),
          ),
          Opacity(
            opacity: profileFade,
            child: Padding(
              padding: profilePadding,
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GetBuilder<OauthControllers>(builder: (u) => Text(u.user.name ?? '',style: Get.textTheme.headline6!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),)),
                    GetBuilder<OauthControllers>(builder: (u) => Text('@${u.user.username}',style: Get.textTheme.headline6!.copyWith(color: Colors.white)))
                  ],
                ),
              )
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent {
    return Get.statusBarHeight + 25;
  }

  @override
  bool shouldRebuild(TransitionAppBarDelegate oldDelegate) {
    return false;
  }
} 