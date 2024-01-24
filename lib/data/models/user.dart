class User {
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String gender;
  final String race;
  final List<Illness>? illnesses;
  final String? diagnosis;
  final Covid? covidInfo;
  final List<String>? meds;
  final List<String>? allergies;
  final bool? isSmoking;
  final bool? isDrinking;

  const User({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.race,
    this.illnesses,
    this.diagnosis,
    this.covidInfo,
    this.meds,
    this.allergies,
    this.isSmoking,
    this.isDrinking,
  });

  @override
  String toString() {
    return 'User: { firstName: $firstName, lastName: $lastName, dob: $dob, sex: $gender, race: $race, '
        'illnesses: $illnesses, diagnosis: $diagnosis, '
        'covidInfo: $covidInfo, meds: $meds, allergies: $allergies, '
        'isSmoking: $isSmoking, isDrinking: $isDrinking }';
  }
}

class Illness {
  String name;
  String? time;

  Illness({required this.name, this.time});

  @override
  String toString() {
    return 'Illness: { name: $name, time: $time }';
  }
}

class Covid {
  final bool hadCovid;
  final int numOfShots;

  Covid({required this.hadCovid, required this.numOfShots});

  @override
  String toString() {
    return 'Covid: { hadCovid: $hadCovid, numOfShots: $numOfShots }';
  }
}
