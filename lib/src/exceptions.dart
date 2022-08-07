class ModelParseError<T> implements Exception {
  final dynamic raw;

  ModelParseError(this.raw);

  @override
  String toString() {
    return 'Could not parse ${T.toString()} from raw data ${raw.toString()}';
  }
}

class ModelApiUrlNotImplemented implements Exception {}
