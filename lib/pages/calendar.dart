import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  Map<DateTime, List> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  int folicular = 4;
  int ovulacion = 5;
  int premenstrual=28;
  String? _currentPhase;


  void _onRangeSelect(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;

    });
  }
  void _calculateCurrentPhase() {
    if (_rangeStart != null) {
      final currentDate = DateTime.now();
      final dayOfCycle = currentDate.difference(_rangeStart!).inDays % premenstrual;

      if (dayOfCycle <= (_rangeEnd!.difference(_rangeStart!).inDays)) {
        _currentPhase = 'Menstruación';
      } else if (dayOfCycle <= (_rangeEnd!.difference(_rangeStart!).inDays + folicular)) {
        _currentPhase = 'Fase Folicular';
      } else if (dayOfCycle <= (_rangeEnd!.difference(_rangeStart!).inDays + folicular + ovulacion)) {
        _currentPhase = 'Ovulación';
      } else {
        _currentPhase = 'Fase Premenstrual';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [

          Expanded(
            child: TableCalendar(
              eventLoader: _getEventsForDay,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  return _buildCell(date);
                },
              ),
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2023, 10, 10),
              lastDay: DateTime.utc(2024, 10, 10),
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              onRangeSelected: _onRangeSelect,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
            ),
          ),
          ElevatedButton(
            onPressed: _markRangeDays,
            child: const Text('Mark Period Days'),
          ),
          Text(
            'Fase Actual: $_currentPhase',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

        ],

      ),

    );
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _markRangeDays() {
    if (_rangeStart != null && _rangeEnd != null) {
      DateTime currentDate = _rangeStart!;
      while (currentDate.isBefore(_rangeEnd!) || currentDate.isAtSameMomentAs(_rangeEnd!)) {
        setState(() {
          if (_events[currentDate] == null) {
            _events[currentDate] = ['Event'];
          }
        });
        currentDate = currentDate.add(const Duration(days: 1));
      }
      _calculateCurrentPhase();
    }
  }

  Widget _buildCell(DateTime date) {
    final events = _getEventsForDay(date);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.day}',
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          if (events.isNotEmpty) ...[
            const SizedBox(height: 4.0),
            _buildEventsMarker(),
          ],
        ],
      ),
    );
  }

  Widget _buildEventsMarker() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      width: 7.0,
      height: 7.0,
    );

  }
}
