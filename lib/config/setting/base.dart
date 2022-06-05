
import 'package:get_storage/get_storage.dart' as get_storage;

abstract class Settings<T> {
  get_storage.GetStorage storage;
  Settings(this.storage);
  
  Future<T> init(Map<String,String> json);
  Future<T> changeValue(dynamic data);
}