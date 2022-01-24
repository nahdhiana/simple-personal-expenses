import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transactionlist extends StatelessWidget {
  final List transactions;
  final Function _deleteTransaction;
  const Transactionlist(this.transactions, this._deleteTransaction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: transactions.isEmpty
          ? Column(
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
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 5,
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                              '\$ ${transactions[index].amount.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMEd().format(transactions[index].date),
                    ),
                    trailing: IconButton(
                      onPressed: () =>
                          _deleteTransaction(transactions[index].id),
                      icon: const Icon(
                        Icons.delete,
                      ),
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
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
              itemCount: transactions.length,
            ),
    );
  }
}
