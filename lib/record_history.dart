import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'home_dashboard.dart';


class RecordHistory extends StatefulWidget {
  const RecordHistory({super.key});

  @override
  State<RecordHistory> createState() => _RecordHistoryPageState();
}

class _RecordHistoryPageState extends State<RecordHistory> {
  final Color purple = const Color(0xFF2D108E);
  final Color grey = const Color(0xFFD9D9D9);

  int selectedTab = 0;
  String selectedFilter = "Custom";

  DateTime startDate = DateTime(2024, 7, 13);
  DateTime endDate = DateTime(2024, 7, 2);
  DateTime month = DateTime(2024, 7, 1);
  DateTime? selectedDay;

  DateTime focusedDay = DateTime.now();
  DateTime? rangeStart;
  DateTime? rangeEnd;

  final DateFormat formatter = DateFormat("d MMMM yyyy");

  Future<void> pickDate(bool isStart) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: purple, onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          startDate = date;
        } else {
          endDate = date;
        }
        month = DateTime(date.year, date.month, 1);
        selectedDay = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: purple,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Record History",
          style: TextStyle(color: Colors.white),
        ),
      ),

      bottomNavigationBar: Container(
        color: purple,
        height: 60,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.menu, color: Colors.white),
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.person, color: Colors.white),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _topTab("Monitoring\nCPB Pest", 0),
            const SizedBox(width: 8),
            _topTab("Cocoa Yield\nManagement", 1),
          ]),

          const SizedBox(height: 16),
          const Text("Filter by", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Wrap(spacing: 8, children: [
            _filterChip("Day"),
            _filterChip("Week"),
            _filterChip("Month"),
            _filterChip("Year"),
            _filterChip("Custom"),
          ]),

          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _dateSelector(startDate, () => pickDate(true))),
            const SizedBox(width: 12),
            Expanded(child: _dateSelector(endDate, () => pickDate(false))),
          ]),

          const SizedBox(height: 20),
          _calendar(),

          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: const Text("Apply", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _topTab(String text, int index) {
    bool selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? purple : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: purple),
          ),
          alignment: Alignment.center,
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }

  Widget _filterChip(String label, {bool hasDot = false}) {
    bool selected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? purple : grey),
          borderRadius: BorderRadius.circular(20),
          color: selected ? purple.withOpacity(0.1) : Colors.white,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (hasDot) ...[
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
            const SizedBox(width: 6),
          ],
          Text(label,
              style: TextStyle(color: selected ? purple : Colors.black87, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  Widget _dateSelector(DateTime date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          const Icon(Icons.calendar_today, size: 18),
          const SizedBox(width: 8),
          Text(formatter.format(date), style: const TextStyle(fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  Widget _calendar() {
    return TableCalendar(
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      focusedDay: focusedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      rangeStartDay: rangeStart,
      rangeEndDay: rangeEnd,
      calendarFormat: CalendarFormat.month,

      onDaySelected: (day, newFocus) {
        setState(() {
          focusedDay = newFocus;

          if (selectedFilter == "Day") {
            // ✅ DAY MODE: Select only one date
            startDate = day;
            endDate = day;
            rangeStart = null;
            rangeEnd = null;
            selectedDay = day;
          } else if (selectedFilter == "Week") {
            // ✅ WEEK MODE: Select entire week (Monday to Sunday)
            DateTime monday = day.subtract(Duration(days: day.weekday - 1));
            DateTime sunday = day.add(Duration(days: 7 - day.weekday));

            startDate = monday;
            endDate = sunday;
            rangeStart = monday;
            rangeEnd = sunday;
          } else if (selectedFilter == "Month") {
            // ✅ MONTH MODE: Select entire month
            DateTime firstDayOfMonth = DateTime(day.year, day.month, 1);
            DateTime lastDayOfMonth = DateTime(day.year, day.month + 1, 0);

            startDate = firstDayOfMonth;
            endDate = lastDayOfMonth;
            rangeStart = firstDayOfMonth;
            rangeEnd = lastDayOfMonth;
          } else if (selectedFilter == "Custom") {
            // ✅ CUSTOM MODE: range selection
            if (rangeStart == null || (rangeStart != null && rangeEnd != null)) {
              rangeStart = day;
              rangeEnd = null;
              startDate = day;
              endDate = day;
            } else {
              rangeEnd = day.isAfter(rangeStart!) ? day : rangeStart;

              // ✅ UPDATE BOTH DATE COLUMNS when range is complete
              if (rangeStart != null && rangeEnd != null) {
                startDate = rangeStart!;
                endDate = rangeEnd!;
              }
            }
          } else if (selectedFilter == "Week") {
            // ✅ WEEK MODE: Select entire week (we'll implement this next)
            startDate = day.subtract(Duration(days: day.weekday - 1));
            endDate = day.add(Duration(days: 7 - day.weekday));
            rangeStart = null;
            rangeEnd = null;
          } else if (selectedFilter == "Month") {
            // ✅ MONTH MODE: Select entire month (we'll implement this next)
            startDate = DateTime(day.year, day.month, 1);
            endDate = DateTime(day.year, day.month + 1, 0);
            rangeStart = null;
            rangeEnd = null;
          } else if (selectedFilter == "Year") {
            // ✅ YEAR MODE: Select entire year (we'll implement this next)
            startDate = DateTime(day.year, 1, 1);
            endDate = DateTime(day.year, 12, 31);
            rangeStart = null;
            rangeEnd = null;
          }
        });
      },

      selectedDayPredicate: (day) {
        if (selectedFilter == "Day") {
          return isSameDay(startDate, day);
        } else if (selectedFilter == "Week") {
          // Highlight all days in the selected week
          if (rangeStart != null && rangeEnd != null) {
            return (day.isAfter(rangeStart!) || isSameDay(day, rangeStart)) &&
                (day.isBefore(rangeEnd!) || isSameDay(day, rangeEnd));
          }
          return false;
        } else if (selectedFilter == "Month") {
          // Highlight all days in the selected month
          if (rangeStart != null && rangeEnd != null) {
            return (day.isAfter(rangeStart!) || isSameDay(day, rangeStart)) &&
                (day.isBefore(rangeEnd!) || isSameDay(day, rangeEnd));
          }
          return false;
        } else if (selectedFilter == "Custom") {
          return isSameDay(rangeStart, day) || isSameDay(rangeEnd, day);
        }
        return false;
      },

      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: purple.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: purple,
          shape: BoxShape.circle,
        ),
        rangeHighlightColor: purple.withOpacity(0.2),
        rangeStartDecoration: BoxDecoration(
          color: purple,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: BoxDecoration(
          color: purple,
          shape: BoxShape.circle,
        ),
      ),

      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(Icons.chevron_left, color: purple),
        rightChevronIcon: Icon(Icons.chevron_right, color: purple),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),

      onHeaderTapped: (date) async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: focusedDay,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: purple),
            ),
            child: child!,
          ),
        );

        if (picked != null) {
          setState(() {
            focusedDay = picked;
            month = DateTime(picked.year, picked.month, 1);
          });
        }
      },
    );
  }
}