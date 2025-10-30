// screens/examdetails.dart
import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamDetails extends StatelessWidget {
  final Exam exam;

  const ExamDetails({super.key, required this.exam});

  String _getTimeRemaining() {
    final now = DateTime.now();

    if (exam.dateTime.isBefore(now)) {
      return "Испитот е одржан.";
    }

    final Duration timeUntil = exam.dateTime.difference(now);
    final int days = timeUntil.inDays;
    final int hours = timeUntil.inHours.remainder(24);

    return "$days дена, $hours часа";
  }

  @override
  Widget build(BuildContext context) {

    final String timeRemaining = _getTimeRemaining();

    return Scaffold(
      appBar: AppBar(
        title: Text(exam.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              exam.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            Divider(height: 20, thickness: 1),

            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Датум',
              value: '${exam.dateTime.day.toString().padLeft(2,'0')}.${exam.dateTime.month.toString().padLeft(2,'0')}.${exam.dateTime.year.toString().padLeft(2,'0')}',
            ),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Време',
              value: '${exam.dateTime.hour.toString().padLeft(2, '0')}:${exam.dateTime.minute.toString().padLeft(2, '0')}',
            ),
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Простории',
              value: exam.rooms.join(', '),
            ),

            Divider(height: 20, thickness: 1),

            Text(
              'Преостанато време: $timeRemaining',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: timeRemaining == "Испитот е одржан." ? Colors.red : Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey, size: 30),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}