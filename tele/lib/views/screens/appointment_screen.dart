import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tele/views/screens/PatientDetailsScreen.dart';

class AppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  const AppointmentScreen({super.key, required this.doctor});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late List<String> availableTimes;
  int? _selectedIndex;
  int? _selectedPackage;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedTime;
  @override
  void initState() {
    super.initState();
    availableTimes = List<String>.from(widget.doctor["available"] ?? []);
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

class AvailableTimeWidget extends StatelessWidget {
  final List<String> availableTimes;
  final int? selectedIndex;
  final Function(int) onTimeSelected;

  const AvailableTimeWidget({
    super.key,
    required this.availableTimes,
    required this.selectedIndex,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available Time",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            children: List.generate(availableTimes.length, (index) {
              return ChoiceChip(
                checkmarkColor: Colors.white,
                label: Text(
                  availableTimes[index],
                  style: TextStyle(
                    color:
                        selectedIndex == index ? Colors.white : Colors.black54,
                  ),
                ),
                selected: selectedIndex == index,
                onSelected: (bool selected) {
                  onTimeSelected(selected ? index : selectedIndex ?? 0);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
                selectedColor: Color.fromARGB(255, 9, 130, 13),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class SelectPackageWidget extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final DateTime selectedDay;
  final String? selectedTime;
  final Function(int) onPackageSelected;
  final int? selectedPackage;

  const SelectPackageWidget({
    super.key,
    required this.onPackageSelected,
    required this.selectedPackage,
    required this.doctor,
    required this.selectedDay,
    required this.selectedTime,
  });

  @override
  _SelectPackageWidgetState createState() => _SelectPackageWidgetState();
}

class _SelectPackageWidgetState extends State<SelectPackageWidget> {
  List<Map<String, dynamic>> packages = [
    {
      "title": "Video Conversation",
      "price": "\$13.88 Per 30 Minutes",
      "icon": Icons.videocam,
      "color": Colors.purple,
    },
    {
      "title": "Audio Conversation",
      "price": "\$10.34 Per 30 Minutes",
      "icon": Icons.phone,
      "color": Colors.redAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Package",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(packages.length, (index) {
              bool isSelected = widget.selectedPackage == index;
              return GestureDetector(
                onTap: () {
                  widget.onPackageSelected(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? packages[index]["color"].withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? packages[index]["color"]
                          : Colors.black26,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: packages[index]["color"],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Icon(packages[index]["icon"], color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              packages[index]["title"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              packages[index]["price"],
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Radio<int>(
                        value: index,
                        groupValue: widget.selectedPackage,
                        onChanged: (value) {
                          widget.onPackageSelected(value!);
                        },
                        activeColor: packages[index]["color"],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 9, 130, 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              if (widget.selectedPackage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Please select a package before proceeding.")),
                );
                return;
              }
              // Handle appointment booking
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientDetailsScreen(
                            doctor: widget.doctor,
                            selectedPackage: packages[widget.selectedPackage!],
                            selectedDay: widget.selectedDay,
                            selectedTime: widget.selectedTime,
                            // selectedPackage: widget.selectedPackage!,
                          )));
            },
            child: const Text(
              "Set Appointment",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
