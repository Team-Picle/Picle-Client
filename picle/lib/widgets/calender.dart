import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:picle/providers/date_provider.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/providers/todo_provider.dart';
import 'package:picle/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().user.id;

    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week'
      },
      locale: 'ko_KR',
      rowHeight: 45,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) async {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        context.read<DateProvider>().updateDate(selectedDay);
        String date = context.read<DateProvider>().getDate();
        context.read<TodoProvider>().fetchTodoList(
              userId: userId,
              date: date,
            );
        context.read<RoutineProvider>().fetchList(
              userId: userId,
              date: date,
            );
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        formatButtonTextStyle: const TextStyle(
          color: Colors.white,
        ),
        formatButtonDecoration: BoxDecoration(
          color: const Color(0XFF54C29B),
          borderRadius: BorderRadius.circular(20),
        ),
        leftChevronIcon:
            const Icon(Icons.chevron_left, color: Color(0XFF54C29B)),
        rightChevronIcon:
            const Icon(Icons.chevron_right, color: Color(0XFF54C29B)),
      ),
      calendarStyle: const CalendarStyle(
        weekendTextStyle: TextStyle(color: Color(0XFF54C29B)),
        weekNumberTextStyle: TextStyle(
          color: Color(0XFF54C29B),
          fontSize: 12,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday ||
              day.weekday == DateTime.saturday) {
            return Center(
              child: Text(
                day.weekday == DateTime.sunday ? '일' : '토',
                style: const TextStyle(
                  color: Color(0XFF54C29B),
                ),
              ),
            );
          }
          return null;
        },
        todayBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0XFFB7C4BF),
                shape: BoxShape.circle,
              ),
              child: Text(
                DateFormat('d').format(day),
              ),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0XFF54C29B),
                shape: BoxShape.circle,
              ),
              child: Text(DateFormat('d').format(day),
                  style: const TextStyle(
                    color: Colors.white,
                  )),
            ),
          );
        },
      ),
    );
  }
}
