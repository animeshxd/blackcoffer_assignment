import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../application/account/account_cubit.dart';
import '../domain/entity/x_user.dart';
import 'home_page.dart';
import 'widgets/auth_aware.dart';
import 'widgets/main_app_body.dart';
import 'widgets/rounded_elevated_button.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   if (kDebugMode) {
//     await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
//     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
//   }
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BlocProvider(
//         create: (context) => AccountCubit(FirebaseFirestore.instance),
//         child: const CreateProfilePage(userUid: 'test'),
//       ),
//     );
//   }
// }

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key, required this.userUid});

  /// userUid as extra args
  static const path = '/new_users';
  final String userUid;
  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final usernameController = TextEditingController();
  final displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthAware(
          child: BlocConsumer<AccountCubit, AccountState>(
            listener: (context, state) {
              var messenger = ScaffoldMessenger.maybeOf(context);
              messenger?.clearSnackBars();
        
              showSnackbar(String content) {
                messenger?.showSnackBar(SnackBar(content: Text(content)));
              }
        
              if (state is AccountUserNameExists) {
                showSnackbar('username already exists');
              }
              if (state is AccountCreateFailed) {
                showSnackbar('Failed to Create Account');
              }
              // if (state is AccountCreated) {
              //   messenger?.showSnackBar(const SnackBar(
              //     content: Text('Account Created'),
              //   ));
                
              // }
            },
            builder: (context, state) {
              if (state is AccountStateLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'username',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: displayNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Full Name',
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 160,
        child: RoundedElevatedTextButton(
          text: 'Create Account',
          onPressed: () => createAccount(context),
        ),
      ),
    );
  }

  void createAccount(BuildContext context) {
    if (usernameController.text.length < 5) return;
    if (displayNameController.text.isEmpty) return;
    final user = XUser(
      username: usernameController.text,
      uid: widget.userUid,
      fullName: displayNameController.text,
    );

    context.read<AccountCubit>().createAccount(user);
  }

  void goToHomePage(BuildContext context) => context.replace(HomePage.path);
}
