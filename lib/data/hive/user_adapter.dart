import 'package:dubravka/data/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    final firstName = reader.readString();
    final lastName = reader.readString();
    final dob = reader.read() as DateTime;
    final gender = reader.readString();
    final illnessesLength = reader.readInt();
    final illnesses = List<Illness>.generate(
      illnessesLength,
      (_) =>
          Illness(name: reader.readString(), date: reader.read() as DateTime),
    );
    final familyIllnessesLength = reader.readInt();
    final familyIllnesses = List<String>.generate(
      familyIllnessesLength,
      (_) => reader.readString(),
    );
    final hasCovidInfo = reader.readBool();
    final covidInfo = hasCovidInfo
        ? Covid(hadCovid: reader.readBool(), numOfShots: reader.readInt())
        : null;
    final medsLength = reader.readInt();
    final meds = List<String>.generate(medsLength, (_) => reader.readString());
    final allergiesLength = reader.readInt();
    final allergies =
        List<String>.generate(allergiesLength, (_) => reader.readString());
    final isSmoking = reader.readBool();
    final isDrinking = reader.readBool();

    return User(
      firstName: firstName,
      lastName: lastName,
      dob: dob,
      gender: gender,
      illnesses: illnesses,
      familyIllnesses: familyIllnesses,
      covidInfo: covidInfo,
      meds: meds,
      allergies: allergies,
      isSmoking: isSmoking,
      isDrinking: isDrinking,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.firstName);
    writer.writeString(obj.lastName);
    writer.write(obj.dob);
    writer.writeString(obj.gender);
    writer.writeInt(obj.illnesses?.length ?? 0);
    obj.illnesses?.forEach((illness) {
      writer.writeString(illness.name);
      writer.write(illness.date);
    });
    writer.writeBool(obj.covidInfo != null);
    if (obj.covidInfo != null) {
      writer.writeBool(obj.covidInfo!.hadCovid);
      writer.writeInt(obj.covidInfo!.numOfShots);
    }
    writer.writeInt(obj.familyIllnesses?.length ?? 0);
    obj.familyIllnesses?.forEach(writer.writeString);
    writer.writeInt(obj.meds?.length ?? 0);
    obj.meds?.forEach(writer.writeString);
    writer.writeInt(obj.allergies?.length ?? 0);
    obj.allergies?.forEach(writer.writeString);
    writer.writeBool(obj.isSmoking ?? false);
    writer.writeBool(obj.isDrinking ?? false);
  }
}
