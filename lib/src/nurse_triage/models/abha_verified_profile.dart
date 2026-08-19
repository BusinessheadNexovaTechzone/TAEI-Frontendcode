import 'dart:convert';

class AbhaVerifiedProfile {
  final int? profileId;
  final String abhaNumber;
  final String abhaAddress;
  final String name;
  final String dateOfBirth;
  final String age;
  final String gender;
  final String mobile;
  final String verificationStatus;
  final String verificationType;
  final String status;
  final String profilePhoto;
  final String state;
  final String district;
  final String pincode;
  final String address;

  const AbhaVerifiedProfile({
    required this.profileId,
    required this.abhaNumber,
    required this.abhaAddress,
    required this.name,
    required this.dateOfBirth,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.verificationStatus,
    required this.verificationType,
    required this.status,
    required this.profilePhoto,
    required this.state,
    required this.district,
    required this.pincode,
    required this.address,
  });

  factory AbhaVerifiedProfile.fromResponse(Map<String, dynamic> response) {
    return fromProfileMap(response);
  }

  static List<AbhaVerifiedProfile> fromResponseList(
      Map<String, dynamic> response) {
    final profileMaps = _extractProfileMaps(response);
    final containerProfileIds = _extractContainerProfileIds(response);
    final profiles = profileMaps
        .asMap()
        .entries
        .map((entry) {
          final profileMap = Map<String, dynamic>.from(entry.value);
          final parsedProfile = fromProfileMap(profileMap);
          if (parsedProfile.profileId != null) return parsedProfile;

          final containerId = containerProfileIds.length == profileMaps.length
              ? containerProfileIds[entry.key]
              : profileMaps.length == 1 && containerProfileIds.isNotEmpty
                  ? containerProfileIds.first
                  : null;
          if (containerId == null) return parsedProfile;

          profileMap['profileId'] = containerId;
          return fromProfileMap(profileMap);
        })
        .toList(growable: false);

    print('[ABHA][PROFILE-LIST] Total profiles: ${profiles.length}');
    for (var index = 0; index < profiles.length; index++) {
      final profile = profiles[index];
      print('[ABHA][PROFILE] Index: $index');
      print('[ABHA][PROFILE] Profile ID: ${profile.profileId ?? 'Not Available'}');
      print('[ABHA][PROFILE] Name: ${profile.name}');
      print('[ABHA][PROFILE] ABHA Number: ${profile.abhaNumber}');
      print('[ABHA][PROFILE] ABHA Address: ${profile.abhaAddress}');
      print('[ABHA][PROFILE] DOB: ${profile.dateOfBirth}');
      print('[ABHA][PROFILE] Age: ${profile.age}');
      print('[ABHA][PROFILE] Gender: ${profile.gender}');
      print('[ABHA][PROFILE] Mobile: ${profile.mobile}');
      print('[ABHA][PROFILE] Status: ${profile.status}');
    }

    return profiles;
  }

  static List<int> _extractContainerProfileIds(Map<String, dynamic> response) {
    final values = <int>[];

    void addValue(Object? value) {
      if (value is List) {
        for (final item in value) {
          final parsed = int.tryParse(item?.toString() ?? '');
          if (parsed != null && parsed > 0) values.add(parsed);
        }
        return;
      }

      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null && parsed > 0) values.add(parsed);
    }

    for (final key in const [
      'profileId',
      'profile_id',
      'abhaProfileId',
      'abha_profile_id',
      'profileIds',
      'profile_ids',
    ]) {
      addValue(response[key]);
    }

    for (final wrapperKey in const ['result', 'data']) {
      final wrapper = response[wrapperKey];
      if (wrapper is Map) {
        for (final key in const [
          'profileId',
          'profile_id',
          'abhaProfileId',
          'abha_profile_id',
          'profileIds',
          'profile_ids',
        ]) {
          addValue(wrapper[key]);
        }
      }
    }

