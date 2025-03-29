class Result<T, F> {
  final T? data;
  final F? failure;

  Result({this.data, this.failure});

  bool get isSuccess => failure == null;
}