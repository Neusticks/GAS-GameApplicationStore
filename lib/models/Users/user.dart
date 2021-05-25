class User {
  BigInt userId;
  String userEmail;
  String userName;
  String userPassword;
  String userPhoneNumber;
  String userAddress;
  String userTransactionPIN;
  String userRole;
  String userProfilePicture;

  User(
      {
      this.userId,
      this.userEmail,
      this.userName,
      this.userPassword,
      this.userPhoneNumber,
      this.userAddress,
      this.userTransactionPIN,
      this.userRole,
      this.userProfilePicture});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['UserId'] as BigInt,
      userEmail: json['UserEmail'] as String,
      userName: json['UserName'] as String,
      userPassword: json['UserPassword'] as String,
      userPhoneNumber: json['UserPhoneNumber'] as String,
      userAddress: json['UserAddress'] as String,
      userTransactionPIN: json['UserTransactionPIN'] as String,
      userRole: json['UserRole'] as String,
      userProfilePicture: json['UserProfilePicture'] as String,
    );
  }

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

}
