import 'package:flutter/material.dart';
import 'package:frontend/src/components/date_display.dart';
import 'package:frontend/src/components/hour_and_minute_picker.dart';
import 'package:frontend/src/components/rounded_icon_button.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _taskName = '';
  String _taskDescription = '';
  DateTime _dueDate = DateTime.now();
  int _selectedHour = DateTime.now().hour;
  IconData _selectedIcon = Icons.edit;
  int _selectedMinute = DateTime.now().minute;
  final TextEditingController _nameFieldController = TextEditingController();

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
                      children: <Widget>[
                        RoundedIconButton(
                          initialIcon: Icons.edit,
                          onIconChanged: (icon) {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _nameFieldController,
                            decoration: InputDecoration(
                              labelText: 'Your task name',
                              fillColor: colorScheme.secondary,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorScheme.outline,
                                  width: 2,
                                  ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorScheme.secondary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              suffixIcon: _nameFieldController.text.isNotEmpty ? IconButton(
                                onPressed: () {
                                  _nameFieldController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                                ) : null,
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
                        color: Colors.white, 
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
                        print(_dueDate);
                      },
                    ),
                  ])
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Decription of the task'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción de la tarea';
                  }
                  return null;
                },
                onSaved: (value) {
                  _taskDescription = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Aquí puedes manejar el envío del formulario
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tarea creada con éxito')),
                    );
                  }
                },
                child: const Text('Create task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}