    return values;
  }

  static AbhaVerifiedProfile fromProfileMap(Map<String, dynamic> response) {
    final mergedResponse = _mergeProfileMaps(response);
    final flattened = _flattenMap(mergedResponse);

    final abhaNumber = _readString(flattened, [
      'abhanumber',
      'abhaNumber',
      'healthIdNumber',
      'healthId',
      'health_id',
      'abha_number',
    ]);
    final profileId = int.tryParse(_readString(flattened, [
      'profileid',
      'abhaprofileid',
      'abha_profile_id',
      'profile_id',
      'id',
    ]));
    final abhaAddress = _readString(flattened, [
      'preferredabhaaddress',
      'preferredAbhaAddress',
      'abhaaddress',
      'preferred_abha_address',
      'healthId',
      'phrAddress',
      'address',
      'residentialAddress',
    ]);
    final name = _buildName(flattened);
    final dob = _buildDob(flattened);
    final gender = _buildGender(flattened);
    final mobile = _readString(flattened, [
      'mobile',
      'mobilenumber',
      'communicationMobile',
      'profileMobile',
      'phone',
      'phonenumber',
    ]);
    final verificationStatus = _readString(flattened, [
      'verifiedstatus',
      'verificationstatus',
      'verified_status',
    ]);
    final verificationType = _readString(flattened, [
      'verificationtype',
      'verificationmethod',
      'verification_method',
    ]);
    final status = _readString(flattened, [
      'abhaStatus',
      'accountStatus',
      'status',
    ]);
    final photoRaw = _readString(flattened, [
      'profilephoto',
      'profile_photo',
      'photo',
      'photobase64',
    ]);

    final normalizedPhoto = _normalizePhoto(photoRaw);
    final normalizedDob = _normalizeDobValue(dob);
    final apiAge = _readString(flattened, ['age']);
    final normalizedAge = apiAge == 'Not Available'
      ? _calculateAge(normalizedDob)
      : apiAge;
    final state = _readString(flattened, ['state', 'statename', 'state_name']);
    final district = _readString(flattened, ['district', 'districtname', 'district_name']);
    final pincode = _readString(flattened, ['pincode', 'pinCode', 'pin_code']);
    final address = _readString(flattened, ['residentialaddress', 'address', 'addressline']);

    print('========== ABHA VERIFICATION RESPONSE ==========' );
    print('Raw response: ${response.toString()}');
    print('ABHA Number: $abhaNumber');
    print('ABHA Address: $abhaAddress');
    print('Name: $name');
    print('DOB: $normalizedDob');
    print('Age: $normalizedAge');
    print('Gender: $gender');
    print('Mobile: $mobile');
    print('Verification Status: $verificationStatus');
    print('Verification Type: $verificationType');
    print('Account Status: $status');
    print('Profile Photo Available: ${normalizedPhoto.isNotEmpty}');
    print('========== NORMALIZED ABHA PROFILE ==========' );
    print('abhaNumber=$abhaNumber');
    print('abhaAddress=$abhaAddress');
    print('name=$name');
    print('dateOfBirth=$normalizedDob');
    print('age=$normalizedAge');
    print('gender=$gender');
    print('mobile=$mobile');
    print('verificationStatus=$verificationStatus');
    print('verificationType=$verificationType');
    print('status=$status');
    print('profilePhotoAvailable=${normalizedPhoto.isNotEmpty}');

    return AbhaVerifiedProfile(
      profileId: profileId,
      abhaNumber: abhaNumber,
      abhaAddress: abhaAddress,
      name: name,
      dateOfBirth: normalizedDob,
      age: normalizedAge,
      gender: gender,
      mobile: mobile,
      verificationStatus: verificationStatus,
      verificationType: verificationType,
      status: status,
      profilePhoto: normalizedPhoto,
      state: state,
      district: district,
      pincode: pincode,
      address: address,
    );
  }

  static Map<String, dynamic> _mergeProfileMaps(Map<String, dynamic> response) {
    final merged = <String, dynamic>{};
    final wrappers = <Map<String, dynamic>>[
      response,
      if (response['result'] is Map) Map<String, dynamic>.from(response['result'] as Map),
      if (response['data'] is Map) Map<String, dynamic>.from(response['data'] as Map),
      if (response['profile'] is Map) Map<String, dynamic>.from(response['profile'] as Map),
      if (response['ABHAProfile'] is Map) Map<String, dynamic>.from(response['ABHAProfile'] as Map),
    ];

    for (final map in wrappers) {
      merged.addAll(map.map((key, value) => MapEntry(key, value)));
    }

    return merged;
  }

  static List<Map<String, dynamic>> _extractProfileMaps(
      Map<String, dynamic> response) {
    Map<String, dynamic>? asMap(Object? value) {
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
      return null;
    }

    List<Map<String, dynamic>> fromValue(Object? value) {
      if (value is List) {
        return value
            .map(asMap)
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);
      }
      final map = asMap(value);
      return map == null ? const [] : [map];
    }

    final directCandidates = <Object?>[
      response['result'] is Map
          ? (response['result'] as Map)['ABHAProfile']
          : null,
      response['data'] is Map ? (response['data'] as Map)['ABHAProfile'] : null,
      response['ABHAProfile'],
      response['profiles'],
      response['accounts'],
    ];

    for (final candidate in directCandidates) {
      final profiles = fromValue(candidate);
      if (profiles.isNotEmpty) return profiles;
    }

    final result = response['result'];
    if (result is Map) {
      final nested = _extractProfileMaps(Map<String, dynamic>.from(result));
      if (nested.isNotEmpty) return nested;
    }

    final data = response['data'];
    if (data is Map) {
      final nested = _extractProfileMaps(Map<String, dynamic>.from(data));
      if (nested.isNotEmpty) return nested;
    }

    return [response];
  }

  static Map<String, dynamic> _flattenMap(Object? source) {
    final flattened = <String, dynamic>{};

    void walk(Object? node) {
      if (node is Map) {
        for (final entry in node.entries) {
          final key = entry.key.toString();
          final value = entry.value;
          if (value is Map || value is List) {
            walk(value);
          } else {
            final normalizedKey = key.toLowerCase();
            final existing = flattened[normalizedKey];
            if (existing == null || _isMissing(existing)) {
              if (!_isMissing(value) || existing == null) {
                flattened[normalizedKey] = value;
              }
            }
          }
        }
        return;
      }

      if (node is List) {
        for (final item in node) {
          walk(item);
        }
      }
    }

    walk(source);
    return flattened;
  }

  static dynamic _readAny(Map<String, dynamic> source, List<String> keys) {
    final lowerKeys = keys.map((key) => key.toLowerCase()).toSet();
    for (final key in lowerKeys) {
      if (source.containsKey(key) && !_isMissing(source[key])) {
        return source[key];
      }
    }
    return null;
  }

  static String _readString(Map<String, dynamic> source, List<String> keys) {
    final value = _readAny(source, keys);
    return displayValue(value);
  }

  static String displayValue(Object? value) {
    if (value == null) return 'Not Available';

    final text = value.toString().trim();
    if (text.isEmpty) return 'Not Available';

    final normalized = text.toLowerCase();
    if (normalized == 'null' ||
        normalized == 'n/a' ||
        normalized == 'na' ||
        normalized == 'not available' ||
        normalized == 'undefined') {
      return 'Not Available';
    }

    return text;
  }

  static bool _isMissing(Object? value) {
    if (value == null) return true;
    final text = value.toString().trim();
    if (text.isEmpty) return true;
    final normalized = text.toLowerCase();
    return normalized == 'null' ||
        normalized == 'n/a' ||
        normalized == 'na' ||
        normalized == 'not available' ||
        normalized == 'undefined';
  }

  static String _buildName(Map<String, dynamic> source) {
    final direct = _readAny(source, ['name', 'fullname', 'full_name']);
    if (direct != null && !_isMissing(direct)) {
      return displayValue(direct);
    }

    final firstName = _readAny(source, ['firstname']) ?? '';
    final middleName = _readAny(source, ['middlename']) ?? '';
    final lastName = _readAny(source, ['lastname']) ?? '';
    final name = [
      firstName.toString().trim(),
      middleName.toString().trim(),
      lastName.toString().trim(),
    ].where((part) => part.isNotEmpty).join(' ');

    return name.isEmpty ? 'Not Available' : name;
  }

  static String _buildDob(Map<String, dynamic> source) {
    final direct = _readAny(source, ['dob', 'dateofbirth', 'date_of_birth']);
    if (direct != null && !_isMissing(direct)) {
      return direct.toString();
    }

    final day = _readAny(source, ['dayofbirth', 'day_of_birth']);
    final month = _readAny(source, ['monthofbirth', 'month_of_birth']);
    final year = _readAny(source, ['yearofbirth', 'year_of_birth']);
    if (day != null && month != null && year != null) {
      return '$day-$month-$year';
    }

    return 'Not Available';
  }

  static String _normalizeDobValue(String value) {
    final text = value.trim();
    if (text.isEmpty || _isMissing(text)) return 'Not Available';

    final direct = text.replaceAll('/', '-');
    final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$');
    final match = iso.firstMatch(direct);
    if (match != null) {
      final year = match.group(1)!;
      final month = match.group(2)!.padLeft(2, '0');
      final day = match.group(3)!.padLeft(2, '0');
      return '$day-$month-$year';
    }

    final ddmmyyyy = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{2,4})$');
    final dd = ddmmyyyy.firstMatch(direct);
    if (dd != null) {
      final day = dd.group(1)!.padLeft(2, '0');
      final month = dd.group(2)!.padLeft(2, '0');
      final year = dd.group(3)!;
      final fullYear = year.length == 2 ? '19$year' : year;
      return '$day-$month-$fullYear';
    }

    try {
      final date = DateTime.parse(direct);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (_) {
      return displayValue(text);
    }
  }

  static String _buildGender(Map<String, dynamic> source) {
    final raw = _readAny(source, ['gender', 'sex']);
    if (raw == null || _isMissing(raw)) return 'Not Available';

    final value = raw.toString().trim();
    final lower = value.toLowerCase();
    if (lower == 'm' || lower == 'male') return 'Male';
    if (lower == 'f' || lower == 'female') return 'Female';
    return displayValue(value);
  }

  static String _normalizePhoto(String value) {
    if (value == 'Not Available' || value.isEmpty) return '';

    var clean = value.trim();
    if (clean.startsWith('data:image/')) {
      final marker = 'base64,';
      final index = clean.indexOf(marker);
      if (index >= 0) {
        clean = clean.substring(index + marker.length);
      }
    }

    try {
      base64Decode(clean);
      return clean;
    } catch (_) {
      return '';
    }
  }

  static String _calculateAge(String dob) {
    if (dob == 'Not Available') return 'Not Available';
    final date = _parseDob(dob);
    if (date == null) return 'Not Available';

    final now = DateTime.now();
    var years = now.year - date.year;
    if (now.month < date.month || (now.month == date.month && now.day < date.day)) {
      years--;
    }

    return years >= 0 ? '$years years' : 'Not Available';
  }

  static DateTime? _parseDob(String dob) {
    final text = dob.trim();
    if (text.isEmpty || text == 'Not Available') return null;

    final iso = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})$');
    final match = iso.firstMatch(text);
    if (match != null) {
      final day = int.tryParse(match.group(1)!);
      final month = int.tryParse(match.group(2)!);
      final year = int.tryParse(match.group(3)!);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    final slash = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');
    final slashMatch = slash.firstMatch(text);
    if (slashMatch != null) {
      final day = int.tryParse(slashMatch.group(1)!);
      final month = int.tryParse(slashMatch.group(2)!);
      final year = int.tryParse(slashMatch.group(3)!);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    try {
      return DateTime.parse(text.replaceAll('/', '-'));
    } catch (_) {
      return null;
    }
  }
}
