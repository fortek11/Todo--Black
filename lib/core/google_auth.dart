import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthServ {
  //google sign in
  signInWithGoo() async {
    //begin proccess
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //obtain auth details
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create new cred
    final cred = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return {
      //sign in
      await FirebaseAuth.instance.signInWithCredential(cred),
    };
  }
}
