import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/bloc/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with ValidationMixin {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _mobileNo = BehaviorSubject<String>();
  final _otp = BehaviorSubject<String>();
  
  //gettters
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeMobNo => _mobileNo.sink.add;
  Function(String) get changeOtp => _otp.sink.add;

  //streams
  Stream<String> get email => _email.stream.transform(validatorEmail);
  Stream<String> get password => _password.stream.transform(validatorPassword);
  Stream<String> get mobileNo => _mobileNo.stream.transform(validatorNumber);
  Stream<String> get otp => _otp.stream.transform(validatorOtp);

  Stream<bool> get submitValidForm => Rx.combineLatest2(email, password, (e, n) => true);
  Stream<List<String>> get validateFormStream => Rx.combineLatestList(
        [
          email,
          password,
        ],
      );
  Stream<List<String>> get validateFormMobStream => Rx.combineLatestList(
        [
          mobileNo,
        ],
      );
  dispose() {
    _email.close();
    _password.close();
    _mobileNo.close();
    _otp.close();
  }
}

class LoginProvider extends InheritedWidget {
  final bloc = LoginBloc();
  LoginProvider({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static LoginBloc? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LoginProvider>())!.bloc;
  }
}
