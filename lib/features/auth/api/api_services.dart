import '../../../core/model/response_model.dart';
import '../../../core/network/base_api_service.dart';

class AuthEndpoint {
  static const login = '/admin/login';
}

class AuthService extends BaseApiService {
  Future<ResponseModel> login(String mobile, String password) async {
    final res = await post(AuthEndpoint.login, data: {
      "mobile": mobile,
      "password": password,
    });
    return ResponseModel<String>.empty().fromJson(res.data);
  }
}
