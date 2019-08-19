class Request {
  String url;
  String method;
  Map<String, String> headers = Map();
  Map<String, String> query = Map();
  dynamic body;

  Request(this.url, this.method);

  @override
  String toString() {
    String url = this.url;
    String query = '';
    this.query.forEach((key, value) {
      if (query != '') {
        query += '&';
      }
      query += '$key=$value';
    });
    if (this.query.isNotEmpty) {
      query = url.contains('?') ? '&$query' : '?$query';
    }

    return url + query;
  }
}
