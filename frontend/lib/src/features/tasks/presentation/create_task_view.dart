import 'package:flutter/material.dart';
import 'package:frontend/src/common_widgets/date_display.dart';
import 'package:frontend/src/common_decorators/text_field_decorator.dart';
import 'package:frontend/src/common_widgets/hour_and_minute_picker.dart';
import 'package:frontend/src/common_widgets/icon_picker.dart';
import 'package:frontend/src/common_widgets/rounded_icon_button.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_viewmodel.dart';
import 'package:frontend/src/routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/constants/icons.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({
    super.key,
    required this.viewModel,
  });

  final CreateTaskViewModel viewModel;

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController = TextEditingController();

  String _taskName = '';
  String _taskDescription = '';
  DateTime _selectedDate = DateTime.now();
  int _selectedHour = DateTime.now().hour;
  int _selectedMinute = DateTime.now().minute;
  IconData _selectedIcon = Icons.edit;
  
  bool _showMoreOptions = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.createTask.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateTaskView oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createTask.removeListener(_onResult);
    widget.viewModel.createTask.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.createTask.removeListener(_onResult);
    super.dispose();
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
          onPressed: () => context.go(Routes.today),
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
                        // This id is not used in the actual implementation
                        id: '1',
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
                        // TODO: Replace with actual member ID
                        memberId: '9993a0cb-7b79-48f1-9a03-3843b2ffa642',
                      );
                      await widget.viewModel.createTask.execute(task);
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.createTask.completed) {
      widget.viewModel.createTask.clearResult();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Text('Task created successfully!'),
          );
        },
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.pop();
          context.go(Routes.today);
        }
      });
    }

    if (widget.viewModel.createTask.error) {
      widget.viewModel.createTask.clearResult();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create task'),
          ),
        );
      }
    }
  }
}