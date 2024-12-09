import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MyInputForm extends StatefulWidget {
  const MyInputForm({super.key});

  @override
  State<MyInputForm> createState() => _MyInputFormState();
}

class _MyInputFormState extends State<MyInputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerNama = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();

  String? _avatarPath;
  Color _pickedColor = Colors.blue;

  final List<Map<String, dynamic>> _myDataList = [];
  Map<String, dynamic>? editedData;

  String? _validatePhone(String? value) {
    if (value!.isEmpty) return 'Phone number wajib diisi';
    if (double.tryParse(value) == null) return "Only numbers allowed!";
    return null;
  }

  String? _validateNama(String? value) {
    if (value!.length < 3) return 'Please type at least 3 characters!';
    return null;
  }

  String? _validateDate(String? value) {
    if (value!.isEmpty) return 'Please select a date!';
    return null;
  }

  String? _validateAvatar() {
    if (_avatarPath == null) return 'Please select an avatar image!';
    return null;
  }

  String? _validateColor() {
    if (_pickedColor == Colors.blue) return 'Please pick a color!';
    return null;
  }

  Future<void> _pickAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _avatarPath = result.files.single.path;
      });
    }
  }

  void _addData() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _controllerNama.text,
        'phone': _controllerPhone.text,
        'date': _controllerDate.text,
        'avatar': _avatarPath,
        'color': _pickedColor.value,
      };

      setState(() {
        if (editedData != null) {
          editedData!['name'] = data['name'];
          editedData!['phone'] = data['phone'];
          editedData!['date'] = data['date'];
          editedData!['avatar'] = data['avatar'];
          editedData!['color'] = data['color'];
          editedData = null;
        } else {
          _myDataList.add(data);
        }
        _controllerNama.clear();
        _controllerPhone.clear();
        _controllerDate.clear();
        _avatarPath = null;
        _pickedColor = Colors.blue;
      });
    }
  }

  void _editData(Map<String, dynamic> data) {
    setState(() {
      _controllerPhone.text = data['phone'];
      _controllerNama.text = data['name'];
      _controllerDate.text = data['date'];
      _avatarPath = data['avatar'];
      _pickedColor = Color(data['color']);
      editedData = data;
    });
  }

  void _deleteData(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const Text('Are you sure to remove this data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _myDataList.remove(data);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _controllerDate.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _pickedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controllerPhone.dispose();
    _controllerNama.dispose();
    _controllerDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _controllerPhone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Write your phone number here...',
                      labelText: 'Phone Number',
                      filled: true,
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2),
                      ),
                    ),
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _controllerNama,
                    decoration: InputDecoration(
                      hintText: 'Write your name here...',
                      labelText: 'Name',
                      filled: true,
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2),
                      ),
                    ),
                    validator: _validateNama,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _controllerDate,
                        decoration: InputDecoration(
                          hintText: 'Select Date',
                          labelText: 'Date',
                          filled: true,
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                          ),
                        ),
                        validator: _validateDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                      ),
                      onPressed: _pickAvatar,
                      child: const Text('Pick Avatar'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: _openColorPicker,
                      child: const Text('Pick Color'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: _addData,
                      child: Text(editedData != null ? "Update" : "Submit"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'List Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _myDataList.length,
                itemBuilder: (context, index) {
                  final data = _myDataList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: data['avatar'] != null
                              ? FileImage(File(data['avatar']))
                              : null,
                          child: data['avatar'] == null
                              ? Text(
                                  data['name'][0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['name'] ?? ''),
                              Text(data['phone'] ?? ''),
                              Text(data['date'] ?? ''),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Color(data['color']),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _editData(data);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteData(data);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
