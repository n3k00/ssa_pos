import 'package:ssa/app/config/app_flavor.dart';
import 'package:ssa/bootstrap.dart';

Future<void> main() async {
  await bootstrap(AppFlavor.staging);
}
