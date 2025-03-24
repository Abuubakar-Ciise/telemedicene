import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tele/Models/doctors_list_nodel.dart';
import 'package:tele/views/components/available_time.dart';
import 'package:tele/views/components/select_package.dart';
import 'package:tele/views/screens/PatientDetailsScreen.dart';

class AppointmentScreen extends StatefulWidget {
  final DoctorList doctor;
  const AppointmentScreen({super.key, required this.doctor});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}
class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Eng Abuubakar Ciise",
      "experience": "12 Years Of Experience",
      "hospital": "Baano HealthCare Technology",
      "speciality": "Pediatric specialist",
      "language": "English, Somali",
      "charges": "\$6.00",
      "rating": 4.5,
      "image":
          "https://avatars.githubusercontent.com/u/138715168?v=4", // Replace with actual URL
      "available": ["9:00", "11:30", "8:15", "10:40", "1:00 PM"]
    },
    {
      "name": "Eng Adnaan Hassan ",
      "experience": "100 Years Of Experience",
      "hospital": "Somalia HealthCare Technology",
      "speciality": "specialist",
      "language": "Arabic, English",
      "charges": "\$10.00",
      "rating": 5.5,
      "image":
          "https://avatars.githubusercontent.com/u/138715168?v=4", // Replace with actual URL
      "available": [
        "8:00",
        "4:00",
        "7:00",
        "6:00",
      ]
    },
  ];
  late List<String> availableTimes;
  int? _selectedIndex;
  int? _selectedPackage;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedTime;
  @override
  void initState() {
    super.initState();
    availableTimes = List<String>.from(doctors[1]["available"] ?? []);
    availableTimes = availableTimes.map((time) {
      DateTime dateTime = DateFormat("h:mm").parse(time);
      return DateFormat("h:mm a").format(dateTime); // Format to 12-hour AM/PM
    }).toList()
      ..sort((a, b) {
        DateTime timeA = DateFormat("h:mm a").parse(a);
        DateTime timeB = DateFormat("h:mm a").parse(b);
        return timeA.compareTo(timeB); // Sort ascending
      });

    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "New Appointment",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.calendar_today, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCalendarCard(),
              // Text(DateFormat('MMM d, yyy').format(_selectedDay)),
              SizedBox(
                height: 10,
              ),
              AvailableTimeWidget(
                availableTimes: availableTimes,
                selectedIndex: _selectedIndex,
                onTimeSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _selectedTime = availableTimes[index];
                  });
                },
              ),
              SizedBox(
                height: 6,
              ),
              SelectPackageWidget(
                selectedTime: _selectedTime,
                selectedDay: _selectedDay,
                doctor: widget.doctor,
                selectedPackage: _selectedPackage,
                onPackageSelected: (index) {
                  setState(() {
                    _selectedPackage = index;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Calendar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: IgnorePointer(
                    child: DropdownButton<int>(
                      value: _focusedDay.year,
                      underline: SizedBox(),
                      items: List.generate(10, (index) {
                        int year = DateTime.now().year - 5 + index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString(),
                              style: const TextStyle(fontSize: 14)),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _focusedDay = DateTime(
                                value, _focusedDay.month, _focusedDay.day);
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2050, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  print("$_selectedDay");
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 9, 130, 13),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 9, 130, 13),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                outsideDaysVisible: false,
              ),
              headerVisible: false,
              rowHeight: 35,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                weekendStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
