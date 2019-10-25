class Request {
  String url;
  String method;
  Map<String, String> headers = Map();
  Map<String, String> query = Map();
  Map<String, dynamic> attributes;
  dynamic body;

  Request(this.url, this.method, {Map<String, dynamic> attributes})
      : this.attributes = attributes == null ? Map() : attributes;

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

  dynamic get(String key) => this.attributes[key];

  void set(String key, dynamic value) => this.attributes[key] = value;
}
