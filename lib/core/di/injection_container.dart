import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/social_auth/data/datasources/social_auth_firebase_data_source.dart';
import '../../features/social_auth/data/datasources/social_auth_gateway_data_source.dart';
import '../../features/social_auth/data/repositories/social_auth_repository_impl.dart';
import '../../features/social_auth/domain/repositories/social_auth_repository.dart';
import '../../features/social_auth/domain/usecases/cancel_social_registration_usecase.dart';
import '../../features/social_auth/domain/usecases/check_social_user_usecase.dart';
import '../../features/social_auth/domain/usecases/social_login_usecase.dart';
import '../../features/social_auth/domain/usecases/social_register_usecase.dart';
import '../../features/social_auth/domain/usecases/social_sign_out_usecase.dart';
import '../../features/social_auth/presentation/mvi/social_auth_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Core Network
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // 2. Data Sources (Prefix: SocialAuth...)
  sl.registerLazySingleton<SocialAuthFirebaseDataSource>(
    () => SocialAuthFirebaseDataSourceImpl(),
  );

  sl.registerLazySingleton<SocialAuthGatewayDataSource>(
    () => SocialAuthGatewayDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // 3. Repository (Prefix: SocialAuth...)
  sl.registerLazySingleton<SocialAuthRepository>(
    () => SocialAuthRepositoryImpl(
      socialAuthFirebaseDataSource: sl<SocialAuthFirebaseDataSource>(),
      socialAuthGatewayDataSource: sl<SocialAuthGatewayDataSource>(),
    ),
  );

  // 4. Use Cases (Prefix: Social...)
  sl.registerFactory(() => SocialLoginUseCase(sl<SocialAuthRepository>()));
  sl.registerFactory(() => SocialRegisterUseCase(sl<SocialAuthRepository>()));
  sl.registerFactory(() => CheckSocialUserUseCase(sl<SocialAuthRepository>()));
  sl.registerFactory(() => SocialSignOutUseCase(sl<SocialAuthRepository>()));
  sl.registerFactory(() => CancelSocialRegistrationUseCase(sl<SocialAuthRepository>()));

  // 5. Presentation / Cubit (Prefix: SocialAuth...)
  sl.registerFactory(
    () => SocialAuthCubit(
      socialLoginUseCase: sl<SocialLoginUseCase>(),
      socialRegisterUseCase: sl<SocialRegisterUseCase>(),
      checkSocialUserUseCase: sl<CheckSocialUserUseCase>(),
      socialSignOutUseCase: sl<SocialSignOutUseCase>(),
      cancelSocialRegistrationUseCase: sl<CancelSocialRegistrationUseCase>(),
    ),
  );
}
