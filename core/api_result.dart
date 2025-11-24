class ApiResult<T> {
  final T? data;
  final String? error;
  final int? status;

  ApiResult({this.data, this.error, this.status});

  bool get ok => error == null;
}
