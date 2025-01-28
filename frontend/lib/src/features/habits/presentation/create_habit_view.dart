import 'package:flutter/material.dart';
import 'package:frontend/src/common_widgets/category_selector.dart';
import 'package:frontend/src/common_widgets/date_display.dart';
import 'package:frontend/src/common_decorators/text_field_decorator.dart';
import 'package:frontend/src/common_widgets/day_time_selector.dart';
import 'package:frontend/src/common_widgets/frequency_selector.dart';
import 'package:frontend/src/common_widgets/hour_and_minute_picker.dart';
import 'package:frontend/src/common_widgets/icon_picker.dart';
import 'package:frontend/src/common_widgets/rounded_icon_button.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/habits/domain/frequency.dart';
import 'package:frontend/src/features/habits/domain/category.dart';
import 'package:frontend/src/features/tasks/presentation/estimated_time_dialog.dart';
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
  final newHabitTitle = "New habit";
  final createHabitButton = "CREATE HABIT";
  final editHabitTitle = "Edit habit";
  final updateHabitButton = "UPDATE HABIT";

  late String _title;
  late String _titleButton; 
  late String _habitName;
  late String _habitDescription;
  late IconData _selectedIcon;
  late DayTime _selectedDayTime;
  late Frequency _selectedFrequency;
  late Category _selectedCategory;
  late int? _estimatedDuration;
  late DateTime _selectedDate;
  late int _selectedHour;
  late int _selectedMinute;

  bool _showMoreOptions = false;

  @override
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.habit?.date ?? DateTime.now();
    _selectedHour = widget.habit?.date.hour ?? DateTime.now().hour;
    _selectedMinute = widget.habit?.date.minute ?? DateTime.now().minute;
    _selectedDayTime = widget.habit?.dayTime ?? DayTime.morning;
    _selectedFrequency = widget.habit?.frequency ?? Frequency.daily;
    _selectedCategory = widget.habit?.category ?? Category.sleep;
    _selectedIcon = 
      widget.habit?.icon != null ? IconData(int.parse(widget.habit!.icon,), fontFamily: 'MaterialIcons') : Icons.edit;
    _nameFieldController.text = widget.habit?.name ?? '';
    _descriptionFieldController.text = widget.habit?.description ?? '';
    _habitDescription = widget.habit?.description ?? '';
    _habitName = widget.habit?.name ?? '';
    _estimatedDuration = widget.habit?.estimatedDuration;
    _title = widget.habit != null ? editHabitTitle : newHabitTitle;
    _titleButton = widget.habit != null ? updateHabitButton : createHabitButton;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _title,
          style: GoogleFonts.lexendDeca(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surfaceContainer,
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
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(
                      color: colorScheme.secondary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          border: Border(
                            bottom: BorderSide(
                              color: colorScheme.secondary,
                              width: 1.5,
                            ),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Title(
                          color: colorScheme.onPrimary, 
                          child: Text(
                            'NAME', 
                            style: GoogleFonts.quicksand(
                              color: colorScheme.onPrimary, 
                              fontWeight: FontWeight.bold,
                            )
                          )
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5), 
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
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
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
                              )   
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          border: Border.all(
                            color: colorScheme.secondary,
                            width: 1.5,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                        ),
                        child: Title(
                          color: colorScheme.onPrimary,
                          child: Text(
                            'CATEGORY',
                            style: GoogleFonts.quicksand(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            )
                          )
                        ),
                      ),
                      const SizedBox(height: 15),
                      CategorySelector(
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: (category){
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      ),
                      const SizedBox(height: 15),
                      Container (
                        width: double.infinity,
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
                                color: colorScheme.primary,
                                border: Border.all(
                                  color: colorScheme.secondary,
                                  width: 1.5,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                              ),
                              child: Title(
                                color: colorScheme.onTertiary, 
                                child: Text(
                                  'TIME', 
                                  style: GoogleFonts.quicksand(
                                    color: colorScheme.onPrimary, 
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
                      Container (
                        width: double.infinity,
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
                                color: colorScheme.primary,
                                border: Border.all(
                                  color: colorScheme.secondary,
                                  width: 1.5,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                              ),
                              child: Title(
                                color: colorScheme.onTertiary, 
                                child: Text(
                                  'FREQUENCY', 
                                  style: GoogleFonts.quicksand(
                                    color: colorScheme.onPrimary, 
                                    fontWeight: FontWeight.bold,
                                  )
                                )
                              ),
                            ),                            
                          ],
                        )
                      ),
                      const SizedBox(height: 15),
                      FrequencySelector(
                        selectedFrequency: _selectedFrequency,
                        onFrequencyChanged: (frequency){
                          setState(() {
                            _selectedFrequency = frequency;
                          });
                        }
                      ),
                      const SizedBox(height: 15),
                      DayTimeSelector(
                        selectedDayTime: _selectedDayTime,
                        onDayTimeChanged: (dayTime){
                          setState(() {
                            _selectedDayTime = dayTime;
                          });
                        }
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
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
                      fixedSize: const WidgetStatePropertyAll<Size>(Size(180, 29)),
                      backgroundColor: WidgetStatePropertyAll<Color>(colorScheme.surface),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: colorScheme.secondary,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final memberService = GetIt.I<MemberService>();
                        final memberId = await memberService.getMember().then((member) => member.id);
                        
                        Habit habit = Habit(
                          id: widget.habit?.id ?? '',
                          name: _habitName,
                          description: _habitDescription,
                          isCompleted: false,
                          icon: _selectedIcon.codePoint.toString(),
                          date: DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedHour,
                            _selectedMinute,
                          ),
                          dayTime: _selectedDayTime,
                          frequency: _selectedFrequency,
                          category: _selectedCategory,
                          memberId: memberId,
                          estimatedDuration: _estimatedDuration,
                        );

                        try {
                          final createdHabit;
                          if (widget.habit != null) {
                            createdHabit = await GetIt.I<HabitService>().updateHabit(habit);
                          } else {
                            createdHabit = await GetIt.I<HabitService>().createHabit(habit);
                          }
                          
                          if (context.mounted) {
                            var habitList = context.read<HabitListState>();
                            habitList.add(createdHabit);

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  content: Text('Habit created successfully!'),
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
                      _titleButton,
                      style: GoogleFonts.quicksand(
                        color: colorScheme.onPrimary,
                        fontSize: 17,
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