import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import 'package:location_tracking/feature/job_seeker/profile/data/data_source/profile_job_seeker_remote_data_source.dart';
import 'package:location_tracking/feature/job_seeker/profile/data/model/profile_get_job_seeker_model.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/api_client2.dart';
import '../../../../../core/local_database/auth_db.dart';
import '../../data/models/login_request_model_job.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/login_request_job_entity.dart';
import 'package:injectable/injectable.dart';
part 'auth_job_event.dart';
part 'auth_job_state.dart';

@lazySingleton
class AuthJobBloc extends Bloc<AuthJobEvent, AuthJobState> {
  final LoginUsecase _loginUsecase;
  // final RegisterJobSeekerUsecase _registerJobSeekerUsecase;
  // final SendOtpUsecase _sendOtpUsecase;
  // final MatchOtpUsecase _matchOtpUsecase;
  // final ForgetPasswordJobUsecase _forgetPasswordJobUsecase;
  // final ChangePasswordUsecase _changePasswordUsecase;

  AuthJobBloc(
    this._loginUsecase,
    // this._registerJobSeekerUsecase,
    // this._sendOtpUsecase,
    // this._matchOtpUsecase,
    // this._forgetPasswordJobUsecase,
    // this._changePasswordUsecase,
  ) : super(AuthJobInitial()) {
    on<LoginEventJob>(_login);
    // on<SendOtpEventJob>(_sendOtp);
    // on<RegisterEventJob>(_register);
    // on<ResendOtpEventJob>(_resendOtp);
    // on<MatchOtpEventJob>(_matchOtp);
    // on<ChangePasswordEventJob>(_forgetPasswordJob);
    on<LogOutEvent>(_logout);
    // on<PasswordChangeEvent>(_passwordChange);
    //! get profile
    on<GetProfileJobSeekerEvent>(_getProfile);
    // //! update profile
    // on<UpdateProfileJobSeekerEvent>(_updateProfile);
    // //! update verify documents
    // on<UpdateVerifyDocumentsJobSeekerEvent>(_updateVerifyDocuments);
  }


  //for register
  // Future<void> _register(RegisterEventJob event, Emitter<AuthJobState> emit) async {
  //   emit(RegisterLoadingStateJob());
  //   try {
  //     final result = await _registerJobSeekerUsecase(event.registrationRequestModelJob, event.regFiles);
  //     result.fold((ifLeft) => emit(RegisterFailedStateJob(message: ifLeft.message)), (ifRight) => emit(RegisterSuccessStateJob()));
  //   } catch (e, stackTrace) {
  //     emit(RegisterFailedStateJob(message: handleException(e, stackTrace).message));
  //     if (kDebugMode) {
  //       print("error: $e \n stackTrace: $stackTrace");
  //     }
  //   }
  // }

  //for login
  Future<void> _login(LoginEventJob event, Emitter<AuthJobState> emit) async {
    emit(LoginLoadingStateJob());
    try {
      if (event.loginRequestModelJob.email != null) {
        final isDeleted = await getIt<AuthLocalDB>().isEmailDeleted(event.loginRequestModelJob.email!);
        if (isDeleted) {
          emit(LoginFailedStateJob(message: "Account has been deleted"));
          return;
        }
      }

      final result = await _loginUsecase(
        LoginRequestJobEntity(email: event.loginRequestModelJob.email, password: event.loginRequestModelJob.password),
      );
      result.fold(
        (ifLeft) => emit(LoginFailedStateJob(message: ifLeft.message)),
        (ifRight) {
          if (ifRight.is2FaOn ?? false) {
            emit(SendOtpSuccessStateJob(is2FaOn: true));
          } else {
            if (ifRight.isCompleted == true) {
              emit(LoginSuccessStateJob());
            } else {
              emit(WorkPermitPendingStateJob());
            }
          }
        },
      );
    } catch (e, stackTrace) {
      emit(LoginFailedStateJob(message: handleException(e, stackTrace).message));
      if (kDebugMode) {
        print("error: $e \n stackTrace: $stackTrace");
      }
    }
  }

