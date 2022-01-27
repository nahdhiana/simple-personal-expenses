import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class ListTransactionItem extends StatefulWidget {
  const ListTransactionItem({
    Key? key,
    required this.transaction,
    required Function deleteTransaction,
  })  : _deleteTransaction = deleteTransaction,
        super(key: key);

  final Transaction transaction;
  final Function _deleteTransaction;

  @override
  State<ListTransactionItem> createState() => _ListTransactionItemState();
}

class _ListTransactionItemState extends State<ListTransactionItem> {
  Color _bgColor = Colors.teal;
  // state that run 1st when build widget
  @override
  void initState() {
    const availableColors = [
      Colors.blue,
      Colors.amber,
      Colors.deepPurple,
      Colors.orange,
    ];
    //set _bgColor to random color based on available color
    //4 =total available colors
    _bgColor = availableColors[Random().nextInt(availableColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 5,
      ),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          // add background color with random color from availabeColor
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text('\$ ${widget.transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(
          DateFormat.yMMMEd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
                onPressed: () =>
                    widget._deleteTransaction(widget.transaction.id),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).errorColor,
                ),
              )
            : IconButton(
                onPressed: () =>
                    widget._deleteTransaction(widget.transaction.id),
                icon: const Icon(
                  Icons.delete,
                ),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
