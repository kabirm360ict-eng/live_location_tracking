// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../feature/job_seeker/auth/data/datasource/auth_remote_datasource_job.dart'
    as _i15;
import '../../feature/job_seeker/auth/data/repositories_impl/auth_repository_impl.dart'
    as _i975;
import '../../feature/job_seeker/auth/domain/repositories/auth_repositories.dart'
    as _i1036;
import '../../feature/job_seeker/auth/domain/usecases/fcm_token_usecase.dart'
    as _i27;
import '../../feature/job_seeker/auth/domain/usecases/login_usecase.dart'
    as _i827;
import '../../feature/job_seeker/auth/domain/usecases/logout_usecase.dart'
    as _i655;
import '../../feature/job_seeker/auth/presentation/bloc/auth_job_bloc.dart'
    as _i908;
import '../local_database/auth_db.dart' as _i60;
import '../network/api_client2.dart' as _i997;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => registerModule.storage);
    gh.lazySingleton<_i60.AuthLocalDB>(
      () => _i60.AuthLocalDB(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i997.ApiClient2>(() => _i997.ApiClient2(gh<_i361.Dio>()));
    gh.lazySingleton<_i15.AuthRemoteDataSourceJob>(
      () => _i15.AuthRemoteDataSourceJob(gh<_i60.AuthLocalDB>()),
    );
    gh.lazySingleton<_i1036.AuthRepositories>(
      () => _i975.AuthRepositoryImpl(
        authRemoteDataSourceJob: gh<_i15.AuthRemoteDataSourceJob>(),
        authLocalDB: gh<_i60.AuthLocalDB>(),
      ),
    );
    gh.factory<_i27.FcmTokenUsecase>(
      () => _i27.FcmTokenUsecase(gh<_i1036.AuthRepositories>()),
    );
    gh.factory<_i827.LoginUsecase>(
      () => _i827.LoginUsecase(gh<_i1036.AuthRepositories>()),
    );
    gh.factory<_i655.LogoutUsecase>(
      () => _i655.LogoutUsecase(gh<_i1036.AuthRepositories>()),
    );
    gh.lazySingleton<_i908.AuthJobBloc>(
      () => _i908.AuthJobBloc(gh<_i827.LoginUsecase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
