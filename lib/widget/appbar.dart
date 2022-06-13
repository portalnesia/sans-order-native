import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySliver extends StatelessWidget {
  final double height;
  final String title;
  final Color? backgroundColor;
  final bool pinned;
  final bool floating;
  final List<Widget>? children;
  final AppBar? appBar;
  final bool borderAnimation;

  const MySliver({
    Key? key,
    this.title = 'SansOrder' ,
    this.height = 170, 
    this.backgroundColor,
    this.pinned = true,
    this.floating = false,
    this.appBar,
    this.borderAnimation = true,
    this.children}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPersistentHeader(
          delegate: SliversDelegate(
            height: height,
            title: title,
            backgroundColor: backgroundColor,
            appBar: appBar,
            borderAnimation: borderAnimation
          ),
          pinned: pinned,
          floating: floating,
        ),
        ...children!
      ],
    );
  }

}

class SliversDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final String title;
  final Color? backgroundColor;
  final AppBar? appBar;
  final bool borderAnimation;

  SliversDelegate({
    this.title = 'SansOrder' ,
    this.height = 150, 
    this.backgroundColor,
    this.appBar,
    this.borderAnimation = true
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 34 * maxExtent / 100;
    final progress =  shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final finalDecoration = BoxDecoration(
      color: backgroundColor?.withAlpha(225) ?? context.theme.primaryColor.withAlpha(225),
      borderRadius: borderAnimation ? BorderRadius.lerp(const BorderRadius.vertical(bottom: Radius.circular(30)), BorderRadius.zero, progress) : BorderRadius.zero);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child : Container(
          decoration: finalDecoration,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ...(appBar != null ? [appBar!] : []),
              Container(
                padding: EdgeInsets.lerp(const EdgeInsets.only(bottom: 20), const EdgeInsets.only(top: 25), progress),
                alignment: Alignment.lerp(Alignment.bottomCenter, Alignment.center, progress),
                child: Text(title,style: TextStyle.lerp(
                  context.theme.textTheme.headline1!.copyWith(color: Colors.white), 
                  context.theme.textTheme.headline4!.copyWith(color: Colors.white,fontWeight: FontWeight.bold), 
                  progress
                )),
              ),
            ],
          ),
        )
      )
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 84;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
  
}