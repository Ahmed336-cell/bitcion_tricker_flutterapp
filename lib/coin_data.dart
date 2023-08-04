import 'dart:convert';
import 'package:http/http.dart' as http;
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = "YOUR-API-KEY";
class CoinData {
  Future getCoindData(String currency) async{
    Map<String, String> cryptoPrices = {};
    for(String crypto in cryptoList){
      String url = '$coinAPIURL/$crypto/$currency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        var decodedData = jsonDecode(response.body);
        var lastPrice= decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      }else{
        print(response.statusCode);
        throw " error";
      }
    }


    return cryptoPrices;
  }



}
