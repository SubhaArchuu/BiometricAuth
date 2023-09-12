import 'dart:async';
import 'package:biometric_authentication/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth/local_auth.dart';



class Biometric extends StatefulWidget {
  const Biometric({Key? key}) : super(key: key);

  @override
  State<Biometric> createState() => _BiometricState();
}

class _BiometricState extends State<Biometric> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
   // _authenticateWithBiometrics();
  //  setState(() {
      if(_supportState == _SupportState.supported ){
        _authenticateWithBiometrics();
      }
      else if(_supportState == _SupportState.unknown)
      {
        _authenticateWithBiometrics();
       // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Success()));
      }
  //  });


  }
  
  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint (or face or whatever) to authenticate',
       // options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true,),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;

    });
   if(_authorized == 'Authorized')
    Navigator.push(context, MaterialPageRoute(builder: (context) => Success()));
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Authentication'),
        ),
        body:  RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.orange,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,

            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              if (this.mounted) {
                setState(() {
                  _refreshProducts(context);
                });
              }
            },

            child:
    ListView(
                padding: const EdgeInsets.only(top: 180),
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Visibility(
                            visible: ((_supportState == _SupportState.supported)&& _isAuthenticating) ,
                            child: Text('Current State: $_authorized\n')),
                        if (!_isAuthenticating)
                          Text("please reload and try again")
                        /*  ElevatedButton(
                            onPressed: _cancelAuthentication,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text('Cancel Authentication'),
                                Icon(Icons.cancel),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: _authenticateWithBiometrics,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(_isAuthenticating
                                        ? 'Cancel'
                                        : 'Authenticate: biometrics only'),
                                    const Icon(Icons.fingerprint),
                                  ],
                                ),
                              ),
                            ],
                          ),*/
                      ],
                    ),
                  ),
                ],
              ),

        ),

      ),
    );
  }
  Future<void> _refreshProducts(BuildContext context) async {
    if(!_isAuthenticating) {
      return _authenticateWithBiometrics();
    }
    else {
      return;
    }
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}