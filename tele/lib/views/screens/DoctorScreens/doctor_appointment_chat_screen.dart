import 'package:flutter/material.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/services/firebase_api.dart';
import 'package:tele/views/screens/CallPage/call_page.dart';
import 'package:tele/views/screens/components/config.dart';

class DoctorAppointmentChatScreen extends StatefulWidget {
  final String doctorName;
  final String patientName;
  final String patientProfile;
  final String doctorToken;
  final String patientToken;
  final String doctorPhone;
  final String patientPhone;

  const DoctorAppointmentChatScreen({
    super.key,
    required this.doctorName,
    required this.patientName,
    required this.patientProfile,
    required this.doctorToken,
    required this.patientToken,
    required this.doctorPhone,
    required this.patientPhone,
  });

  @override
  State<DoctorAppointmentChatScreen> createState() =>
      _DoctorAppointmentChatScreenState();
}

class _DoctorAppointmentChatScreenState
    extends State<DoctorAppointmentChatScreen> {
  final url = Config.baseUrl;
  final ScrollController _scrollController = ScrollController();
  double _avatarSize = 40;
  bool _showFullAppBar = true;
  String? picture;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _scrollController.addListener(_handleScroll);
    // Scroll to the bottom after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> loadUserData() async {
    Map<String, String?> userData = await StorageService.getUserData();
    setState(() {
      picture = userData['picture'] ?? "N/A";
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    if (offset > 0 && offset < 100) {
      setState(() {
        _avatarSize = 40 - (offset * 0.3).clamp(0, 16);
        _showFullAppBar = offset < 30;
      });
    } else if (offset <= 0) {
      setState(() {
        _avatarSize = 40;
        _showFullAppBar = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_showFullAppBar ? 80 : 56),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.teal),
                        onPressed: () => Navigator.pop(context),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: _avatarSize,
                        height: _avatarSize,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: (widget.patientProfile.isNotEmpty &&
                                  widget.patientProfile != "N/A")
                              ? NetworkImage('$url/${widget.patientProfile}')
                              : const AssetImage('assets/default_image.png')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.patientName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (_showFullAppBar) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Online',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.call, color: Colors.teal),
                        onPressed: () async {
                          final roomId =
                              "call_${DateTime.now().millisecondsSinceEpoch}";

                          await FirebaseApis().sendCallFCM(
                              widget.patientToken,
                              widget.doctorName,
                              roomId,
                              widget.doctorPhone,
                              widget.patientProfile,
                              '0',
                              widget.doctorToken);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CallPage(callId: roomId, callType: '0')));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.videocam, color: Colors.teal),
                        onPressed: () async {
                          final roomId =
                              "call_${DateTime.now().millisecondsSinceEpoch}";

                          await FirebaseApis().sendCallFCM(
                              widget.patientToken,
                              widget.doctorName,
                              roomId,
                              widget.doctorPhone,
                              widget.patientProfile,
                              '1',
                              widget.doctorToken);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CallPage(callId: roomId, callType: '1')));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: 30,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Align(
                    alignment: index % 2 == 0
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.teal.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Message ${index + 1}'),
                    ),
                  ),
                );
              },
            ),
          ),
          // Message Input
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
