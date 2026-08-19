// LGD State and District models for ABHA enrollment

class LGDState {
  final String name;
  final int code;

  LGDState({
    required this.name,
    required this.code,
  });
}

class LGDDistrict {
  final String name;

  LGDDistrict({
    required this.name,
  });
}

// LGD States - Currently only Tamil Nadu
final List<LGDState> lgdStates = [
  LGDState(name: 'Tamil Nadu', code: 33),
];

// LGD Districts for Tamil Nadu
final List<LGDDistrict> tamilNaduDistricts = [
  LGDDistrict(name: 'Ariyalur'),
  LGDDistrict(name: 'Chengalpattu'),
  LGDDistrict(name: 'Chennai'),
  LGDDistrict(name: 'Coimbatore'),
  LGDDistrict(name: 'Cuddalore'),
  LGDDistrict(name: 'Dharmapuri'),
  LGDDistrict(name: 'Dindigul'),
  LGDDistrict(name: 'Erode'),
  LGDDistrict(name: 'Kallakurichi'),
  LGDDistrict(name: 'Kancheepuram'),
  LGDDistrict(name: 'Kanniyakumari'),
  LGDDistrict(name: 'Karur'),
  LGDDistrict(name: 'Krishnagiri'),
  LGDDistrict(name: 'Madurai'),
  LGDDistrict(name: 'Mayiladuthurai'),
  LGDDistrict(name: 'Nagapattinam'),
  LGDDistrict(name: 'Namakkal'),
  LGDDistrict(name: 'Perambalur'),
  LGDDistrict(name: 'Pudukkottai'),
  LGDDistrict(name: 'Ramanathapuram'),
  LGDDistrict(name: 'Ranipet'),
  LGDDistrict(name: 'Salem'),
  LGDDistrict(name: 'Sivaganga'),
  LGDDistrict(name: 'Tenkasi'),
  LGDDistrict(name: 'Thanjavur'),
  LGDDistrict(name: 'Theni'),
  LGDDistrict(name: 'The Nilgiris'),
  LGDDistrict(name: 'Thiruvallur'),
  LGDDistrict(name: 'Thiruvarur'),
  LGDDistrict(name: 'Thoothukkudi'),
  LGDDistrict(name: 'Tiruchirappalli'),
  LGDDistrict(name: 'Tirunelveli'),
  LGDDistrict(name: 'Tirupathur'),
  LGDDistrict(name: 'Tiruppur'),
  LGDDistrict(name: 'Tiruvannamalai'),
  LGDDistrict(name: 'Vellore'),
  LGDDistrict(name: 'Viluppuram'),
  LGDDistrict(name: 'Virudhunagar'),
];

/// Get districts for a given state name
List<LGDDistrict> getDistrictsForState(String stateName) {
  if (stateName == 'Tamil Nadu') {
    return tamilNaduDistricts;
  }
  return [];
}
