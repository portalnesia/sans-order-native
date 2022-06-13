// ignore_for_file: non_constant_identifier_names

class ApiError {
  String name;
  int code;
  String description;

  ApiError(this.name,this.code,this.description);
}

class ResponseData<R> {
  ApiError? error;
  R? data;
  String? message;

  ResponseData(this.data,{String? message,Map<String,dynamic>? error}) {
    if(error != null) {
      this.error = ApiError(error['name'], error['code'], error['description']);
    }
  }
}

abstract class PortalnesiaModel {

}
abstract class PortalnesiaResponse<R> {
  R fromMap(Map<dynamic,dynamic> data);
}

class PortalnesiaPaginationModel<R extends PortalnesiaModel> extends PortalnesiaModel {
  List<R> data;
  int page;
  int? total_page;
  bool can_load;
  int? total;

  PortalnesiaPaginationModel({
    required this.data,
    this.page = 1,
    this.can_load = false,
    this.total = 1,
    this.total_page = 1
  });
}

abstract class PortalnesiaPaginationResponse<R extends PortalnesiaModel> extends PortalnesiaResponse<PortalnesiaPaginationModel<R>> {
  R dataMap(Map<dynamic,dynamic> data);

  @override
  PortalnesiaPaginationModel<R> fromMap(Map<dynamic,dynamic> data) {
    if(data['data'] == null) throw UnimplementedError();

    List<R> lists = [];
    if(data['data'] is List) {
      for(Map datas in data['data']) {
        lists.add(dataMap(datas));
      }
    }

    return PortalnesiaPaginationModel<R>(
      page: data['page'] ?? 1,
      total: data['total'] ?? 1,
      total_page: data['total_page'] ?? 1,
      can_load: data['can_load'] ?? false,
      data: lists
    );
  }
}

enum Method {
  put,
  delete,
  post,
  get
}