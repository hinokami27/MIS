import 'package:flutter/material.dart';
import 'models/exam.dart';
import 'screens/examdetails.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

Color getIconColor(DateTime examDate) {
  final now = DateTime.now();

  if (examDate.isBefore(now)) {
    return Colors.grey;
  }
  return Colors.blue;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Exam> exams = [
      Exam(name: "Математика 1", dateTime: DateTime(2025, 7, 1, 10, 0), rooms: ["ТМФ 2025"]),
      Exam(name: "Структурно програмирање", dateTime: DateTime(2025, 7, 3, 12, 0), rooms: ["Лаб 138"]),
      Exam(name: "Алгоритми и податочни структури", dateTime: DateTime(2025, 7, 5, 8, 30), rooms: ["Лаб 117"]),
      Exam(name: "Веројатност и статистика", dateTime: DateTime(2026, 2, 7, 14, 0), rooms: ["Лаб 12", "Лаб 138"]),
      Exam(name: "Мобилни информациски системи", dateTime: DateTime(2026, 2, 9, 9, 0), rooms: ["Лаб 215"]),
      Exam(name: "Менаџмент информациски системи", dateTime: DateTime(2026, 2, 10, 11, 15), rooms: ["ТМФ 315"]),
      Exam(name: "Математика 2", dateTime: DateTime(2026, 2, 12, 13, 45), rooms: ["АМФ МФ"]),
      Exam(name: "Веб Програмирање", dateTime: DateTime(2026, 2, 14, 15, 0), rooms: ["Лаб 215", "Лаб 138"]),
      Exam(name: "Математика 3", dateTime: DateTime(2026, 2, 16, 11, 0), rooms: ["Лаб 12"]),
      Exam(name: "Бази на податоци", dateTime: DateTime(2026, 2, 19, 9, 0), rooms: ["Лаб 138"]),
      Exam(name: "Дигитизација", dateTime: DateTime(2026, 2, 21, 16, 0), rooms: ["Лаб 12","Лаб 200В"]),
      Exam(name: "Напреден веб дизајн", dateTime: DateTime(2026, 2, 22, 16, 0), rooms: ["Лаб 200АБ"]),
      Exam(name: "Интернет програмирање на клиентска страна", dateTime: DateTime(2026, 2, 22, 9, 30), rooms: ["Лаб 200АБ","Лаб 138"]),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Распоред за испити - 215001'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(8),
            children: exams.map((exam) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamDetails(exam: exam),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          exam.rooms.any((room) => room.contains("Лаб"))
                              ? Icons.computer
                              : Icons.book,
                          size: 40,
                          color: getIconColor(exam.dateTime),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exam.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,size: 20,color: Colors.grey,),
                                  SizedBox(width: 10,),
                                  Text(
                                      "Датум: ${exam.dateTime.day.toString().padLeft(2,'0')}.${exam.dateTime.month.toString().padLeft(2,'0')}.${exam.dateTime.year.toString().padLeft(2,'0')}",
                                  style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.access_time,size: 20, color: Colors.grey,),
                                  SizedBox(width: 10,),
                                  Text("Време: ${exam.dateTime.hour.toString().padLeft(2, '0')}:${exam.dateTime.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(fontSize: 16) ,),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on,size: 20, color: Colors.grey,),
                                  SizedBox(width: 10,),
                                  Text("Просторија: ${exam.rooms.join(', ')}",
                                  style: TextStyle(fontSize: 16),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                '${exams.length}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}