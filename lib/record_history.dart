import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';

enum FilterMode { day, week, month, year, custom }

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
            Expanded(child: _dateSelector(startDate, true)),
            const SizedBox(width: 12),
            Expanded(child: _dateSelector(endDate, false)),
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

  Widget _dateSelector(DateTime date, bool isStart) {
    return GestureDetector(
      onTap: () {
        if (selectedFilter == "Day") {
          pickDate(FilterMode.day, isStart: isStart);
        } else if (selectedFilter == "Week") {
          pickDate(FilterMode.day, isStart: isStart); // Week handled automatically
        } else if (selectedFilter == "Month") {
          pickDate(FilterMode.month, isStart: isStart);
        } else if (selectedFilter == "Year") {
          pickDate(FilterMode.year, isStart: isStart);
        } else if (selectedFilter == "Custom") {
          pickDate(FilterMode.day, isStart: isStart); // custom still picks date
        }
      },
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
        if (selectedFilter == "Month" || selectedFilter == "Year") {
          // Disable click for Month/Year mode
          return;
        }

        setState(() {
          focusedDay = newFocus;

          if (selectedFilter == "Day") {
            startDate = day;
            endDate = day;
            rangeStart = null;
            rangeEnd = null;
          }
          else if (selectedFilter == "Week") {
            DateTime monday = day.subtract(Duration(days: day.weekday - 1));
            DateTime sunday = day.add(Duration(days: 7 - day.weekday));
            startDate = monday;
            endDate = sunday;
            rangeStart = monday;
            rangeEnd = sunday;
          }
          else if (selectedFilter == "Custom") {
            if (rangeStart == null || (rangeStart != null && rangeEnd != null)) {
              rangeStart = day;
              rangeEnd = null;
              startDate = day;
              endDate = day;
            } else {
              rangeEnd = day.isAfter(rangeStart!) ? day : rangeStart;
              if (rangeStart != null && rangeEnd != null) {
                startDate = rangeStart!;
                endDate = rangeEnd!;
              }
            }
          }
        });
      },


      selectedDayPredicate: (day) {
        if (selectedFilter == "Month" || selectedFilter == "Year") {
          return false; // no highlight
        }

        if (selectedFilter == "Day") {
          return isSameDay(startDate, day);
        }

        if (selectedFilter == "Week" && rangeStart != null && rangeEnd != null) {
          return (day.isAfter(rangeStart!) || isSameDay(day, rangeStart)) &&
              (day.isBefore(rangeEnd!) || isSameDay(day, rangeEnd));
        }

        if (selectedFilter == "Custom") {
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
        leftChevronVisible: !(selectedFilter == "Month" || selectedFilter == "Year"),
        rightChevronVisible: !(selectedFilter == "Month" || selectedFilter == "Year"),
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

  Future<void> pickDate(FilterMode mode, {required bool isStart}) async {
    int selectedDay = (isStart ? startDate.day : endDate.day);
    int selectedMonth = (isStart ? startDate.month : endDate.month);
    int selectedYear = (isStart ? startDate.year : endDate.year);

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Done", style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      Navigator.pop(context);

                      if (mode == FilterMode.day) {
                        setState(() {
                          DateTime picked = DateTime(selectedYear, selectedMonth, selectedDay);
                          if (isStart) {
                            startDate = picked;
                          } else {
                            endDate = picked;
                          }

                          focusedDay = picked;
                          rangeStart = null;
                          rangeEnd = null;
                        });
                      }

                      if (mode == FilterMode.month) {
                        setState(() {
                          startDate = DateTime(selectedYear, selectedMonth, 1);
                          endDate = DateTime(selectedYear, selectedMonth + 1, 0);
                          focusedDay = startDate;
                          rangeStart = startDate;
                          rangeEnd = endDate;
                        });
                      }

                      if (mode == FilterMode.year) {
                        setState(() {
                          startDate = DateTime(selectedYear, 1, 1);
                          endDate = DateTime(selectedYear, 12, 31);
                          focusedDay = startDate;
                          rangeStart = startDate;
                          rangeEnd = endDate;
                        });
                      }
                    },
                  )
                ],
              ),

              Expanded(
                child: Row(
                  children: [
                    // DAY PICKER (only for Day mode)
                    if (mode == FilterMode.day)
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
                          itemExtent: 32,
                          onSelectedItemChanged: (index) {
                            selectedDay = index + 1;
                          },
                          children: List.generate(31, (i) => Center(child: Text("${i + 1}"))),
                        ),
                      ),

                    // MONTH PICKER (visible in day & month modes)
                    if (mode != FilterMode.year)
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
                          itemExtent: 32,
                          onSelectedItemChanged: (index) {
                            selectedMonth = index + 1;
                          },
                          children: List.generate(
                            12,
                                (i) => Center(child: Text(DateFormat.MMMM().format(DateTime(0, i + 1)))),
                          ),
                        ),
                      ),

                    // YEAR PICKER (visible in all modes)
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selectedYear - 2000),
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          selectedYear = 2000 + index;
                        },
                        children: List.generate(
                          101,
                              (i) => Center(child: Text("${2000 + i}")),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }








}