import 'package:flutter/material.dart';
import 'adaptative_button.dart';
import 'adaptative_textfield.dart';
import 'adaptative_datepicker.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ??
        0.0; //tryParse serve para tentar fazer o parse no texto, caso nao consiga iremos colocar o valor 0.0

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate);
  }

  // _showDatePicker() {
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(), //Data iniciar hoje
  //     firstDate: DateTime(2019), //Data mais antiga 1/1/2019
  //     lastDate: DateTime
  //         .now(), //Ultima data hoje, ou seja, nao permite selecionar data no futuro
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     setState(() {
  //       //Essa e forma que o Flutter entende que o dado foi alterado e a interaface precisa refletir a alteracao desse valor
  //       _selectedDate = pickedDate;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: <Widget>[
              AdpatativeTextField(
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                label: 'Título',
              ),
              // TextField(
              //   controller: _titleController,
              //   onSubmitted: (_) => _submitForm(),
              //   decoration: InputDecoration(labelText: 'Título'),
              // ),
              AdpatativeTextField(
                controller: _valueController,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                onSubmitted: (_) => _submitForm(),
                label: 'Valor R\$',
              ),
              // TextField(
              //   controller: _valueController,
              //   keyboardType: TextInputType.numberWithOptions(
              //       decimal: true, signed: true),
              //   onSubmitted: (_) => _submitForm(),
              //   decoration: InputDecoration(labelText: 'Valor R\$'),
              // ),
              // Container(
              //   height: 70,
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           _selectedDate == null
              //               ? 'Empty Date'
              //               : 'Selected Date: ${DateFormat('dd/MM/y').format(_selectedDate)}',
              //         ),
              //       ),
              //       FlatButton(
              //         textColor: Theme.of(context).primaryColor,
              //         child: Text(
              //           'Select Date',
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         onPressed: _showDatePicker,
              //       )
              //     ],
              //   ),
              // ),
              AdaptativeDatePiker(
                selectedDate: _selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdaptativeButton(
                    label: 'New Transaction',
                    onPressed: _submitForm,
                  ),
                  // RaisedButton(
                  //   child: Text('New Transaction'),
                  //   color: Theme.of(context).primaryColor, //cor roxa no botao
                  //   textColor: Theme.of(context)
                  //       .textTheme
                  //       .button
                  //       .color, //cor branca no texto dentro do botao
                  //   //textColor: Colors.purple,
                  //   onPressed: _submitForm,
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
