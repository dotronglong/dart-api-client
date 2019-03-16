class Replacer {
  String markerStart = '{{';
  String markerEnd = '}}';

  Replacer({String markerStart, String markerEnd}) {
    if (markerStart != null) this.markerStart = markerStart;
    if (markerEnd != null) this.markerEnd = markerEnd;
  }

  String replace(String source, Map<String, String> parameters) {
    parameters.forEach((key, value) {
      source = source.replaceAll('$markerStart$key$markerEnd', value);
    });
    return source;
  }
}
