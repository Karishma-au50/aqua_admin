import 'base_model.dart';

class ResponseModel<T> {
  final String? message;
  final bool error;
  final T? result;

  ResponseModel({this.message = "", this.error = false, this.result});

  ResponseModel.error({this.message, this.result}) : error = false;

  // default constructor
  ResponseModel.empty()
      : message = "Something went wrong",
        error = true,
        result = null;

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error, 'result': result};
  }

  ResponseModel fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: json['message'],
      error: json['error'],
      result: T == BaseModel
          ? BaseModel.fromJson(json['result']) as T?
          : json['result'] as T?,
    );
  }

  // copyWith method
  ResponseModel copyWith({
    String? message,
    bool? error,
    T? result,
  }) {
    return ResponseModel(
      message: message ?? this.message,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }
}
