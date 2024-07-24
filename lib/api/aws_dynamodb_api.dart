/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 10/07/2021
 * Copyright :  S.Hamblett
 *
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:path_provider/path_provider.dart';

/// An example of connecting to the AWS IoT Core MQTT broker and publishing to a devices topic.
/// This example uses MQTT on port 8883 using certificites
/// More instructions can be found at https://docs.aws.amazon.com/iot/latest/developerguide/mqtt.html and
/// https://docs.aws.amazon.com/iot/latest/developerguide/protocols.html, please read this
/// before setting up and running this example.

/*
late void Function(List) attPage2;
void awsRecivePage2Att(void Function(List) fun) {
  attPage2 = fun;
}*/
import 'package:http/http.dart' as http;

class AwsDynamoDB {
  // Creat Singleton
  static final AwsDynamoDB _shared = AwsDynamoDB._sharedInstance();
  AwsDynamoDB._sharedInstance();
  factory AwsDynamoDB() => _shared;

  dynamic _recipeData;

  get getRecipeData => _recipeData;

  late Function _goDataOk;

  final AllData _data = AllData();
  
  goDataOk(Function fun) {
    _goDataOk = fun;
  }

  loadRecipeData() async {
    if (_recipeData != null) {
      _goDataOk();
    } else if (await hasReceitas()) {
      await readRecipeFile();
    } else {
      await getAllData();
    }
  }

  newRecipeData() {
    int testData = DateTime.now().millisecondsSinceEpoch;
    print("Teste Delta Data download Receitas");
    print(testData);
    print(_recipeData['AppDate']);
    num deltaTime = (testData - _recipeData['AppDate']) /
        86400000; // 86400000 = 1000mili * 60seg * 60min * 24hrs
    print(deltaTime);
    if (deltaTime > 1) {
      getAllData();
    }
  }

  //Return true if all 3 files exists
  Future<bool> hasReceitas() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/AWS/Receitas.txt');
    if (!file.existsSync()) {
      return false;
    }
    return true;
  }

  Future<void> getAllData() async {
    var url = Uri.https(
        //'h2k2lfbpqioi443tmo3uiqcamm0scrvi.lambda-url.sa-east-1.on.aws', // Conta antiga
        'hx2dsfyi7oiej24l23aylzkkzu0bcdiy.lambda-url.sa-east-1.on.aws', // Conta nova
        '',
        {'fun': 'getAll'});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      jsonData['AppDate'] = DateTime.now().millisecondsSinceEpoch;
      _creatRecipeFile(json.encode(jsonData));
      _recipeData = jsonData;
      _goDataOk();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getById(String recipeId) async {
    var url = Uri.https(
        //'h2k2lfbpqioi443tmo3uiqcamm0scrvi.lambda-url.sa-east-1.on.aws', Conta Antiga
        'hx2dsfyi7oiej24l23aylzkkzu0bcdiy.lambda-url.sa-east-1.on.aws', // Conta Nova
        '',
        {'fun': 'getById', 'id': recipeId});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getClientHasDisp(String dispName, Function changeState) async {
    if (_data.getFirstClientHasDisp) {
      print("entrouuuuu1");
      _data.setFirstClientHasDisp = false;
      //https://w6f4yzgqhhnievclw2kqr47aei0sffiw.lambda-url.sa-east-1.on.aws/?fun=getAll&id=6666
      var url = Uri.https(
          'w6f4yzgqhhnievclw2kqr47aei0sffiw.lambda-url.sa-east-1.on.aws', '', {
        'fun': 'getAll',
        'id': {dispName.replaceAll("ChurrasTech", "")}
      });
      final response = await http.get(url);
      print("TESTE, ${response.body}");
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        if (jsonData == 1) {
          _data.setDynamoUserAlexaLink = true;
          changeState();
        } else {
          _data.setDynamoUserAlexaLink = false;
          changeState();
        }
      } else {
        _data.setDynamoUserAlexaLink = false;
        changeState();
        //throw Exception('Failed to load data');
      }
    }
  }

  //Future<Map<String, dynamic>> _readRecipeFile() async {
  Future readRecipeFile() async {
    File file;
    getApplicationDocumentsDirectory().then((directory) => {
          file = File('${directory.path}/AWS/Receitas.txt'),
          file.readAsString().then((value) => {
                _recipeData = json.decode(value),
                print('Read Recipe - Done'),
                _goDataOk(),
                //print(recipeData['AppDate']),
                //print(recipeData['Items'])
              }),
        });
  }

  void _creatRecipeFile(String _data) {
    File file;
    getApplicationDocumentsDirectory().then((directory) => {
          file = File('${directory.path}/AWS/Receitas.txt'),
          file.create(recursive: true).then((_) =>
              {file.writeAsString(_data), print('GetAll and Save - Done')}),
        });
  }
} // End of Class AwsController
