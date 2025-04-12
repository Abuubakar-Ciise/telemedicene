class DoctorAppointementsModel {
  final String id;
  final int status;
  final String appointmentDate;
  final String patientName;
  final String patientProfile;
  final String shiftTime;
  final String shiftDay;
  DoctorAppointementsModel({
    required this.id,
    required this.status,
    required this.appointmentDate,
    required this.patientName,
    required this.patientProfile,
    required this.shiftTime,
    required this.shiftDay,
  });
  factory DoctorAppointementsModel.fromJson(Map<String,dynamic> json) {
    return DoctorAppointementsModel(
      id: json['_id'] ?? '', 
      status: json['status'] ?? 0, 
      appointmentDate: json['appointment_date'] ?? '', 
      patientName: json['patient_name'] ?? '', 
      patientProfile: json['patient_profile'] ?? '', 
      shiftTime: json['shift_time'] ?? '', 
      shiftDay: json['shift_day'] ?? ''
      );
  }
   String toString() {
    return 'Appointment(id: $id, status: $status, date: $appointmentDate, doctor: $patientName, time: $shiftTime, day: $shiftDay)';
  }
}