  //for send otp
  // Future<void> _sendOtp(SendOtpEventJob event, Emitter<AuthJobState> emit) async {
  //   emit(SendOtpLoadingStateJob());
  //   try {
  //     final result = await _sendOtpUsecase(event.sendEmailOtpModelJob);
  //     result.fold(
  //       (ifLeft) => emit(SendOtpFailedStateJob(message: ifLeft.message)),
  //       (ifRight) => emit(SendOtpSuccessStateJob(is2FaOn: false)),
  //     );
  //   } catch (e, stackTrace) {
  //     emit(SendOtpFailedStateJob(message: handleException(e, stackTrace).message));
  //     if (kDebugMode) {
  //       print("error: $e \n stackTrace: $stackTrace");
  //     }
  //   }
  // }

  // //for change password
  // Future<void> _forgetPasswordJob(ChangePasswordEventJob event, Emitter<AuthJobState> emit) async {
  //   emit(ChangePasswordLoadingStateJob());
  //   try {
  //     final result = await _forgetPasswordJobUsecase(event.changePasswordRequestModelJob);
  //     result.fold(
  //       (ifLeft) => emit(ChangePasswordFailedStateJob(message: ifLeft.message)),
  //       (ifRight) => emit(ChangePasswordSuccessStateJob()),
  //     );
  //   } catch (e, stackTrace) {
  //     emit(ChangePasswordFailedStateJob(message: handleException(e, stackTrace).message));
  //     if (kDebugMode) {
  //       print("error: $e \n stackTrace: $stackTrace");
  //     }
  //   }
  // }

  // //for match otp
  // Future<void> _matchOtp(MatchOtpEventJob event, Emitter<AuthJobState> emit) async {
  //   emit(MatchOtpLoadingStateJob());
  //   try {
  //     final result = await _matchOtpUsecase(event.matchOtpModelJob);
  //     result.fold((ifLeft) => emit(MatchOtpFailedStateJob(message: ifLeft.message)), (ifRight) => emit(MatchOtpSuccessStateJob()));
  //   } catch (e, stackTrace) {
  //     emit(MatchOtpFailedStateJob(message: handleException(e, stackTrace).message));
  //     if (kDebugMode) {
  //       print("error: $e \n stackTrace: $stackTrace");
  //     }
  //   }
  // }

  // //for resend otp
  // Future<void> _resendOtp(ResendOtpEventJob event, Emitter<AuthJobState> emit) async {
  //   try {
  //     await _sendOtpUsecase(event.sendEmailOtpModelJob);
  //   } on Exception catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print("_resendOtp error: $e \n stackTrace: $stackTrace");
  //     }
  //   }
  // }

  Future<void> _logout(LogOutEvent event, Emitter<AuthJobState> emit) async {
    try {
      final token = await getIt<AuthLocalDB>().getToken();
      await getIt<AuthLocalDB>().removeToken();
      // SocketNotificationService().disconnect();
      emit(LogOutSuccessState());
      if (token != null) {
        getIt<ApiClient2>().post(url: AppUrls.logoutJobSeeker, tokenAuthorization: token).catchError((e) {
          debugPrint("Background logout error: $e");
        });
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("error: $e \n stackTrace: $stackTrace");
      }
    }
  }

  //! for password Change

  // Future<void> _passwordChange(PasswordChangeEvent event, Emitter<AuthJobState> emit) async {
  //   emit(PasswordChangeLoadingState());
  //   try {
  //     final result = await _changePasswordUsecase(
  //       ChangePasswordEntity(oldPassword: event.passwordChangeModel.oldPassword, newPassword: event.passwordChangeModel.newPassword),
  //     );
  //     result.fold((l) => emit(PasswordChangeErrorState(message: l.message)), (r) {
  //       emit(PasswordChangeSuccessState());
  //     });
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print("error: $e \n stackTrace:$stackTrace");
  //     }
  //   }
  // }

