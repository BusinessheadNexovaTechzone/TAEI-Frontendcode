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
  final int code;

  LGDDistrict({
    required this.name,
    required this.code,
  });
}

// LGD States - Currently only Tamil Nadu
final List<LGDState> lgdStates = [
  LGDState(name: 'Tamil Nadu', code: 33),
];

// Census 2011 district codes; newer districts use their historical parent code.
final List<LGDDistrict> tamilNaduDistricts = [
  LGDDistrict(name: 'Ariyalur', code: 615),
  LGDDistrict(name: 'Chengalpattu', code: 603),
  LGDDistrict(name: 'Chennai', code: 602),
  LGDDistrict(name: 'Coimbatore', code: 631),
  LGDDistrict(name: 'Cuddalore', code: 616),
  LGDDistrict(name: 'Dharmapuri', code: 629),
  LGDDistrict(name: 'Dindigul', code: 611),
  LGDDistrict(name: 'Erode', code: 609),
  LGDDistrict(name: 'Kallakurichi', code: 606),
  LGDDistrict(name: 'Kancheepuram', code: 603),
  LGDDistrict(name: 'Kanniyakumari', code: 628),
  LGDDistrict(name: 'Karur', code: 612),
  LGDDistrict(name: 'Krishnagiri', code: 630),
  LGDDistrict(name: 'Madurai', code: 622),
  LGDDistrict(name: 'Mayiladuthurai', code: 617),
  LGDDistrict(name: 'Nagapattinam', code: 617),
  LGDDistrict(name: 'Namakkal', code: 608),
  LGDDistrict(name: 'Perambalur', code: 614),
  LGDDistrict(name: 'Pudukkottai', code: 620),
  LGDDistrict(name: 'Ramanathapuram', code: 625),
  LGDDistrict(name: 'Ranipet', code: 604),
  LGDDistrict(name: 'Salem', code: 607),
  LGDDistrict(name: 'Sivaganga', code: 621),
  LGDDistrict(name: 'Tenkasi', code: 627),
  LGDDistrict(name: 'Thanjavur', code: 619),
  LGDDistrict(name: 'Theni', code: 623),
  LGDDistrict(name: 'The Nilgiris', code: 610),
  LGDDistrict(name: 'Thiruvallur', code: 601),
  LGDDistrict(name: 'Thiruvarur', code: 618),
  LGDDistrict(name: 'Thoothukkudi', code: 626),
  LGDDistrict(name: 'Tiruchirappalli', code: 613),
  LGDDistrict(name: 'Tirunelveli', code: 627),
  LGDDistrict(name: 'Tirupathur', code: 604),
  LGDDistrict(name: 'Tiruppur', code: 632),
  LGDDistrict(name: 'Tiruvannamalai', code: 605),
  LGDDistrict(name: 'Vellore', code: 604),
  LGDDistrict(name: 'Viluppuram', code: 606),
  LGDDistrict(name: 'Virudhunagar', code: 624),
];

/// Get districts for a given state name
List<LGDDistrict> getDistrictsForState(String stateName) {
  if (stateName == 'Tamil Nadu') {
    return tamilNaduDistricts;
  }
  return [];
}
