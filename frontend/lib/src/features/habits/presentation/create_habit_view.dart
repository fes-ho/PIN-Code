import 'package:flutter/material.dart';
import 'package:frontend/src/common_widgets/date_display.dart';
import 'package:frontend/src/common_decorators/text_field_decorator.dart';
import 'package:frontend/src/common_widgets/hour_and_minute_picker.dart';
import 'package:frontend/src/common_widgets/icon_picker.dart';
import 'package:frontend/src/common_widgets/rounded_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/constants/icons.dart';
import 'package:frontend/src/features/habits/domain/habit.dart';
import 'package:frontend/src/features/habits/domain/day_time.dart';
import 'package:frontend/src/features/habits/application/habit_service.dart';
import 'package:frontend/src/features/habits/presentation/habit_list_state.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateHabitScreen extends StatefulWidget {

  final Habit? habit;

  const CreateHabitScreen({
    super.key,
    this.habit,
  });

  @override
  CreateHabitScreenState createState() => CreateHabitScreenState();
}

class CreateHabitScreenState extends State<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController = TextEditingController();

  late String _habitName;
  late String _habitDescription;
  late IconData _selectedIcon;
  late DayTime _selectedDayTime;

  
  bool _showMoreOptions = false;

  @override
  @override
  void initState() {
    super.initState();
    _selectedDayTime = widget.habit?.dayTime ?? DayTime.morning;
    _selectedIcon = 
      widget.habit?.icon != null ? IconData(int.parse(widget.habit!.icon,), fontFamily: 'MaterialIcons') : Icons.edit;
    _nameFieldController.text = widget.habit?.name ?? '';
    _descriptionFieldController.text = widget.habit?.description ?? '';
    _habitDescription = widget.habit?.description ?? '';
    _habitName = widget.habit?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'New Habit',
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
                                hintText: 'Your habit name',
                                controller: _nameFieldController,
                                colorScheme: colorScheme,
                                onClear: () => setState(() {})
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the habit name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSaved: (value) {
                                _habitName = value!;
                              },
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Day Time',
                        style: GoogleFonts.quicksand(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: DayTime.values.map((dayTime) {
                           return RadioListTile<DayTime>(
                            title: Text(dayTime.name),
                            value: dayTime,
                            groupValue: _selectedDayTime,
                            onChanged: (value) {
                              setState(() {
                               _selectedDayTime = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
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
                      hintText: "Enter the habit's description", 
                      controller: _descriptionFieldController,
                      colorScheme: colorScheme,
                      onClear: () => setState(() {}),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _habitDescription = value;
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
                        Habit habit = Habit(
                          id: widget.habit?.id ?? '',
                          name: _habitName,
                          description: _habitDescription,
                          isCompleted: false,
                          icon: _selectedIcon.codePoint.toString(),
                          dayTime: _selectedDayTime,
                          memberId: '9993a0cb-7b79-48f1-9a03-3843b2ffa642',
                        );

                        try {
                          final createdHabit;
                          if (widget.habit != null) {
                            createdHabit = await GetIt.I<HabitService>().updateHabit(habit);
                          } else {
                            createdHabit = await GetIt.I<HabitService>().createHabit(habit);
                          }
                          
                          if (context.mounted) {
                            var taskList = context.read<HabitListState>();
                            taskList.add(createdHabit);

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
                              SnackBar(content: Text('Error creating habit: ${e.toString()}')),
                            );
                          }
                        }
                      }
                    },
                    child: Text(
                      'Create habit',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ),
                ),
              ]
            )
          )
        )
      ),
    );
  }
}