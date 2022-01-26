import 'package:flutter/material.dart';
import 'transaction_item.dart';

class Transactionlist extends StatelessWidget {
  final List _transactions;
  final Function _deleteTransaction;
  const Transactionlist(this._transactions, this._deleteTransaction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No Transactions Yet!',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.7,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return ListTransactionItem(
                  transaction: _transactions[index],
                  deleteTransaction: _deleteTransaction);
              // return Card(
              //   elevation: 5,
              //   child: Row(
              //     children: [
              //       Container(
              //         margin: const EdgeInsets.symmetric(
              //           vertical: 10,
              //           horizontal: 15,
              //         ),
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             //change color based on theme that defined in materialapp
              //             color: Theme.of(context).primaryColor,
              //             width: 2,
              //           ),
              //         ),
              //         padding: const EdgeInsets.all(8),
              //         child: Text(
              //           //\$ biar bisa gunain lambang $,
              //           //${} cetak text nilai variabel yg lebih dr 1 kata (kepisah .)
              //           //toStringAsFixed(2) to show only 2 decimals behind coma
              //           'Rp.${transactions[index].amount.toStringAsFixed(2)},-',
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 15,
              //             //change color based on theme that defined in materialapp
              //             color: Theme.of(context).primaryColor,
              //           ),
              //         ),
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             transactions[index].title,
              //             style: Theme.of(context).textTheme.bodyText1,
              //             // style: const TextStyle(
              //             //   fontWeight: FontWeight.bold,
              //             //   fontSize: 14,
              //             // ),
              //           ),
              //           Text(
              //             // DateFormat('dd-MMM-yyyy')
              //             //     .format(trx.date), //from intl package
              //             DateFormat.yMMMEd().format(transactions[index]
              //                 .date), //from intl package, same as above but not have to passing argument
              //             style: const TextStyle(
              //               fontSize: 11,
              //               color: Colors.grey,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // );
            },
            itemCount: _transactions.length,
          );
  }
}