  //for get profile
  String? profileImage;
  Future<void> _getProfile(GetProfileJobSeekerEvent event, Emitter<AuthJobState> emit) async {
    if (event.profile != null) {
      final r = event.profile!;
      profileImage = r.photo;
      emit(GetProfileJobSeekerSuccessState(profileGetJobSeekerModel: r));
      String userId = r.userId.toString();
      String userType = r.userType.toString();
      await getIt<AuthLocalDB>().setUserId(userId);
      await getIt<AuthLocalDB>().setUserType(userType);
      await getIt<AuthLocalDB>().setAccountStatus(r.accountStatus ?? '');
      if (r.preferredJob != null) {
        await getIt<AuthLocalDB>().setPreferredJob(r.preferredJob);
      }
      // await SocketNotificationService().initSocketForJobSeeker(r.userId.toString());
      return;
    }

    final token = await getIt<AuthLocalDB>().getToken();
    if (token == null || token.isEmpty) {
      emit(GetProfileJobSeekerFailedState(message: 'Not logged in'));
      return;
    }
    if ((state is GetProfileJobSeekerSuccessState || state is GetProfileJobSeekerLoadingState) && !event.isRefresh) {
      return;
    }
    emit(GetProfileJobSeekerLoadingState());
    final result = await ProfileJobSeekerRemoteDataSource.getProfile();
    await result.fold(
      (l) async => emit(GetProfileJobSeekerFailedState(message: l.message)),
      (r) async {
        profileImage = r.photo;
        emit(GetProfileJobSeekerSuccessState(profileGetJobSeekerModel: r));
        String userId = r.userId.toString();
        String userType = r.userType.toString();
        await getIt<AuthLocalDB>().setUserId(userId);
        await getIt<AuthLocalDB>().setUserType(userType);
        await getIt<AuthLocalDB>().setAccountStatus(r.accountStatus ?? '');
        if (r.preferredJob != null) {
          await getIt<AuthLocalDB>().setPreferredJob(r.preferredJob);
        }
        // await SocketNotificationService().initSocketForJobSeeker(r.userId.toString());
      },
    );
  }

  //for update profile
  // Future<void> _updateProfile(UpdateProfileJobSeekerEvent event, Emitter<AuthJobState> emit) async {
  //   emit(UpdateProfileJobSeekerLoadingState());
  //   try {
  //     final result = await ProfileJobSeekerRemoteDataSource.updateProfile(payload: event.profileUpdateJobSeekerModel, file: event.files);
  //     await result.fold(
  //       (ifLeft) async => emit(UpdateProfileJobSeekerFailedState(message: ifLeft.message)),
  //       (ifRight) async {
  //         if (event.profileUpdateJobSeekerModel.preferredJob != null) {
  //           await getIt<AuthLocalDB>().setPreferredJob(event.profileUpdateJobSeekerModel.preferredJob);
  //         }
  //         profileImage = ifRight.photo;
  //         emit(UpdateProfileJobSeekerSuccessState());
  //         emit(GetProfileJobSeekerSuccessState(profileGetJobSeekerModel: ifRight));
  //       },
  //     );
  //   } catch (e, stackTrace) {
  //     emit(UpdateProfileJobSeekerFailedState(message: handleException(e, stackTrace).message));
  //     if (kDebugMode) {
  //       print("error: $e \n stackTrace: $stackTrace");
  //     }
  //   }
  // }

  //for update verify documents (id_copy, work_permit)
  // Future<void> _updateVerifyDocuments(UpdateVerifyDocumentsJobSeekerEvent event, Emitter<AuthJobState> emit) async {
  //   emit(UpdateVerifyDocumentsJobSeekerLoadingState());
  //   try {
  //     final result = await ProfileJobSeekerRemoteDataSource.updateVerifyDocuments(files: event.files);
  //     result.fold(
  //       (ifLeft) => emit(UpdateVerifyDocumentsJobSeekerFailedState(message: ifLeft.message)),
  //       (ifRight) => emit(UpdateVerifyDocumentsJobSeekerSuccessState(data: ifRight)),
  //     );
  //   } catch (e, stackTrace) {
  //     emit(UpdateVerifyDocumentsJobSeekerFailedState(message: handleException(e, stackTrace).message));
  //     if (kDebugMode) {
  //       print("error: $e \n stackTrace: $stackTrace");
  //     }
  //   }
  // }
}

