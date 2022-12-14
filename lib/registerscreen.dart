import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  String login = '';
  String password = '';
  bool rememberFlag = false;
  bool inputFlag = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      checkData();
    });
  }

  Future<Map<String, String>> getDataFromDataBase() async {
    Map<String, String> dataFromDataBase = {};
    await _pref.then((SharedPreferences pref) {
      if(pref.containsKey('login')) {
        dataFromDataBase['login'] = pref.getString('login')!;
      }
      if(pref.containsKey('password')) {
        dataFromDataBase['password'] = pref.getString('password')!;
      }
      if(pref.containsKey('authorized')) {
        dataFromDataBase['authorized'] = pref.getString('authorized')!;
      }
    });

    return dataFromDataBase;
  }

  Future<void> setDataToDataBase(
      String login, String password, bool authorized) async {
    await _pref.then((SharedPreferences pref) {
      pref.setString('login', login);
      pref.setString('password', password);
      pref.setString('authorized', rememberFlag.toString());
    });
  }

  void checkData() async {
    Map<String, String> dataFromDataBase = await getDataFromDataBase();
    if(dataFromDataBase.isNotEmpty) {
      if(dataFromDataBase.containsKey('authorized')) {
        if(dataFromDataBase['authorized'] == 'true') {
          goToHomeScreen();
          setState(() {
            inputFlag = true;
          });
          return;
        }
      }
      if(dataFromDataBase.containsKey('login') && dataFromDataBase.containsKey('password')) {
        if (login == dataFromDataBase['login'] && password == dataFromDataBase['password']) {
          if (rememberFlag == true) {
            await setDataToDataBase(login, password, rememberFlag);
          }
          goToHomeScreen();
          setState(() {
            inputFlag = true;
          });
          return;
        } else {
          if(login != '' && password != '') {
            Fluttertoast.showToast(
              msg: '???? ?????????? ???????????????????????? ?????????? ???? ????????????',
              gravity: ToastGravity.BOTTOM,
            );
          }
          setState(() {
            inputFlag = true;
          });
        }
      }
    }
    else {
      await setDataToDataBase('admin', '123456', false);
      setState(() {
        inputFlag = true;
      });
    }
  }

  void goToHomeScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(children: [
            const Spacer(),
            Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    onSaved: (String? value) {
                      setState(() {
                        login = value!;
                      });
                    },
                    decoration: const InputDecoration(hintText: '??????????'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      decoration: const InputDecoration(hintText: '????????????'),
                      onSaved: (String? value) {
                        setState(() {
                          password = value!;
                        });
                      })
                ])),
            Row(
              children: [
                const Text("??????????'??????????"),
                Checkbox(
                    value: rememberFlag,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberFlag = value!;
                      });
                    })
              ],
            ),
            const SizedBox(height: 10),
            Opacity(
              opacity: inputFlag ? 0 : 1,
              child: Image.asset(
                'assets/image/loading-gif.gif',
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  if (inputFlag == true) {
                    setState(() {
                      inputFlag = false;
                    });
                    _formKey.currentState!.save();
                    checkData();
                  }
                },
                child: const Text("????????")),
            const Spacer(),
          ]),
        ),
      ),
    );
  }
}
