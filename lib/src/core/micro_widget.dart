// ignore_for_file: mixin_inherits_from_not_object
import 'package:flutter/material.dart';

import 'micro_host.dart';

/// [MicroHostStatelessWidget]
abstract class MicroHostStatelessWidget extends StatelessWidget with MicroHost {
  MicroHostStatelessWidget({Key? key}) : super(key: key) {
    registerRoutes();
  }
}

/// [MicroHostStatefulWidget]
abstract class MicroHostStatefulWidget extends StatefulWidget with MicroHost {
  MicroHostStatefulWidget({Key? key}) : super(key: key) {
    registerRoutes();
  }
}
