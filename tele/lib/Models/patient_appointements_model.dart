class PatientAppointementsModel {
  final String id;
  final int status;
  final String appointmentDate;
  final String doctorName;
  final String doctorProfile;
  final String shiftTime;
  final String shiftDay;
  PatientAppointementsModel({
    required this.id,
    required this.status,
    required this.appointmentDate,
    required this.doctorName,
    required this.doctorProfile,
    required this.shiftTime,
    required this.shiftDay,
  });
  factory PatientAppointementsModel.fromJson(Map<String,dynamic> json) {
    return PatientAppointementsModel(
      id: json['_id'] ?? '', 
      status: json['status'] ?? 0, 
      appointmentDate: json['appointment_date'] ?? '', 
      doctorName: json['doctor_name'] ?? '', 
      doctorProfile: json['doctor_profile'] ?? '', 
      shiftTime: json['shift_time'] ?? '', 
      shiftDay: json['shift_day'] ?? ''
      );
  }
   String toString() {
    return 'Appointment(id: $id, status: $status, date: $appointmentDate, doctor: $doctorName, time: $shiftTime, day: $shiftDay)';
  }
}