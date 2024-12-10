import 'package:flutter/material.dart';
import 'package:frontend/src/common_widgets/date_display.dart';
import 'package:frontend/src/common_decorators/text_field_decorator.dart';
import 'package:frontend/src/common_widgets/hour_and_minute_picker.dart';
import 'package:frontend/src/common_widgets/icon_picker.dart';
import 'package:frontend/src/common_widgets/rounded_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/constants/icons.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/features/tasks/application/task_service.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/src/features/tasks/presentation/estimated_time_dialog.dart';
import 'package:frontend/src/common_widgets/priority_selector.dart';

class CreateTaskScreen extends StatefulWidget {

  final Task? task;

  const CreateTaskScreen({
    super.key,
    this.task,
  });

  @override
  CreateTaskScreenState createState() => CreateTaskScreenState();
}

class CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController = TextEditingController();

  late String _taskName;
  late String _taskDescription;
  late IconData _selectedIcon;
  late DateTime _selectedDate;
  late int _selectedHour;
  late int _selectedMinute;
  late int? _estimatedDuration;
  late int _selectedPriority;
  
  bool _showMoreOptions = false;

  @override
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.task?.date ?? DateTime.now();
    _selectedHour = widget.task?.date.hour ?? DateTime.now().hour;
    _selectedMinute = widget.task?.date.minute ?? DateTime.now().minute;
    _selectedIcon = 
      widget.task?.icon != null ? IconData(int.parse(widget.task!.icon,), fontFamily: 'MaterialIcons') : Icons.edit;
    _nameFieldController.text = widget.task?.name ?? '';
    _descriptionFieldController.text = widget.task?.description ?? '';
    _taskDescription = widget.task?.description ?? '';
    _taskName = widget.task?.name ?? '';
    _estimatedDuration = widget.task?.estimatedDuration;
    _selectedPriority = widget.task?.priority ?? 3;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'New task',
          style: GoogleFonts.lexendDeca(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surfaceBright,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Title(
                          color: colorScheme.onTertiary,
                          child: Text(
                            'PRIORITY',
                            style: GoogleFonts.quicksand(
                              color: colorScheme.onTertiary,
                              fontWeight: FontWeight.bold,
                            )
                          )
                        ),
                      ),
                      const SizedBox(height: 15),
                      PrioritySelector(
                        selectedPriority: _selectedPriority,
                        onPriorityChanged: (priority) {
                          setState(() {
                            _selectedPriority = priority;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Title(
                          color: Colors.white, 
                          child: Text(
                            'NAME', 
                            style: GoogleFonts.quicksand(
                              color: colorScheme.onTertiary, 
                              fontWeight: FontWeight.bold,
                            )
                          )
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5), 
                            child: RoundedIconButton(
                              icon: _selectedIcon,
                              onPressed: () async {
                                final IconData? selectedIcon = await showIconPickerDialog(
                                  context: context, 
                                  icons: icons, 
                                  initialIcon: _selectedIcon
                                );
                                if (selectedIcon != null) {
                                  setState(() {
                                    _selectedIcon = selectedIcon;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                              style: GoogleFonts.quicksand(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              controller: _nameFieldController,
                              decoration: TextFieldDecorator.getTextFieldDecoration(
                                hintText: 'Your task name',
                                controller: _nameFieldController,
                                colorScheme: colorScheme,
                                onClear: () => setState(() {})
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the task name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSaved: (value) {
                                _taskName = value!;
                              },
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container (
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Title(
                          color: colorScheme.onTertiary, 
                          child: Text(
                            'TIME', 
                            style: GoogleFonts.quicksand(
                              color: colorScheme.onTertiary, 
                              fontWeight: FontWeight.bold,
                            )
                          )
                        ),
                      ),
                      const SizedBox(height: 5),
                      HourAndMinutePickerWidget(
                        initialHour: _selectedHour, 
                        initialMinute: _selectedMinute, 
                        onHourChanged: (hour) {
                          _selectedHour = hour;
                        }, 
                        onMinuteChanged: (minute) {
                          _selectedMinute = minute;
                        }, 
                      ),
                      const SizedBox(height: 8),
                      DateDisplayWidget(
                        initialDate: DateTime.now(),
                        onDateChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                    ])
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHighest), 
                      ),
                      onPressed: () {
                        setState(() {
                          _showMoreOptions = !_showMoreOptions;
                        });
                      },
                      child: Text(
                        'More options',
                        style: GoogleFonts.quicksand(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ),
                    Expanded(
                      child: Divider(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (_showMoreOptions)
                  Column(
                    children: [
                      TextFormField(
                        style: GoogleFonts.quicksand(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: _descriptionFieldController,
                        maxLines: 2,
                        decoration: TextFieldDecorator.getTextFieldDecoration(
                          hintText: "Enter the task's description", 
                          controller: _descriptionFieldController,
                          colorScheme: colorScheme,
                          onClear: () => setState(() {}),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _taskDescription = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      FilledButton.icon(
                        icon: Icon(Icons.timer, color: colorScheme.onSurfaceVariant),
                        label: Text(
                          _estimatedDuration != null 
                              ? 'Estimated: ${(_estimatedDuration! ~/ 3600).toString().padLeft(2, '0')}:${((_estimatedDuration! % 3600) ~/ 60).toString().padLeft(2, '0')}'
                              : 'Set estimated duration',
                          style: GoogleFonts.quicksand(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHighest),
                        ),
                        onPressed: () async {
                          final duration = await showDialog<int>(
                            context: context,
                            builder: (context) => EstimatedTimeDialog(
                              initialEstimatedDuration: _estimatedDuration,
                            ),
                          );
                          if (duration != null) {
                            setState(() {
                              _estimatedDuration = duration;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: const WidgetStatePropertyAll<Size>(Size(280, 29)),
                      backgroundColor: WidgetStatePropertyAll<Color>(colorScheme.primary),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Task task = Task(
                          id: widget.task?.id ?? '',
                          name: _taskName,
                          description: _taskDescription,
                          isCompleted: false,
                          icon: _selectedIcon.codePoint.toString(),
                          date: DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedHour,
                            _selectedMinute,
                          ),
                          memberId: '9993a0cb-7b79-48f1-9a03-3843b2ffa642',
                          estimatedDuration: _estimatedDuration,
                          priority: _selectedPriority,
                        );

                        try {
                          final createdTask;
                          if (widget.task != null) {
                            createdTask = await GetIt.I<TaskService>().updateTask(task);
                          } else {
                            createdTask = await GetIt.I<TaskService>().createTask(task);
                          }
                          
                          if (context.mounted) {
                            var taskList = context.read<TaskListState>();
                            taskList.add(createdTask);

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  content: Text('Task created successfully!'),
                                );
                              },
                            );

                            Future.delayed(const Duration(seconds: 1), () {
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error creating task: ${e.toString()}')),
                            );
                          }
                        }
                      }
                    },
                    child: Text(
                      'Create task',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}