// 🔧 QUICK FIX FOR OVERFLOW ERRORS
// Copy and paste these corrected Row widgets to replace the problematic ones

// ✅ CORRECTED PATIENT ROW
// Row(
//   children: [
//     const Icon(Icons.person, size: 18, color: Colors.green),
//     const SizedBox(width: 6),
//     Expanded(
//       child: Text("${'patient'.tr}: ${item.patientName}",
//           style: const TextStyle(fontSize: 14),
//           overflow: TextOverflow.ellipsis),
//     ),
//   ],
// ),

// ✅ CORRECTED DATE ROW  
// Row(
//   children: [
//     const Icon(Icons.calendar_today, size: 18, color: Colors.orange),
//     const SizedBox(width: 6),
//     Expanded(
//       child: Text("${'date'.tr}: $date",
//           style: const TextStyle(fontSize: 14),
//           overflow: TextOverflow.ellipsis),
//     ),
//   ],
// ),

// ✅ CORRECTED SUMMARY ROW
// Row(
//   children: [
//     const Icon(Icons.list_alt, size: 18, color: Colors.purple),
//     const SizedBox(width: 6),
//     Expanded(
//       child: Text(summary,
//           style: const TextStyle(fontSize: 14),
//           overflow: TextOverflow.ellipsis),
//     ),
//   ],
// ),

// 🚀 ALTERNATIVE: Use the helper method (RECOMMENDED)
// Replace all the above with these single lines:
// _buildInfoRow(Icons.person, Colors.green, "${'patient'.tr}: ${item.patientName}"),
// _buildInfoRow(Icons.calendar_today, Colors.orange, "${'date'.tr}: $date"),
// _buildInfoRow(Icons.list_alt, Colors.purple, summary),