import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions
            .isEmpty // Operacao ternaria (?). Se transaction estiver vazia, apresentar o Column (imagem + Empty List), caso contrario (:) apresentar o ListView
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                const SizedBox(
                    height: 20), // Espaco entre o texto e o Widget de Grafico
                Text(
                  'Empty List',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20), // Espaco entre a imagem e o texto
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover, // Ajustar o fit da imagem
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return TransactionsItem(
                key: GlobalObjectKey(tr),
                tr: tr,
                onRemove: onRemove,
              );
              // ListView(
              //   children: transactions.map((tr) {
              //     return TransactionsItem(
              //          key: ValueKey(tr.id),
              //          tr: tr,
              //          onRemove: onRemove,
              //     );
              //   }).toList(),
              // );

              //Card(
              //   child: Row(
              //     children: <Widget>[
              //       Container(
              //         margin:
              //             EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //               color: Theme.of(context).primaryColor, width: 2),
              //         ),
              //         padding: EdgeInsets.all(10),
              //         child: Text(
              //           'R\$ ${tr.value.toStringAsFixed(2)}', //Utilizacao de interpolacao de strings para mostrar o modelo da moeda R$ e utilizamos o toStringAsFixed(2) p/ sempre termos dois numeros na casa decimal (padronizacao dos valores)
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 20,
              //               color: Theme.of(context).primaryColor),
              //         ),
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Text(
              //             tr.title,
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .headline6, //pegar as configuracoes definidas dentro de Theme na main.dart e aplicar no titulo da despesa
              //             // style: TextStyle(
              //             //   fontWeight: FontWeight.bold,
              //             //   fontSize: 16,
              //             // ),
              //           ),
              //           Text(
              //             DateFormat('d MMM y').format(tr
              //                 .date), //importamos o pacote intl para formatar a data. Add no arquivo pubspec.yaml
              //             style: TextStyle(color: Colors.grey),
              //           ),
              //         ],
              //       )
              //     ],
              //   ),
              // );
            },
          );
  }
}
