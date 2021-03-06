import 'package:flutter/widgets.dart';
import 'package:get/src/rx/rx_interface.dart';
import 'rx_impl.dart';

Widget obx(Widget Function() builder) {
  final b = builder;
  return Obxx(b);
}

/// it's very very very very experimental
class Obxx extends StatelessWidget {
  final Widget Function() builder;
  Obxx(this.builder, {Key key}) : super(key: key);
  final RxInterface _observer = Rx();

  @override
  Widget build(_) {
    _observer.subject.stream.listen((data) => (_ as Element)..markNeedsBuild());
    final observer = getObs;
    getObs = _observer;
    final result = builder();
    getObs = observer;
    return result;
  }
}

class Obx extends StatefulWidget {
  final Widget Function() builder;

  const Obx(this.builder);
  _ObxState createState() => _ObxState();
}

class _ObxState extends State<Obx> {
  RxInterface _observer;

  _ObxState() {
    _observer = Rx();
  }

  @override
  void initState() {
    _observer.subject.stream.listen((data) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _observer.close();
    super.dispose();
  }

  Widget get notifyChilds {
    final observer = getObs;
    getObs = _observer;
    final result = widget.builder();
    if (!_observer.canUpdate) {
      throw """
      [Get] the improper use of a GetX has been detected. 
      You should only use GetX or Obx for the specific widget that will be updated.
      If you are seeing this error, you probably did not insert any observable variables into GetX/Obx 
      or insert them outside the scope that GetX considers suitable for an update 
      (example: GetX => HeavyWidget => variableObservable).
      If you need to update a parent widget and a child widget, wrap each one in an Obx/GetX.
      """;
    }
    getObs = observer;
    return result;
  }

  @override
  Widget build(BuildContext context) => notifyChilds;
}
