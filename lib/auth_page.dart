import 'package:biometriclogin/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late LocalAuthentication auth;
  bool _isSupported = false;

  Future<void> checkAuth() async{
      try{
        bool authenticated = await auth.authenticate(
            localizedReason: 'Unlock to use this app',
            options: const AuthenticationOptions(
                stickyAuth: true,
                biometricOnly: false
            )
        );

        if(authenticated){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage()
            )
          );
        }

      } on PlatformException catch (e){
        print(e);
      }
  }

  Future<void> checkBiometricSupport() async {
    bool isSupported = await auth.isDeviceSupported();
    setState(() {
      _isSupported=isSupported;
    });
  }

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    checkBiometricSupport();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Biometric Authentication App"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !_isSupported
          ? const Center(child: Text('Biometric Authentication not supported'),)
          : const Center(child: Text('Biometric Authentication supported'),),


          ElevatedButton(
            onPressed: checkAuth,
            child: const Text('Authenticate',),
          )
        ],
      ),
    );
  }
}

