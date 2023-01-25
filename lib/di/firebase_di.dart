import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

var serviceLocator = GetIt.instance;
Future getFirebaseInit() async {
  serviceLocator.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
}
