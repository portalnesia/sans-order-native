
import 'package:get_storage/get_storage.dart' as get_storage;

abstract class Settings<T> {
  get_storage.GetStorage storage;
  String value;

  Settings(this.storage,{this.value = ''});
  List<String> get optionsKey;
  Map<String,String> get optionsTitle;
  String get valueLabel;

  Future<T> init(Map<String,String> json);
  Future<T> changeValue(dynamic data);
}