
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/username_data.dart';
import '../main.dart';

showLogoutAlert(BuildContext context) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    style: TextButton.styleFrom(
      backgroundColor: Colors.white, // Background Color
    ),
    child: Text(
      "No",
      style: GoogleFonts.audiowide(color:Colors.black)
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = ElevatedButton(
    style: TextButton.styleFrom(
      backgroundColor: Colors.red, // Background Color
    ),
    onPressed: () {
      saveUserID(0);
      saveIsAdmin(false);
      saveUsername("");
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('loadingpage');
      _onLoading(context);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();

        Navigator.of(context).pushNamed('login');
        snackbarKey.currentState?.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shape: const StadiumBorder(),
          content: Row(
            children: [
              const Icon(Icons.logout, color: Colors.white),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  'Successfully Logged-out.',
                  style: GoogleFonts.audiowide(color:Colors.white)
                ),
              ),
            ],
          ),
        ));
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => const LoginPage()));
      });
    },
    child: Text(
      "Yes",
      style: GoogleFonts.audiowide(color:Colors.black)),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title:  Text("Logout",style: GoogleFonts.audiowide(color:Colors.black)),
    content:  Text(
      "Are you sure you want to logout",
      style: GoogleFonts.audiowide(color:Colors.black)
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void _onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          height: 60,
          width: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children:  [
              const CircularProgressIndicator(color: Colors.orange),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Logging out...",
                style: GoogleFonts.audiowide(color:Colors.black,fontSize: 20),
              ),
            ],
          ),
        ),
      );
    },
  );
}