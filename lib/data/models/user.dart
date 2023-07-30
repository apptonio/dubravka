class User {
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String gender;
  final List<Illness>? illnesses;
  final List<String>? familyIllnesses;
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
    this.illnesses,
    this.familyIllnesses,
    this.covidInfo,
    this.meds,
    this.allergies,
    this.isSmoking,
    this.isDrinking,
  });

  @override
  String toString() {
    return 'User: { firstName: $firstName, lastName: $lastName, dob: $dob, gender: $gender, '
        'illnesses: $illnesses, familyIllnesses: $familyIllnesses, '
        'covidInfo: $covidInfo, meds: $meds, allergies: $allergies, '
        'isSmoking: $isSmoking, isDrinking: $isDrinking }';
  }
}

class Illness {
  String name;
  DateTime date;

  Illness({required this.name, required this.date});

  @override
  String toString() {
    return 'Illness: { name: $name, date: $date }';
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
