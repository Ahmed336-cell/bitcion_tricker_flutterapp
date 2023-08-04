import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "AUD";
  CoinData coinData = CoinData();

  DropdownButton<String> getAndroidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }



  CupertinoPicker getDropDownPickerIOS(){

    List<Text> items = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      items.add(newItem);
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
       selectedCurrency = currenciesList[selectedIndex];
       getData();
      },
      children: items,
    );
  }

String bitcoinValidRate = "?";
 /*  Widget getPicker(){
    if(Platform.isIOS){
      return getDropDownPickerIOS();
    }else if(Platform.isAndroid){
      return getAndroidDropDown();
    }else{
      return getDropDownPickerIOS();
    }
  }*/
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async{
    isWaiting = true;

    try{
      var data = await CoinData().getCoindData(selectedCurrency);
      isWaiting = false;

      setState(() {
        coinValues = data;
      });

    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                crypto: 'BTC',
                bitcoinValidRate: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                crypto: 'ETH',
                bitcoinValidRate: isWaiting ? '?' : coinValues['ETH'],
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                crypto: 'LTC',
                bitcoinValidRate: isWaiting ? '?' : coinValues['LTC'],
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),

          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              //child:Platform.isIOS ? getDropDownPickerIOS() : getAndroidDropDown(),
            child: getDropDownPickerIOS(),
          )
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard({
    this.crypto,
    this.selectedCurrency,
    this.bitcoinValidRate,
  }
);

   final crypto;
   final bitcoinValidRate;
   final selectedCurrency ;
  @override
  Widget build(BuildContext context) {
    return           Padding(
    padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
    child: Card(
    color: Colors.lightBlueAccent,
    elevation: 5.0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
    child: Text(
    '1 $crypto =  $bitcoinValidRate $selectedCurrency',
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

