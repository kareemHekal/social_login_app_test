import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/social_register_profile.dart';
import '../models/social_auth_response_model.dart';

abstract class SocialAuthGatewayDataSource {
  Future<SocialAuthResponseModel> callSocialLogin(String idToken);
  Future<SocialAuthResponseModel> callSocialRegister({
    required String idToken,
    required SocialRegisterProfile profile,
  });
}

class SocialAuthGatewayDataSourceImpl implements SocialAuthGatewayDataSource {
  final Dio dio;

  SocialAuthGatewayDataSourceImpl({required this.dio});

  @override
  Future<SocialAuthResponseModel> callSocialLogin(String idToken) async {
    try {
      final response = await dio.post(
        '/social/login',
        data: {'token': idToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return SocialAuthResponseModel.fromJson(data, idToken: idToken);
      } else if (response.statusCode == 404) {
        throw UserNotRegisteredException(
          message: 'الحساب غير مسجل بالباك-إند ويحتاج لإكمال البيانات',
        );
      } else {
        final data = response.data;
        final errorMsg = data is Map && (data['message'] != null || data['error'] != null)
            ? (data['message'] ?? data['error']).toString()
            : 'فشل تسجيل الدخول (${response.statusCode})';
        throw ServerException(message: errorMsg, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw UserNotRegisteredException();
      }
      final data = e.response?.data;
      final errorMsg = data is Map && (data['message'] != null || data['error'] != null)
          ? (data['message'] ?? data['error']).toString()
          : (e.message ?? 'خطأ في الاتصال بالخادم');
      throw ServerException(
        message: errorMsg,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<SocialAuthResponseModel> callSocialRegister({
    required String idToken,
    required SocialRegisterProfile profile,
  }) async {
    try {
      final response = await dio.post(
        '/social/register',
        data: {
          'token': idToken,
          'profile': profile.toJson(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return SocialAuthResponseModel.fromJson(data, idToken: idToken);
      } else {
        final data = response.data;
        final errorMsg = data is Map && (data['message'] != null || data['error'] != null)
            ? (data['message'] ?? data['error']).toString()
            : 'فشل إنشاء الحساب (${response.statusCode})';
        throw ServerException(message: errorMsg, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMsg = data is Map && (data['message'] != null || data['error'] != null)
          ? (data['message'] ?? data['error']).toString()
          : (e.message ?? 'خطأ في الاتصال بالخادم');
      throw ServerException(
        message: errorMsg,
        statusCode: e.response?.statusCode,
      );
    }
  }
}
