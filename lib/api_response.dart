class ApiResponse<T> {
  Status status;
  T? data;
  String? massage;

  ApiResponse.initial(this.massage) : status = Status.INITIAL;

  ApiResponse.loading(this.massage) : status = Status.LOADING;

  ApiResponse.success(this.data) : status = Status.SUCCESS;

  ApiResponse.error(this.massage) : status = Status.ERROR;
}

enum Status { INITIAL, LOADING, SUCCESS, ERROR }
