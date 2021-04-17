import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'coin_data.dart';
import 'api.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final currency = new NumberFormat("#,##0.00", "en_US");
  String selectedCurrency = 'USD';
  String url =
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin,monero,ripple&vs_currencies';
  dynamic bitcoin = 0;
  dynamic litecoin = 0;
  dynamic ethereum = 0;
  dynamic ripple = 0;
  dynamic monero = 0;

  void initState() {
    super.initState();
    changeTickerData();
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            changeTickerData();
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Text> listItems = [];
    for (String currency in currenciesList) {
      listItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          changeTickerData();
        });
      },
      children: listItems,
    );
  }

  void changeTickerData() async {
    Api api = new Api('$url=$selectedCurrency');
    var tickerData = await api.getData();
    setState(() {
      bitcoin = tickerData['bitcoin'][selectedCurrency.toLowerCase()];
      litecoin = tickerData['litecoin'][selectedCurrency.toLowerCase()];
      ethereum = tickerData['ethereum'][selectedCurrency.toLowerCase()];
      ripple = tickerData['ripple'][selectedCurrency.toLowerCase()];
      monero = tickerData['monero'][selectedCurrency.toLowerCase()];
    });
    print(bitcoin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: [
                CurrencyCard(
                  currency: currency,
                  coin: bitcoin,
                  selectedCurrency: selectedCurrency,
                  coinName: 'BTC',
                ),
                CurrencyCard(
                  currency: currency,
                  coin: ethereum,
                  selectedCurrency: selectedCurrency,
                  coinName: 'ETH',
                ),
                CurrencyCard(
                  currency: currency,
                  coin: litecoin,
                  selectedCurrency: selectedCurrency,
                  coinName: 'LTC',
                ),
                CurrencyCard(
                  currency: currency,
                  coin: ripple,
                  selectedCurrency: selectedCurrency,
                  coinName: 'XRP',
                ),
                CurrencyCard(
                  currency: currency,
                  coin: monero,
                  selectedCurrency: selectedCurrency,
                  coinName: 'XMR',
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    Key key,
    @required this.currency,
    @required this.coin,
    @required this.coinName,
    @required this.selectedCurrency,
  }) : super(key: key);

  final NumberFormat currency;
  final dynamic coin;
  final String selectedCurrency;
  final String coinName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.0,
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinName = ' + currency.format(coin) + ' $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
