import 'package:ai_frontend/views/home_view.dart';
import 'package:ai_frontend/views/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //listen to auth state changes
        stream: Supabase.instance.client.auth.onAuthStateChange,

        //build appropriate widget based on auth state
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.stretchedDots(
                  color: Colors.white,
                  size: 200,
                ),
              ),
            );
          }
          // check if there is a valid session currently
          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session != null) {
            return HomeView();
          } else {
            return SignUpView();
          }
        });
  }
}
