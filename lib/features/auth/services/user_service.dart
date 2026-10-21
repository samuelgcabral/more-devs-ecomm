import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/login/model/user.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class UserService {
  UserService(this._dio);

  final Dio _dio;

  Future<User> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/users/me',
        options: ApiClient.authenticated,
      );

      return User.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiClient.exception(
        e,
        fallback: 'Não foi possível carregar seus dados',
      );
    }
  }
}
