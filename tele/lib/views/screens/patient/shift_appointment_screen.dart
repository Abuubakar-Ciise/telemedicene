import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tele/Models/doctors_list_nodel.dart';
import 'package:tele/controllers/shift_controller.dart';
import 'package:tele/services/get_api_services.dart';
import 'package:tele/views/screens/patient/PatientDetailsScreen.dart';
import 'package:toastification/toastification.dart';

class ShiftAppointmentScreen extends StatefulWidget {
  final DoctorList doctor;

  const ShiftAppointmentScreen({super.key, required this.doctor});

  @override
  _ShiftAppointmentScreenState createState() => _ShiftAppointmentScreenState();
}

class _ShiftAppointmentScreenState extends State<ShiftAppointmentScreen> {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5000';
  final shiftController = Get.put(ShiftController());
  // final shiftcheckController = Get.put(ShiftcheckController());
  late List<String> dayList;
  int? selectedDayIndex = 0;
  String? selectedTime;
  String? selectedShiftId;
  String? currentDate;
  late List<String> daysOfWeek;
  Map<String, bool> shiftAvailability = {};

  @override
  void initState() {
    super.initState();
    shiftController.fetchShifts(widget.doctor.id);
    setState(() {
      currentDate = getFormattedDate(selectedDayIndex!);
      daysOfWeek = getNextWeekDays();
    });
  }
  Future<void> checkShiftAvailability(String shiftId) async {
    final test = await ApiGetServices.checkShifts(shiftId, currentDate!);
    print(test['success']);
    print(
        "Checking shift availability for Shift ID: $shiftId, Date: $currentDate");

    setState(() {
      shiftAvailability[shiftId] = test['success']; // Store success/failure
    });

    toastification.show(
      type: test['success']
          ? ToastificationType.success
          : ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(test['success'] ? 'Success' : 'Hmmmmm'),
      description: Text(test['message']),
      autoCloseDuration: const Duration(seconds: 3),
      // animationDuration: const Duration(microseconds: 300),
      alignment: Alignment.topRight,
      showProgressBar: true,
    );
  }

  String getFormattedDate(int index) {
    DateTime now = DateTime.now().add(Duration(days: index));
    return DateFormat('d MMMM yyyy').format(now);
  }

  Map<String, List<Map<String, String>>> categorizeTimes(
      List<Map<String, String>> shifts) {
    List<Map<String, String>> morning = [], afternoon = [], evening = [];

    for (var shift in shifts) {
      String time = shift['time']!;
      String shiftId = shift['shiftId']!;
      print("shift TIME ${shift['time']} AND shiftId ${shift['shiftId']}");

      DateTime parsedTime = DateFormat('h:mm a').parse(time);

      int hour = parsedTime.hour;

      if (hour >= 5 && hour < 12) {
        morning.add({'shiftId': shiftId, 'time': time});
      } else if (hour >= 12 && hour < 17) {
        afternoon.add({'shiftId': shiftId, 'time': time});
      } else if (hour >= 17 && hour < 21) {
        evening.add({'shiftId': shiftId, 'time': time});
      }
    }

    return {
      'morning': morning,
      'afternoon': afternoon,
      'evening': evening,
    };
  }
  List<String> getNextWeekDays() {
    DateTime now = DateTime.now(); // Get the current date
    List<String> weekDays = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = now.add(Duration(days: i));
      String formattedDay =
          DateFormat('EEEE').format(day); // Example: "26 March Wednesday"
      weekDays.add(formattedDay);
    }

    return weekDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Book Appointment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
       
      ),
      body: Obx(() {
        if (shiftController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (shiftController.errorMessage.isNotEmpty) {
        //   return Center(child: Text(shiftController.errorMessage.value));
        // }
        dayList = shiftController.shiftsByDay.keys.toList();
        // String selectedDay =
        //     selectedDayIndex != null ? dayList[selectedDayIndex!] : "";
        String selectedDay =
            (selectedDayIndex != null && selectedDayIndex! < daysOfWeek.length)
                ? daysOfWeek[selectedDayIndex!]
                : "";

        List<Map<String, String>> shifts = selectedDay.isNotEmpty
            ? shiftController.shiftsByDay[selectedDay]!
                .map((shift) => {'time': shift.time, 'shiftId': shift.id})
                .toList()
            : [];

        Map<String, List<Map<String, String>>> categorizedTimes =
            categorizeTimes(shifts);
        // print("Categorized Times: $categorizedTimes");

        return Column(
          children: [
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 48,
                backgroundImage: (widget.doctor.picture?.isNotEmpty ?? false) &&
                        widget.doctor.picture != "N/A"
                    ? NetworkImage('$baseUrl/${widget.doctor.picture}')
                    : AssetImage('assets/default_image.png') as ImageProvider,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              // "Dr Abuubakar Ciise",
              widget.doctor.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Day selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDayIndex = index;
                            currentDate = getFormattedDate(
                                selectedDayIndex!); // Update the current date
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: selectedDayIndex == index
                                ? Colors.blueAccent
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            daysOfWeek[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedDayIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Time Slots Section
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: ['morning', 'afternoon', 'evening'].map((timePeriod) {
                  List<Map<String, String>> shifts =
                      categorizedTimes[timePeriod] ?? [];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                timePeriod.capitalize!,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${categorizedTimes[timePeriod]?.length ?? 0} Slots',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (shifts.isEmpty)
                            const Center(
                              child: Text("No slots available",
                                  style: TextStyle(color: Colors.grey)),
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: shifts.map((shift) {
                                  String time = shift['time'] ?? '';
                                  String shiftId = shift['shiftId'] ?? '';
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedTime = shift['shiftId'];
                                          selectedShiftId = shift['shiftId'];
                                          shiftController.errorMessage.value = "";
                                          print("fffffffffff$currentDate is this currentbdhd");
                                        });
                                        shiftAvailability.clear();
                                        checkShiftAvailability(selectedShiftId!);
                                      },
                                      
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            shiftAvailability[shiftId] == true
                                                ? Colors.blueAccent
                                                : Colors.green,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(time,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                          if (selectedTime == time &&
                                              shiftAvailability[shift['shiftId']] ==
                                                  true) ...[
                                            const SizedBox(width: 5),
                                            const Icon(Icons.check,
                                                size: 18, color: Colors.white),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedShiftId == null || selectedTime == null) {
                      toastification.show(
                        type: ToastificationType.error,
                        style: ToastificationStyle.flat,
                        title: const Text('Error'),
                        description:
                            const Text('Please select an available time slot'),
                        autoCloseDuration: const Duration(seconds: 3),
                        alignment: Alignment.topRight,
                        showProgressBar: true,
                      );
                    } else if (shiftAvailability[selectedShiftId] != true) {
                      toastification.show(
                        type: ToastificationType.error,
                        style: ToastificationStyle.flat,
                        title: const Text('Error'),
                        description: const Text(
                            'Please check the availability of your selected time'),
                        autoCloseDuration: const Duration(seconds: 3),
                        alignment: Alignment.topRight,
                        showProgressBar: true,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientDetailsScreen(
                            doctor: widget.doctor,
                            // selectedDate:DateFormat('d MMMM yyyy').parse(currentDate!),
                            selectedDate: currentDate!,
                            selectedTime: selectedTime,
                            // : selectedShiftId,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D986A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
