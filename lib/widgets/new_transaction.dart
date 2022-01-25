import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/adaptive_text_button.dart';

//statefull so the textfield not empty when filling data form in title to amount etc
class NewTransaction extends StatefulWidget {
  final Function addTransaction;
  const NewTransaction(this.addTransaction, {Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // String titleInput = '';
  final _titleInputController = TextEditingController();

  final _amountInputController = TextEditingController();

  DateTime? _selectedDate;

  void _submitData() {
    // print(titleInput);
    // print(titleInputController.text);

    final enteredTitle = _titleInputController.text;
    final enteredAmount = double.parse(_amountInputController.text);

//dummy validation, so if title is empty or amount has negative value,
// the code will stop
    if (enteredTitle.isEmpty || enteredAmount < 0 || _selectedDate == null) {
      return;
    }

//widget. to access your constructor etc from your widget class
// form your stateclass
    widget.addTransaction(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    //to close buttom modal after input data and save it
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2022),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            // add padding +10 from softkeyboard's top size, so the field/form
            // didn;t blocked by the softkeyboard
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleInputController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (String titleValue) {
                //   titleInput = titleValue; //saved every key stroke
                // },
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: _amountInputController,
                //only viewing keyboard number
                keyboardType: TextInputType.number,
                //convention (_) onSubmitted required argument but it is not use,
                //so replace/fill the argument with only _
                onSubmitted: (_) => _submitData(),
                //   onChanged: (String amountValue) =>
                //       amountInput = amountValue,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Choosen!'
                            : 'Picked Date ${DateFormat.yMMMEd().format(_selectedDate!)}',
                      ),
                    ),
                    AdaptiveTextButton(
                      label: 'Choose Date',
                      onTapButton: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
