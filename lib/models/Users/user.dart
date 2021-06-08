import 'package:gas_gameappstore/models/base.dart';

class User extends Model {
  static const String USER_EMAIL_KEY = "userEmail";
  static const String USER_NAME_KEY = "userName";
  static const String USER_PASSWORD_KEY = "userPassword";
  static const String USER_DATE_OF_BIRTH_KEY = "userDOB";
  static const String USER_GENDER_KEY = "userGender";
  static const String USER_PHONE_NUMBER_KEY = "userPhoneNumber";
  static const String USER_ADDRESS_KEY = "userAddress";
  static const String USER_TRANSACTION_PIN_KEY = "userTransactionPIN";
  static const String USER_ROLE_KEY = "userRole";
  static const String USER_PROFILE_PICTURE_KEY = "userProfilePicture";

  BigInt userId;
  String userEmail;
  String userName;
  String userPassword;
  String userDOB;
  String userGender;
  String userPhoneNumber;
  String userAddress;
  String userTransactionPIN;
  String userRole;
  String userProfilePicture;

  User(
      {String id,
      this.userEmail,
      this.userName,
      this.userPassword,
      this.userGender,
      this.userDOB,
      this.userPhoneNumber,
      this.userAddress,
      this.userTransactionPIN,
      this.userRole,
      this.userProfilePicture})
      : super(id);

  factory User.fromMap(Map<String, dynamic> map, {String id}) {
    return User(
        id: id,
        userEmail: map[USER_EMAIL_KEY],
        userName: map[USER_NAME_KEY],
        userPassword: map[USER_PASSWORD_KEY],
        userDOB: map[USER_DATE_OF_BIRTH_KEY],
        userGender: map[USER_GENDER_KEY],
        userPhoneNumber: map[USER_PHONE_NUMBER_KEY],
        userAddress: map[USER_ADDRESS_KEY],
        userTransactionPIN: map[USER_TRANSACTION_PIN_KEY],
        userRole: map[USER_ROLE_KEY],
        userProfilePicture: map[USER_PROFILE_PICTURE_KEY]);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      USER_EMAIL_KEY: userEmail,
      USER_NAME_KEY: userName,
      USER_PASSWORD_KEY: userPassword,
      USER_DATE_OF_BIRTH_KEY : userDOB,
      USER_GENDER_KEY : userGender,
      USER_PHONE_NUMBER_KEY: userPhoneNumber,
      USER_ADDRESS_KEY: userAddress,
      USER_TRANSACTION_PIN_KEY: userTransactionPIN,
      USER_ROLE_KEY: userRole,
      USER_PROFILE_PICTURE_KEY: userProfilePicture,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (userEmail != null) map[USER_EMAIL_KEY] = userEmail;
    if (userName != null) map[USER_NAME_KEY] = userName;
    if (userPassword != null) map[USER_PASSWORD_KEY] = userPassword;
    if (userDOB != null) map[USER_DATE_OF_BIRTH_KEY] = userDOB;
    if (userGender != null) map[USER_GENDER_KEY] = userGender;
    if (userPhoneNumber != null) map[USER_PHONE_NUMBER_KEY] = userPhoneNumber;
    if (userAddress != null) map[USER_ADDRESS_KEY] = userAddress;
    if (userTransactionPIN != null) map[USER_TRANSACTION_PIN_KEY] = userRole;
    if (userRole != null) map[USER_ROLE_KEY] = userRole;
    if (userProfilePicture != null) map[USER_PROFILE_PICTURE_KEY] = userProfilePicture;
    return map;
  }
}

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     userId: json['UserId'] as BigInt,
  //     userEmail: json['UserEmail'] as String,
  //     userName: json['UserName'] as String,
  //     userPassword: json['UserPassword'] as String,
  //     userPhoneNumber: json['UserPhoneNumber'] as String,
  //     userAddress: json['UserAddress'] as String,
  //     userTransactionPIN: json['UserTransactionPIN'] as String,
  //     userRole: json['UserRole'] as String,
  //     userProfilePicture: json['UserProfilePicture'] as String,
  //   );
  // }

  // User.WithId(
  //     this._userId,
  //     this._userEmail,
  //     this._userName,
  //     this._userPassword,
  //     this._userPhoneNumber,
  //     this._userAddress,
  //     this._userTransactionPIN,
  //     this._userRole,
  //     this._userProfilePicture);

  // int get userId => _userId;
  // String get userEmail => _userEmail;
  // String get userName => _userName;
  // String get userPassword => _userPassword;
  // String get userPhoneNumber => _userPhoneNumber;
  // String get userAddress => _userAddress;
  // String get userTransactionPIN => _userTransactionPIN;
  // String get userRole => _userRole;
  // String get userProfilePicture => _userProfilePicture;

  // set userEmail(String newuserEmail) {
  //   _userEmail = newuserEmail;
  // }

  // set userName(String newuserName) {
  //   _userName = newuserName;
  // }

  // set userPassword(String newuserPassword) {
  //   _userPassword = newuserPassword;
  // }

  // set userPhoneNumber(String newuserPhoneNumber) {
  //   _userPhoneNumber = newuserPhoneNumber;
  // }

  // set userAddress(String newuserAddress) {
  //   _userAddress = newuserAddress;
  // }

  // set userTransactionPIN(String newuserTransactionPIN) {
  //   _userTransactionPIN = newuserTransactionPIN;
  // }

  // set userRole(String newuserRole) {
  //   _userRole = newuserRole;
  // }

  // set userProfilePicture(String newuserProfilePicture) {
  //   _userProfilePicture = newuserProfilePicture;
  // }

  // Map<String, dynamic> toMap() {
  //   var map = Map<String, dynamic>();
  //   map["userEmail"] = _userEmail;
  //   map["userName"] = _userName;
  //   map["userPassword"] = _userPassword;
  //   map["userPhoneNumber"] = _userPhoneNumber;
  //   map["userAddress"] = _userAddress;
  //   map["userTransactionPIN"] = _userTransactionPIN;
  //   map["userRole"] = _userRole;
  //   map["userProfilePicture"] = _userProfilePicture;

  //   if (_userId != null) {
  //     map["userId"] = _userId;
  //   }
  //   return map;
  // }

  // User.fromObject(dynamic o) {
  //   this._userId = o["userId"];
  //   this._userEmail = o["userEmail"];
  //   this._userName = o["userName"];
  //   this._userPassword = o["userPassword"];
  //   this._userPhoneNumber = o["userPhoneNumber"];
  //   this._userAddress = o["userAddress"];
  //   this._userTransactionPIN = o["userTransactionPIN"];
  //   this._userRole = o["userRole"];
  //   this._userProfilePicture = o["userProfilePicture"];
  // }

