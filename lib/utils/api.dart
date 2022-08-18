
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sans_order/utils/main.dart';

class Api {
  _error(String msg,{RefreshController? controller, bool? refresh}) {
    if(controller != null) {
      if(refresh == true) {
        controller.refreshFailed();
      } else {
        controller.loadFailed();
      }
    }
    showSnackbar('Error', msg,type: SnackType.error);
    if (kDebugMode) {
      print(msg);
    }
  }
  Future<PortalnesiaResponse<D>?> get<D>(String path,{RefreshController? controller, bool? refresh,Options? options}) async {
    try {
      final toko = await portalnesia.request<D>(Method.get, path, options: options);
      if(controller != null) {
        if(refresh == true) {
          controller.refreshCompleted();
        } else {
          controller.loadComplete();
        }
      }
      return toko;
    } on PortalnesiaException catch (e){
      _error(e.message,controller: controller,refresh: refresh);
      return Future.error(e);
    } on PlatformException catch (e) {
      _error(e.message ?? 'Something went wrong',controller: controller,refresh: refresh);
    } catch(e) {
      _error(e.toString(),controller: controller,refresh: refresh);
    }
    return null;
  }

  Future<PortalnesiaResponse<D>?> delete<D>(String path,{Options? options}) async {
    try {
      final toko = await portalnesia.request<D>(Method.delete, path, options: options);
      return toko;
    } on PortalnesiaException catch (e){
      Get.back(closeOverlays: true);
      _error(e.message);
      return Future.error(e);
    } on PlatformException catch (e) {
      Get.back(closeOverlays: true);
      _error(e.message ?? 'Something went wrong');
    } catch(e) {
      Get.back(closeOverlays: true);
      _error(e.toString());
    }
    return null;
  }

  Future<PortalnesiaResponse<D>?> post<D>(String path,dynamic data,{Options? options}) async {
    try {
      final toko = await portalnesia.request<D>(Method.post, path,data: {"data":data},options: options);
      return toko;
    } on PortalnesiaException catch (e){
      Get.back(closeOverlays: true);
      _error(e.message);
      return Future.error(e);
    } on PlatformException catch (e) {
      Get.back(closeOverlays: true);
      _error(e.message ?? 'Something went wrong');
    } catch(e) {
      Get.back(closeOverlays: true);
      _error(e.toString());
    }
    return null;
  }

  Future<PortalnesiaResponse<D>?> put<D>(String path,Map data,{Options? options}) async {
    try {
      final toko = await portalnesia.request<D>(Method.put, path,data: {"data":data},options: options);
      return toko;
    } on PortalnesiaException catch (e){
      Get.back(closeOverlays: true);
      _error(e.message);
      return Future.error(e);
    } on PlatformException catch (e) {
      Get.back(closeOverlays: true);
      _error(e.message ?? 'Something went wrong');
    } catch(e) {
      Get.back(closeOverlays: true);
      _error(e.toString());
    }
    return null;
  }
}