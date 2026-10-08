import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:location_tracking/core/dio/injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true, // default
)
Future<void> configureDependencies() async => await getIt.init();