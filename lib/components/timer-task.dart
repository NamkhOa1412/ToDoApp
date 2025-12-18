import 'package:flutter/material.dart';
import 'package:ktodo_application/components/button-custom.dart';
import 'package:ktodo_application/providers/card-provider.dart';
import 'package:ktodo_application/utils/string-utils.dart';
import 'package:provider/provider.dart';

class TimerTask extends StatefulWidget {
  final String cardId;
  final String dueAt;
  TimerTask({super.key,required this.cardId ,required this.dueAt});

  @override
  State<TimerTask> createState() => _TimerTaskState();
}

class _TimerTaskState extends State<TimerTask> {
  Future<void> pickDate(BuildContext context) async {
    final cardProvider = context.read<CardProvider>();

    final picked = await showDatePicker(
      context: context,
      initialDate: cardProvider.deadlineDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      cardProvider.setDeadlineDate(picked);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final cardProvider = context.read<CardProvider>();

    final picked = await showTimePicker(
      context: context,
      initialTime: cardProvider.deadlineTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      cardProvider.setDeadlineTime(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.dueAt);
    if (widget.dueAt != null && widget.dueAt != '') {
      final dateTime =
          DateTime.parse(widget.dueAt!).toLocal();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cardProvider = context.read<CardProvider>();

        cardProvider.setDeadlineDate(
          DateTime(dateTime.year, dateTime.month, dateTime.day),
        );

        cardProvider.setDeadlineTime(
          TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        );

        cardProvider.setIsAddTimer(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardProvider = context.watch<CardProvider>();

    return Container(
      padding:  EdgeInsets.all(16),
      height: cardProvider.isAddTimer ? 250 : 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CONTENT
          Expanded(
            flex: cardProvider.isAddTimer ? 8 : 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "Ngày hết hạn",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                 SizedBox(height: 12),
                if (!cardProvider.isAddTimer)
                  Row(
                    children: [
                       Icon(Icons.timer_outlined),
                       SizedBox(width: 6),
                      GestureDetector(
                        onTap: cardProvider.toggleisAddTimer,
                        child:  Text(
                          "Thêm ngày hết hạn ....",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => pickDate(context),
                              child: pickerBox(
                                color: Color(0xFF26A69A),
                                icon: Icons.calendar_today,
                                text: cardProvider.deadlineDate == null
                                      ? 'Chọn ngày'
                                      : '${cardProvider.deadlineDate!.day}/${cardProvider.deadlineDate!.month}/${cardProvider.deadlineDate!.year}',
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => pickTime(context),
                              child: pickerBox(
                                color: Color(0xFF26A69A),
                                icon: Icons.access_time,
                                text: cardProvider.deadlineTime == null
                                    ? 'Chọn giờ'
                                    : cardProvider.deadlineTime!.format(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      CustomButton(
                        text: 'Hủy thêm ngày',
                        onPressed: cardProvider.clearDeadline,
                      ),
                    ],
                  ),
              ],
            ),
          ),

          Expanded(
            flex: cardProvider.isAddTimer ? 2 : 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      cardProvider.clearDeadline();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Hủy',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async{
                      await cardProvider.updateCardDueAt(widget.cardId, cardProvider.deadlineDateTime?.toUtc().toIso8601String(), context);
                    },
                    child: Text(
                      'Hoàn tất',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pickerBox({required IconData icon, required String text, required Color color}) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
