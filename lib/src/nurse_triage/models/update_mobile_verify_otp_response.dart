class UpdateMobileAccount {
  final String? abhaNumber;
  final bool? mobileVerified;

  UpdateMobileAccount({
    this.abhaNumber,
    this.mobileVerified,
  });

  factory UpdateMobileAccount.fromJson(Map<String, dynamic> json) {
    return UpdateMobileAccount(
      abhaNumber: json['ABHANumber']?.toString() ?? json['abhaNumber']?.toString(),
      mobileVerified: json['mobileVerified'] is bool
          ? json['mobileVerified'] as bool
          : null,
    );
  }
}

class UpdateMobileVerifyOtpResponse {
  final String? txnId;
  final String? authResult;
  final String? message;
  final List<UpdateMobileAccount> accounts;

  UpdateMobileVerifyOtpResponse({
    this.txnId,
    this.authResult,
    this.message,
    required this.accounts,
  });

  bool get isSuccess => (authResult ?? '').toLowerCase() == 'success';

  factory UpdateMobileVerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    final rawAccounts = json['accounts'];
    final parsedAccounts = <UpdateMobileAccount>[];

    if (rawAccounts is List) {
      for (final item in rawAccounts) {
        if (item is Map<String, dynamic>) {
          parsedAccounts.add(UpdateMobileAccount.fromJson(item));
        } else if (item is Map) {
          parsedAccounts.add(UpdateMobileAccount.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return UpdateMobileVerifyOtpResponse(
      txnId: json['txnId']?.toString(),
      authResult: json['authResult']?.toString(),
      message: json['message']?.toString(),
      accounts: parsedAccounts,
    );
  }
}
