import 'dart:convert';

ProfileGetJobSeekerModel profileGetJobSeekerModelFromJson(String str) =>
    ProfileGetJobSeekerModel.fromJson(json.decode(str));

class ProfileGetJobSeekerModel {
  final dynamic userId;
  final dynamic email;
  final dynamic name;
  final dynamic phoneNumber;
  final dynamic photo;
  final bool? userStatus;
  final dynamic userType;
  final dynamic userCreatedAt;
  final dynamic dateOfBirth;
  final dynamic gender;
  final dynamic workPermit;
  final dynamic idCopy;
  final dynamic accountStatus;
  final bool? isCompleted;
  final dynamic completedAt;
  final bool? finalCompleted;
  final dynamic finalCompletedAt;
  final dynamic homeLocationId;
  final dynamic homeLocationName;
  final dynamic homeAddress;
  final dynamic homePostalCode;
  final bool? homeStatus;
  final bool? isHomeAddress;
  final dynamic totalEarnings;
  final dynamic todayEarnings;
  final dynamic totalPayout;
  final dynamic availableBalance;
  final List<dynamic>? bankDetails;
  final bool? isWaitingForApproval;
  final List<dynamic>? appliedJobs;
  final bool? is2FaOn;
  final dynamic preferredJob;
  final dynamic city;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic country;
  final dynamic state;
  final dynamic pendingPayoutAmount;

  ProfileGetJobSeekerModel({

    this.userId,
    this.email,
    this.name,
    this.phoneNumber,
    this.photo,
    this.userStatus,
    this.userType,
    this.userCreatedAt,
    this.dateOfBirth,
    this.gender,
    this.workPermit,
    this.idCopy,
    this.accountStatus,
    this.isCompleted,
    this.completedAt,
    this.finalCompleted,
    this.finalCompletedAt,
    this.homeLocationId,
    this.homeLocationName,
    this.homeAddress,
    this.homePostalCode,
    this.homeStatus,
    this.isHomeAddress,
    this.totalEarnings,
    this.todayEarnings,
    this.totalPayout,
    this.availableBalance,
    this.bankDetails,
    this.isWaitingForApproval,
    this.appliedJobs,
    this.is2FaOn,
    this.preferredJob,
    this.city,
    this.latitude,
    this.longitude,
    this.country,
    this.state,
    this.pendingPayoutAmount,
  });

  factory ProfileGetJobSeekerModel.fromJson(Map<String, dynamic> json) =>
      ProfileGetJobSeekerModel(
        userId: json["user_id"],
        email: json["email"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        photo: json["photo"],
        userStatus: json["user_status"],
        userType: json["user_type"],
        userCreatedAt: json["user_created_at"],
        dateOfBirth: json["date_of_birth"],
        gender: json["gender"],
        workPermit: json["work_permit"],
        idCopy: json["id_copy"],
        accountStatus: json["account_status"],
        isCompleted: json["is_completed"],
        completedAt: json["completed_at"],
        finalCompleted: json["final_completed"],
        finalCompletedAt: json["final_completed_at"],
        homeLocationId: json["home_location_id"],
        homeLocationName: json["home_location_name"] ?? json["area"] ?? json["location_name"],
        homeAddress: json["home_address"] ?? json["address"] ?? json["own_address[address]"],
        homePostalCode: json["home_postal_code"] ?? json["postal_code"] ?? json["own_address[postal_code]"],
        homeStatus: json["home_status"],
        isHomeAddress: json["is_home_address"],
        totalEarnings: json["total_earnings"],
        todayEarnings: json["today_earnings"],
        totalPayout: json["total_payout"],
        availableBalance: json["available_balance"],
        bankDetails: json["bank_details"] == null
            ? []
            : List<dynamic>.from(json["bank_details"]!.map((x) => x)),
        isWaitingForApproval: json["is_waiting_for_approval"],
        appliedJobs: json["applied_jobs"] == null
            ? []
            : List<dynamic>.from(json["applied_jobs"]!.map((x) => x)),
        is2FaOn: json["is_2fa_on"] is bool
            ? json["is_2fa_on"]
            : (json["is_2fa_on"] == "true" ||
                json["is_2fa_on"] == 1 ||
                json["is_2fa_on"] == "1"),
        preferredJob: json["preferred_job"],
        city: json["city"] ?? json["home_city"] ?? json["own_address[city]"],
        latitude: json["latitude"] ?? json["home_latitude"] ?? json["own_address[latitude]"],
        longitude: json["longitude"] ?? json["home_longitude"] ?? json["own_address[longitude]"],
        country: json["country"] ?? json["home_country"] ?? json["own_address[country]"],
        state: json["state"] ?? json["home_state"] ?? json["own_address[state]"],
        pendingPayoutAmount: json["pending_payout_amount"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "name": name,
        "phone_number": phoneNumber,
        "photo": photo,
        "user_status": userStatus,
        "user_type": userType,
        "user_created_at": userCreatedAt,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "work_permit": workPermit,
        "id_copy": idCopy,
        "account_status": accountStatus,
        "is_completed": isCompleted,
        "completed_at": completedAt,
        "final_completed": finalCompleted,
        "final_completed_at": finalCompletedAt,
        "home_location_id": homeLocationId,
        "home_location_name": homeLocationName,
        "home_address": homeAddress,
        "home_postal_code": homePostalCode,
        "home_status": homeStatus,
        "is_home_address": isHomeAddress,
        "total_earnings": totalEarnings,
        "today_earnings": todayEarnings,
        "total_payout": totalPayout,
        "available_balance": availableBalance,
        "bank_details": bankDetails,
        "is_waiting_for_approval": isWaitingForApproval,
        "applied_jobs": appliedJobs,
        "is_2fa_on": is2FaOn,
        "preferred_job": preferredJob,
        "city": city,
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
        "state": state,
        "pending_payout_amount": pendingPayoutAmount,
      };

  double get parsedPendingPayoutAmount {
    if (pendingPayoutAmount == null) return 0.0;
    if (pendingPayoutAmount is num) {
      return (pendingPayoutAmount as num).toDouble();
    }
    if (pendingPayoutAmount is String) {
      return double.tryParse(pendingPayoutAmount.toString().trim()) ?? 0.0;
    }
    return 0.0;
  }

  bool get hasPendingPayout => parsedPendingPayoutAmount > 0;
}

