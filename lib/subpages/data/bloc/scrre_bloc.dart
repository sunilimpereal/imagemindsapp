import 'package:flutter/material.dart';
import 'package:imagemindsapp/utils/bloc.dart';
import 'package:rxdart/subjects.dart';

enum Screens {
  home,
  profile,
  programs,
  assessment,
  liveclasses,
  support_help,
  videos,
}

getScreenName(Screens screens) {
  switch (screens) {
    case Screens.home:
      return "Home";
    case Screens.profile:
      return "Profile";
    case Screens.programs:
      return "Programs";
    case Screens.liveclasses:
      return "Live Classes";
    case Screens.assessment:
      return "Assesment";
    case Screens.support_help:
      return "Support/Help";
    case Screens.home:
      return "Home";
    default:
      return "";
  }
}

class ScreenNavBloc extends Bloc {
  BuildContext context;
  ScreenNavBloc(this.context) {
     updateSelectedScreen(Screens.programs);
    //updateSelectedScreen(Screens.profile);
  }
  final _selectedScreenController = BehaviorSubject<Screens>();

  Stream<Screens> get selectedScreenStream => _selectedScreenController.stream.asBroadcastStream();

  void updateSelectedScreen(Screens screen) async {
    _selectedScreenController.sink.add(screen);
  }

  @override
  void dispose() {
    _selectedScreenController.close();
  }
}

class ScreenNavProvider extends InheritedWidget {
  late ScreenNavBloc bloc;
  BuildContext context;
  ScreenNavProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = ScreenNavBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static ScreenNavBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ScreenNavProvider>() as ScreenNavProvider)
        .bloc;
  }
}
