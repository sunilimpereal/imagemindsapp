import 'package:flutter/material.dart';
import 'package:imagemindsapp/utils/bloc.dart';
import 'package:rxdart/subjects.dart';

class VedioScreenBloc extends Bloc {
  BuildContext context;
  VedioScreenBloc(this.context) {}
  final _selectedCourseController = BehaviorSubject<List<String>>();

  Stream<List<String>> get selectedCourseStream =>
      _selectedCourseController.stream.asBroadcastStream();

  void updateSelectedScreen({required String grade, required String course}) async {
    if (grade == "" && course == "") {
      _selectedCourseController.sink.add([]);
    } else {
      _selectedCourseController.sink.add([grade, course]);
    }
  }

  @override
  void dispose() {
    _selectedCourseController.close();
  }
}

class VedioScreenProvider extends InheritedWidget {
  late VedioScreenBloc bloc;
  BuildContext context;
  VedioScreenProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = VedioScreenBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static VedioScreenBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<VedioScreenProvider>()
            as VedioScreenProvider)
        .bloc;
  }
}
