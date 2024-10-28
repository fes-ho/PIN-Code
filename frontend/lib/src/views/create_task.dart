import 'package:flutter/material.dart';
import 'package:frontend/src/components/date_display.dart';
import 'package:frontend/src/components/decorators/text_field_decorator.dart';
import 'package:frontend/src/components/hour_and_minute_picker.dart';
import 'package:frontend/src/components/icon_picker.dart';
import 'package:frontend/src/components/rounded_icon_button.dart';
import 'package:frontend/src/domain/icons.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController = TextEditingController();

  String _taskName = '';
  String _taskDescription = '';

  DateTime _dueDate = DateTime.now();
  int _selectedHour = DateTime.now().hour;
  IconData _selectedIcon = Icons.edit;
  int _selectedMinute = DateTime.now().minute;
  bool _showMoreOptions = false;

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
        leading: Icon(Icons.arrow_back, color: colorScheme.onSurface),
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
                            _dueDate = date;
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
                    onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Aquí puedes manejar el envío del formulario
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tarea creada con éxito')),
                      );
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
}