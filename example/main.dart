import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_navigates/it_navigates.dart';

void main() {
  // Initialize the navigation package with custom configuration
  initNavigation(
    primaryColor: Colors.deepPurple,
    guestMode: false,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: MaterialApp(
        title: 'it_navigates Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('it_navigates Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Navigation Methods',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            'Basic Navigation',
            [
              _buildButton(
                context,
                'Push (Standard)',
                () => context.push(const DetailPage(title: 'Pushed Page')),
              ),
              _buildButton(
                context,
                'Push Replacement',
                () => context.pushReplacement(
                    const DetailPage(title: 'Replacement Page')),
              ),
              _buildButton(
                context,
                'Push and Remove Until',
                () => context
                    .pushAndRemoveUntil(const DetailPage(title: 'Fresh Start')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            'Custom Transitions',
            [
              _buildButton(
                context,
                'Fade Transition',
                () =>
                    context.fadeTransition(const DetailPage(title: 'Fade In')),
              ),
              _buildButton(
                context,
                'Slide Transition',
                () => context
                    .slideTransition(const DetailPage(title: 'Slide In')),
              ),
              _buildButton(
                context,
                'Scale Transition',
                () => context
                    .scaleTransition(const DetailPage(title: 'Scale In')),
              ),
              _buildButton(
                context,
                'Rotation Transition',
                () => context
                    .rotationTransition(const DetailPage(title: 'Rotate In')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            'Dialogs & Messages',
            [
              _buildButton(
                context,
                'Choice Dialog',
                () => showChoiceDialog(
                  context: context,
                  title: 'Confirm Action',
                  content: 'Are you sure you want to proceed?',
                  onYes: () {
                    context.showSnackBar('Confirmed!');
                  },
                  onNo: () {
                    context.showSnackBar('Cancelled');
                  },
                ),
              ),
              _buildButton(
                context,
                'Success Dialog',
                () => showSuccessDialog(
                  context,
                  title: 'Success!',
                  message: 'Your operation completed successfully.',
                ),
              ),
              _buildButton(
                context,
                'Error Dialog',
                () => showErrorDialog(
                  context,
                  title: 'Error',
                  message: 'Something went wrong. Please try again.',
                ),
              ),
              _buildButton(
                context,
                'Loading Dialog',
                () {
                  showLoadingDialog(context, message: 'Processing...');
                  Future.delayed(const Duration(seconds: 2), () {
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    context.showSnackBar('Loading completed!');
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            'Bottom Sheets & Snackbars',
            [
              _buildButton(
                context,
                'Show Bottom Sheet',
                () => context.showBottomSheet(
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Bottom Sheet',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const Text('This is a custom bottom sheet!'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildButton(
                context,
                'Show Snackbar',
                () => context.showSnackBar(
                  'This is a snackbar message!',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            'NavigationCubit Examples',
            [
              _buildButton(
                context,
                'Navigate with Cubit',
                () async {
                  final navCubit = NavigationCubit.get(context);
                  await navCubit.navigate(
                      context, const DetailPage(title: 'Via Cubit'));
                },
              ),
              _buildButton(
                context,
                'Toggle Guest Mode',
                () {
                  isGuestMode = !isGuestMode;
                  context.showSnackBar(
                    'Guest Mode: ${isGuestMode ? 'ON' : 'OFF'}',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;

  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This page was navigated to using it_navigates!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  context.push(const DetailPage(title: 'Nested Page')),
              icon: const Icon(Icons.add),
              label: const Text('Navigate Again'),
            ),
          ],
        ),
      ),
    );
  }
}
