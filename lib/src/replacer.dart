abstract class Replacer {
  String replace(String source, Map<String, String> parameters);

  static Replacer factory({String markerStart, String markerEnd}) =>
      _FactoryReplacer(markerStart: markerStart, markerEnd: markerEnd);
}

class _FactoryReplacer implements Replacer {
  String markerStart = '{{';
  String markerEnd = '}}';

  _FactoryReplacer({String markerStart, String markerEnd}) {
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
