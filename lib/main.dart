import 'package:despesas_financeiras/components/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/transaction_form.dart';
import './components/transaction_list.dart';
import 'models/transaction.dart';
import 'dart:math';
import './components/chart.dart';
import 'dart:io';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*Serve para travar a orentacao da app, ou seja, nesse modelo o app nao gira p/ o modelo paisagem.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    */

    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        accentColor: Colors.amber,
        primarySwatch:
            Colors.purple, //Nessa opcao podemos acessar o espectro de cores
        //accentColor: Colors.amber, //Deprecated. Se for utilizar para colorior o floatbutton, utilizar o modelo abaixo.
        fontFamily: 'Quicksand',
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber, //Cor do botao
          foregroundColor: Colors.black, //Cor do desenho dentro do botao
        ),
        // Customizando o titulo das desepesas
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            // Customizando a cor do botao e colocando bold
            button: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        // Customizando apenas o texto do appbar
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    // Filtrando as transacoes recentes (Ultimos 7 dias)
    return _transactions.where((tr) {
      //where e uma funcao filter (true or false)
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList(); // Gera uma lista a partir do filtro (where) aplicado, ou seja, uma lista das ultimas transacoes realizadas (ultimos 7 dias)
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      //Primeiro title é o atributo nomeado do construtor Transaction e o segundo title é o parametro recebido via form.
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);

      Navigator.of(context).pop(); //fechar o modal apos enviar o formulario
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  Widget _getIconButton(IconData icon, Function fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool islandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final iconChart = Platform.isIOS ? CupertinoIcons.refresh : Icons.insert_chart;

    final actions = <Widget>[
      if (islandscape)
        _getIconButton(
          _showChart ? iconList : iconChart,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Despesas Pessoais'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          )
        : AppBar(
            title: Text(
              'Despesas Pessoais',
              style: TextStyle(
                  //* mediaQuery.textScaleFactor //Esse MediaQuery serve p/ deixar o text responsivo de acordo com o gosto do usuario ao selecionar nas configuracoes do dispositivo o tamanho da fonte p/ o device
                  fontSize: 20),
            ),
            //centerTitle: false,
            actions: actions,
          );

    //tamanho total da tela (-) o tamanho do appBar (-) tamanho do status bar
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        //Habilita o scroll na tela. No entanto, o componente pai precisa de um tamanho pre definido. (Utilizar Container e height: 300)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Serve para esticar e preencher todo o espaco (Similar o width: double.infinity)
          //mainAxisAlignment: MainAxisAlignment.spaceAround, // Serve para colocar espaco entre as colunas
          children: <Widget>[
            // if (islandscape)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text('Show Graphic'),
            //     Switch.adaptive( // Construtor adaptativo para apresentar o switch no modelo ios/Android
            //       value: _showChart,
            //       activeColor: Theme.of(context).accentColor,
            //       onChanged: (value) {
            //         setState(() {
            //           _showChart = value;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            if (_showChart || !islandscape)
              Container(
                height: availableHeight * (islandscape ? 0.7 : 0.3),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !islandscape)
              Container(
                height: availableHeight * (islandscape ? 1 : 0.7),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            //Validacao da plataforma p/ apresentar o floatbutton. No iOS nao existe esse componente. Logo, neste caso substituimos por um container vazio
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
