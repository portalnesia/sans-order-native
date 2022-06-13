class PortalnesiaException implements Exception {
  late String name;
  late String message;
  int? code;
  dynamic payload;
  int? httpStatus;

  PortalnesiaException({data,int? code,String? name, int? httpStatus}) {
    String msg='';
    
    if(data is String) {
      msg = data;
    } else if(data is Map) {
      payload = data;
      if(data['error'] is bool) {
        msg = data['message'] ?? 'Something went wrong';
      } else {
        msg = data['error']?['description'] ?? data['error_description'] ?? "Something went wrong";
      }
    }
    message = msg;
    this.name = name != null ? '[PortalnesiaError] $name' : 
      data is! String && data['error'] is! bool && data['error']['name'] is String ? '[PortalnesiaError] ${data['error']['name']}' : 
      data is! String && data['error'] is String ? '[PortalnesiaError] ${data['error']}' : 'PortalnesiaError';

    if(code is int) {
      this.code = code;
    } else if(data is! String && data['error'] is! bool && data['error']['code'] is int) {
      this.code = data['error']['code'];
    }
  }
}