import 'package:flutter/material.dart';
import 'package:frontend/src/components/date_display.dart';
import 'package:frontend/src/components/rounded_icon_button.dart';

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
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New task'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
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
                      decoration: const InputDecoration(labelText: 'Your task name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the task name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _taskName = value!;
                      },
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 15),
              Container (
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3C8C7),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Title(color: Colors.white, child: const Text('Time', style: TextStyle(color: Colors.white))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    SizedBox(
                      height: 200,
                      width: 100,
                      child: ListWheelScrollView.useDelegate(
                        controller: _hourController,
                        useMagnifier: true,
                        magnification: 1.2,
                        physics: const FixedExtentScrollPhysics(),
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _selectedHour = index;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 25,
                          builder: (context, index) {
                            final String formattedIndex = index.toString().padLeft(2, '0');
                            final bool isSelected = index == _selectedHour;
                            return ListTile(
                              title: Center(
                                child: Text(
                                  formattedIndex, 
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFFF8F0DF) : const Color.fromARGB(255, 211, 204, 188),
                                    fontSize: 18.0, 
                                    fontWeight: FontWeight.w500
                                  )
                                )
                              ),
                            );
                          }
                        )
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 17.0), 
                      child: Text(
                      ':',
                      style: TextStyle(
                          color: Color(0xFFF8F0DF),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: 100,
                      child: ListWheelScrollView.useDelegate(
                        controller: _minuteController,
                        useMagnifier: true,
                        magnification: 1.2,
                        physics: const FixedExtentScrollPhysics(),
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _selectedMinute = index;
                          });
                        }
                        ,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 60,
                          builder: (context, index) {
                            final String formattedIndex = index.toString().padLeft(2, '0');
                            final bool isSelected = index == _selectedMinute;
                            return ListTile(
                              title: Center(child: Text(
                                formattedIndex, 
                                style: TextStyle(
                                  color: isSelected ? const Color(0xFFF8F0DF) : const Color.fromARGB(255, 211, 204, 188),
                                  fontSize: 18.0, 
                                  fontWeight: FontWeight.w500)
                                )
                              ),
                            );
                          }
                        )
                      ),
                    ),
                    ],
                    ),
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