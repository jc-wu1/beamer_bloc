import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication_bloc.dart';

class LoggedInPage extends StatelessWidget {
  const LoggedInPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Logged In'),
          actions: [
            MaterialButton(
              onPressed: context.read<AuthenticationBloc>().logout,
              child: const Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                'You are logged in as a user with id: ${context.read<AuthenticationBloc>().state.user.id}',
              ),
              ElevatedButton(
                onPressed: () => context.beamToNamed(
                  '/logged_in_page/books',
                ),
                child: const Text('See books'),
              ),
            ],
          ),
        ),
      );
}
