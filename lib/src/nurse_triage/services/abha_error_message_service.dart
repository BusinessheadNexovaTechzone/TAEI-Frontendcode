import 'dart:async';

class AbhaErrorMessageService {
  static const generic = 'Something went wrong. Please try again.';

  static String required(String field) {
    switch (field) {
      case 'aadhaar': return 'Please enter your Aadhaar number.';
      case 'mobile': return 'Please enter your mobile number.';
      case 'otp': return 'Please enter the OTP.';
      case 'abhaNumber': return 'Please enter your ABHA number.';
      case 'abhaAddress': return 'Please enter your ABHA address.';
      default: return 'Please complete all required details and try again.';
    }
  }

  static String invalid(String field, {bool incomplete = false}) {
    switch (field) {
      case 'aadhaar':
        return incomplete ? 'Please enter a valid 12-digit Aadhaar number.' : 'Please check your Aadhaar number and enter it again.';
      case 'mobile': return 'Please enter a valid 10-digit mobile number.';
      case 'otp':
        return incomplete ? 'Please enter the complete OTP.' : 'The OTP you entered is incorrect. Please check it and try again.';
      case 'abhaNumber': return incomplete ? 'Please enter a valid ABHA number.' : 'Please check your ABHA number and enter it again.';
      case 'abhaAddress': return 'Please enter a valid ABHA address.';
      default: return generic;
    }
  }

  static String map(dynamic error, {String context = 'generic', int? statusCode}) {
    final code = statusCode ?? _statusCode(error);
    final text = _text(error).toLowerCase();
    if (error is TimeoutException || _has(text, ['timeout', 'timed out'])) return 'The request is taking too long. Please check your connection and try again.';
    if (_has(text, ['socketexception', 'connection error', 'connection refused', 'failed host lookup', 'no internet', 'network error', 'unable to connect'])) return 'Please check your internet connection and try again.';
    if (_has(text, ['unauthorized', 'invalid token', 'bearer token', 'jwt'])) return 'Your session has expired. Please try again.';
    if (_has(text, ['uidai error code : 998', 'aadhaar number is incorrect', 'invalid aadhaar', 'invalid loginid', 'loginid is invalid'])) return 'The Aadhaar number you entered appears to be incorrect.\n\nPlease check your 12-digit Aadhaar number and try again.';
    if (_has(text, ['too many', 'rate limit', 'maximum attempts'])) return context == 'otp' ? 'Too many incorrect attempts. Please request a new OTP and try again.' : 'Too many requests. Please wait a moment and try again.';
    if (_has(text, ['expired', 'otp expired'])) return 'This OTP has expired. Please request a new OTP.';
    if (_has(text, ['wrong otp', 'invalid otp', 'incorrect otp', 'otp mismatch', 'otp validation failed', 'authresult failed'])) return 'The OTP you entered is incorrect or has expired.\n\nPlease check the OTP and try again, or request a new OTP.';
    if (_has(text, ['not linked', 'mobile linked', 'mobile linkage'])) return 'This Aadhaar number is not linked with the required mobile number. Please check and try again.';
    if (_has(text, ['not found', 'does not exist', 'no profile'])) {
      if (context == 'abhaNumber') return 'We couldn\'t find an ABHA profile with this number. Please check and try again.';
      if (context == 'abhaAddress') return 'We couldn\'t find this ABHA address. Please check it and try again.';
      if (context == 'profile') return 'We couldn\'t find your ABHA profile. Please try again.';
    }
    if (context == 'abhaAddressCreate' &&
        _has(text, ['abdm-1101', 'already exists', 'unique address'])) {
      return 'This ABHA Address is already in use.\n\nPlease choose a different ABHA Address.';
    }
    if (_has(text, ['already exists', 'already registered']) && context == 'createProfile') return 'An ABHA profile already exists for these details.';
    if (_has(text, ['aadhaar', 'loginid'])) return context == 'aadhaar' ? 'We couldn\'t verify this Aadhaar number. Please check the number and try again.' : 'Please check your Aadhaar number and enter it again.';
    if (_has(text, ['mobile'])) return 'This mobile number could not be verified. Please check the number and try again.';
    if (_has(text, ['abha address', 'address'])) return 'We couldn\'t verify this ABHA address. Please check the address and try again.';
    if (_has(text, ['abha number', 'health id'])) return 'We couldn\'t verify this ABHA number. Please try again.';
    if (context == 'card') return 'We couldn\'t download your ABHA card. Please try again.';
    if (context == 'profile') return 'We couldn\'t load your ABHA profile. Please try again.';
    if (context == 'createProfile') return 'We couldn\'t create your ABHA profile right now. Please try again.';
    if (context == 'resendOtp') return 'We couldn\'t send a new OTP. Please try again.';
    if (context == 'generateOtp') return 'We couldn\'t send the OTP right now. Please try again.';
    switch (code) {
      case 400: return 'Please check the information entered and try again.';
      case 401: return 'Your session has expired. Please try again.';
      case 403: return 'You are not authorized to complete this request. Please try again.';
      case 404: return 'The requested information could not be found.';
      case 408: return 'The request took too long. Please try again.';
      case 429: return 'Too many requests. Please wait a moment and try again.';
      case 500: return 'Something went wrong on the server. Please try again later.';
      case 502:
      case 503:
      case 504: return 'The service is temporarily unavailable. Please try again later.';
    }
    return generic;
  }

  static bool isFailure(dynamic response) {
    if (response == null) return true;
    if (response is! Map) return false;

    final statusCode = _statusCode(response);
    if (statusCode != null && (statusCode < 200 || statusCode >= 300)) {
      return true;
    }

    final success = response['success']?.toString().toLowerCase();
    final status = response['status']?.toString().toLowerCase();
    final authResult = response['authResult']?.toString().toLowerCase();
    if (success == 'false' ||
        status == 'failed' ||
        status == 'failure' ||
        status == 'error' ||
        authResult == 'failed' ||
        response['error'] != null) {
      return true;
    }

    final text = _text(response).toLowerCase();
    return _has(text, [
      'invalid loginid',
      'invalid mobile number',
      'validation failed',
      'invalid transaction',
      'transaction expired',
    ]);
  }

  static int? _statusCode(dynamic error) {
    if (error is Map) return int.tryParse((error['statusCode'] ?? error['status_code'])?.toString() ?? '');
    return null;
  }

  static String _text(dynamic error) {
    if (error == null) return '';
    if (error is String) return error;
    if (error is Map) {
      for (final key in ['message', 'error', 'detail', 'code']) {
        final value = error[key];
        if (value != null) {
          final text = _text(value);
          if (text.isNotEmpty) return text;
        }
      }
      return error.values.map(_text).firstWhere((value) => value.isNotEmpty, orElse: () => '');
    }
    if (error is Iterable) return error.map(_text).firstWhere((value) => value.isNotEmpty, orElse: () => '');
    return error.toString();
  }

  static bool _has(String text, List<String> terms) => terms.any(text.contains);
}
