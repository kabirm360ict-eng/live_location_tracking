import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/dio/injection_container.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/local_database/auth_db.dart';
import '../../data/model/login_request_hotelier_model.dart';
import '../../domain/entity/hotelier_login_response_entity.dart';
import '../../domain/entity/login_request_hotelier_entity.dart';
import '../../domain/use_cases/hotelier_login_usecase.dart';
import '../../../profile/data/data_source/profile_hotelier_remote_data_source.dart';
import '../../../profile/data/model/profile_response_model_hiring.dart';
import '../../../profile/data/model/profile_update_request_model_hiring.dart';
import '../../../../job_seeker/profile/presentation/widget/send_file_model.dart';

part 'hotelier_auth_event.dart';
part 'hotelier_auth_state.dart';

@lazySingleton
class HotelierAuthBloc extends Bloc<HotelierAuthEvent, HotelierAuthState> {
  final HotelierLoginUseCase _loginUseCase;

  HotelierAuthBloc(this._loginUseCase) : super(HotelierAuthInitial()) {
    on<HotelierLoginEvent>(_login);
    on<HotelierLogoutEvent>(_logout);
    on<GetProfileHotelierEvent>(_getProfile);
    on<UpdateProfileHotelierEvent>(_updateProfile);
  }

  Future<void> _login(
    HotelierLoginEvent event,
    Emitter<HotelierAuthState> emit,
  ) async {
    emit(HotelierLoginLoadingState());
    try {
      if (event.loginRequestModel.email != null) {
        final isDeleted = await getIt<AuthLocalDB>().isEmailDeleted(
          event.loginRequestModel.email.toString(),
        );
        if (isDeleted) {
          emit(HotelierLoginFailedState(message: "Account has been deleted"));
          return;
        }
      }

      final result = await _loginUseCase(
        LoginRequestHotelierEntity(
          email: event.loginRequestModel.email,
          password: event.loginRequestModel.password,
        ),
      );

      result.fold(
        (failure) => emit(HotelierLoginFailedState(message: failure.message)),
        (response) {
          if (response.is2FaOn ?? false) {
            emit(HotelierSendOtpSuccessState(is2FaOn: true));
          } else {
            emit(HotelierLoginSuccessState(response: response));
          }
        },
      );
    } catch (e, stackTrace) {
      emit(
        HotelierLoginFailedState(
          message: handleException(e, stackTrace).message,
        ),
      );
      if (kDebugMode) {
        print("error: $e \n stackTrace: $stackTrace");
      }
    }
  }

  Future<void> _logout(
    HotelierLogoutEvent event,
    Emitter<HotelierAuthState> emit,
  ) async {
    emit(HotelierLogoutSuccessState());
  }

  // for get profile
  String? profileImage;
  Future<void> _getProfile(
    GetProfileHotelierEvent event,
    Emitter<HotelierAuthState> emit,
  ) async {
    if (event.profile != null) {
      final r = event.profile!;
      profileImage = r.photo;
      emit(GetProfileHotelierSuccessState(profile: r));
      if (r.userId != null) {
        await getIt<AuthLocalDB>().setUserId(r.userId.toString());
      }
      if (r.userType != null) {
        await getIt<AuthLocalDB>().setUserType(r.userType.toString());
      }
      if (r.address != null) {
        await getIt<AuthLocalDB>().setLocation(r.address.toString());
      }
      return;
    }

    final token = await getIt<AuthLocalDB>().getToken();
    if (token == null || token.isEmpty) {
      emit(GetProfileHotelierFailedState(message: 'Not logged in'));
      return;
    }

    if ((state is GetProfileHotelierSuccessState ||
            state is GetProfileHotelierLoadingState) &&
        !event.isRefresh) {
      return;
    }

    emit(GetProfileHotelierLoadingState());
    final result = await ProfileHotelierRemoteDataSource.getProfile();
    await result.fold(
      (failure) async =>
          emit(GetProfileHotelierFailedState(message: failure.message)),
      (profile) async {
        profileImage = profile.photo;
        emit(GetProfileHotelierSuccessState(profile: profile));
        if (profile.userId != null) {
          await getIt<AuthLocalDB>().setUserId(profile.userId.toString());
        }
        if (profile.userType != null) {
          await getIt<AuthLocalDB>().setUserType(profile.userType.toString());
        }
        if (profile.address != null) {
          await getIt<AuthLocalDB>().setLocation(profile.address.toString());
        }
      },
    );
  }

  // for update profile
  Future<void> _updateProfile(
    UpdateProfileHotelierEvent event,
    Emitter<HotelierAuthState> emit,
  ) async {
    emit(UpdateProfileHotelierLoadingState());
    try {
      final result = await ProfileHotelierRemoteDataSource.updateProfile(
        payload: event.payload,
        files: event.files,
      );
      result.fold(
        (failure) =>
            emit(UpdateProfileHotelierFailedState(message: failure.message)),
        (profile) {
          emit(UpdateProfileHotelierSuccessState(profile: profile));
          add(GetProfileHotelierEvent(profile: profile));
        },
      );
    } catch (e, stackTrace) {
      emit(
        UpdateProfileHotelierFailedState(
          message: handleException(e, stackTrace).message,
        ),
      );
    }
  }
}
