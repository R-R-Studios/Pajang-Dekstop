class PasswordUpdateRequest {
  String? otpCode;
  String? phoneNumber;
  String? password;
  String? passwordConfirmation;

  PasswordUpdateRequest(
      {this.otpCode, this.phoneNumber, this.password, this.passwordConfirmation});

  PasswordUpdateRequest.fromJson(Map<String, dynamic> json) {
    otpCode = json['otp_code'];
    phoneNumber = json['phone_number'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp_code'] = this.otpCode;
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    return data;
  }
}
