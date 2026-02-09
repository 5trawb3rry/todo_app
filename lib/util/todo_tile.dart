import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/constants/colors.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final DateTime createdAt;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? onEdit;

  TodoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.createdAt,
    required this.onChanged,
    required this.deleteFunction,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: AppColors.darkRed,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          decoration: BoxDecoration(
            color: const Color(0xFF5865F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // checkbox
              const SizedBox(width: 12),

              // spacing between checkbox and text
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                fillColor: WidgetStateProperty.all(Colors.white),
                checkColor: Colors.black,
                side: const BorderSide(color: Colors.white, width: 2),
              ),

              // task name
              Expanded(
                child: Text(
                  taskName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.lightBeige,
                    fontSize: 16,
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationThickness: 4,
                    decorationColor: Colors.black,
                  ),
                ),
              ),
              // edit button
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.lightBeige),
                onPressed: () => onEdit?.call(context),
              ),
              // info button (plain icon)
              IconButton(
                icon: Icon(Icons.info_outline, color: AppColors.lightBeige),
                onPressed: () {
                  final local = createdAt.toLocal();
                  const weekdays = [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                    'Sunday',
                  ];
                  const months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec',
                  ];
                  final weekday = weekdays[local.weekday - 1];
                  final month = months[local.month - 1];
                  final formattedDate = '$weekday, ${local.day} $month';
                  final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
                  final minute = local.minute.toString().padLeft(2, '0');
                  final period = local.hour >= 12 ? 'PM' : 'AM';
                  final formattedTime = '$hour12:$minute $period';

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AppColors.blurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          'Task Info',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Created on:',
                              style: TextStyle(
                                color: AppColors.lightBeige,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: AppColors.lightBeige,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formattedTime,
                                  style: TextStyle(color: AppColors.lightBeige),
                                ),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'OK',
                              style: TextStyle(color: AppColors.lightBeige),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
