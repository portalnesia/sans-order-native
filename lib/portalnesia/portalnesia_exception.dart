class PortalnesiaException implements Exception {
  late String name;
  late String message;
  late int status;
  dynamic details;

  PortalnesiaException(Map<dynamic, dynamic>? data) {
    if(data != null && data['error'] is Map) {
      name = data['error']['name'];
      message = data['error']['message'];
      status = data['error']['status'];
      if(data['error']['details'] != null) {
        details = data['error']['details'];
      }
    } else {
      name = "UnknownError";
      message = "Something went wrong";
      status = 503;
    }
  }
}