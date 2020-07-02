class CurrentIndex {
  int index;
  CurrentIndex({this.index});
}

class Patient {
  String role,
      patientid,
      password,
      name,
      email,
      phone,
      address,
      healthyBackground,
      problem,
      patientRecord,
      dateAppointment,
      imagePatient;

  Patient({
    this.role,
    this.patientid,
    this.password,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.healthyBackground,
    this.problem,
    this.patientRecord,
    this.dateAppointment,
    this.imagePatient,
  });
}

class Psychiatrist {
  String role,
      psychiatristID,
      password,
      name,
      email,
      phone,
      qualification,
      language,
      imagePsychiatrist,
      timetable,
      availableTime,
      location;

  Psychiatrist(
      {this.role,
      this.psychiatristID,
      this.password,
      this.name,
      this.email,
      this.phone,
      this.qualification,
      this.language,
      this.imagePsychiatrist,
      this.timetable,
      this.availableTime,
      this.location});
}

class NotificationDetail {
  String title, subtitle, subtitle1, subtitle2, date, notiID, status;
  NotificationDetail(
      {this.title,
      this.subtitle,
      this.subtitle1,
      this.subtitle2,
      this.date,
      this.notiID,
      this.status});
}

class User {
  final String uid;
  User({this.uid});
}

class Message{
  final String title;
  final String body;

  Message({this.title,this.body,});
}
