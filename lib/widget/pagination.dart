import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// ignore: implementation_imports
// ignore: implementation_imports
import 'package:infinite_scroll_pagination/src/ui/default_indicators/footer_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sans_order/portalnesia/portalnesia_exception.dart';

class FirstPageExceptionIndicator extends StatelessWidget {
  const FirstPageExceptionIndicator({
    required this.title,
    this.message,
    this.onTryAgain,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            if (message != null)
              const SizedBox(
                height: 16,
              ),
            if (message != null)
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            if (onTryAgain != null)
              const SizedBox(
                height: 20,
              ),
            if (onTryAgain != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTryAgain,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class FirstPageError extends StatelessWidget {
  final PagingController pagingController;

  const FirstPageError({Key? key,required this.pagingController}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    String title = 'Something went wrong';
    if(pagingController.error is PortalnesiaException) {
      title = '${(pagingController.error as PortalnesiaException).message}.';
    }
    return FirstPageExceptionIndicator(
      title: title,
      message: 'Please try again later',
      onTryAgain: pagingController.retryLastFailedRequest,
    );
  }
}

class NewPageError extends StatelessWidget {
  final PagingController pagingController;

  const NewPageError({
    Key? key,
    required this.pagingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = 'Something went wrong';
    if(pagingController.error is PortalnesiaException) {
      message = '${(pagingController.error as PortalnesiaException).message}.';
    }
    return InkWell(
      onTap: pagingController.retryLastFailedRequest,
      child: FooterTile(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$message. Tap to try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 4,
            ),
            const Icon(
              Icons.refresh,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}



class CustomPagedChildBuilderDelegate<T> extends PagedChildBuilderDelegate<T> {
  final PagingController pagingController;
  final String? itemType;
  
  CustomPagedChildBuilderDelegate({
    required this.pagingController,
    this.itemType = 'data',
    required super.itemBuilder,
    super.firstPageProgressIndicatorBuilder,
    super.newPageProgressIndicatorBuilder,
    super.transitionDuration
  }) : super(
    animateTransitions: true,
    firstPageErrorIndicatorBuilder: (_) => FirstPageError(pagingController: pagingController,),
    newPageErrorIndicatorBuilder: (_) => NewPageError(pagingController: pagingController,),
    noItemsFoundIndicatorBuilder: itemType != null ? (_) => FirstPageExceptionIndicator(title: 'No ${itemType.toLowerCase()} found',message: 'This list is currently empty.',) : null
  );
}

Widget _getOuterBuilder(Widget child) => Container(
  color: Get.theme.primaryColor.withAlpha(225),
  height: 300,
  alignment: Alignment.bottomCenter,
  child: Padding(
    padding: const EdgeInsets.only(top:60, bottom: 15),
    child: child,
  )
);

class CustomClassicHeader extends ClassicHeader {
  const CustomClassicHeader({
    Key? key,
  }) : super(
    key: key,
    outerBuilder: _getOuterBuilder,
    height: 100,
    refreshingIcon: const CupertinoActivityIndicator(color: Color.fromARGB(255, 238, 238, 238)),
    failedIcon: const Icon(Icons.error, color: Color.fromARGB(255, 238, 238, 238)),
    completeIcon: const Icon(Icons.done, color: Color.fromARGB(255, 238, 238, 238)),
    idleIcon: const Icon(Icons.arrow_downward, color: Color.fromARGB(255, 238, 238, 238)),
    releaseIcon: const Icon(Icons.refresh, color: Color.fromARGB(255, 238, 238, 238)),
    textStyle: const TextStyle(color: Color.fromARGB(255, 238, 238, 238)),
  );
  
}