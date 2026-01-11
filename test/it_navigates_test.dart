import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_navigates/it_navigates.dart';

void main() {
  group('NavigationExtension Tests', () {
    testWidgets('push navigates to new page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.push(const SecondPage()),
                  child: const Text('Navigate'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.byType(SecondPage), findsOneWidget);
    });

    testWidgets('pop returns to previous page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.push(const SecondPage()),
                  child: const Text('Navigate'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.byType(SecondPage), findsOneWidget);

      final BuildContext context = tester.element(find.byType(SecondPage));
      context.pop();
      await tester.pumpAndSettle();

      expect(find.byType(SecondPage), findsNothing);
    });

    testWidgets('canPop returns correct value', (WidgetTester tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context;
              return const Scaffold(body: Text('Home'));
            },
          ),
        ),
      );

      expect(testContext.canPop(), false);

      testContext.push(const SecondPage());
      await tester.pumpAndSettle();

      final secondContext = tester.element(find.byType(SecondPage));
      expect(secondContext.canPop(), true);
    });

    testWidgets('showSnackBar displays message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.showSnackBar('Test Message'),
                  child: const Text('Show Snackbar'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Snackbar'));
      await tester.pump();

      expect(find.text('Test Message'), findsOneWidget);
    });
  });

  group('NavigationCubit Tests', () {
    testWidgets('NavigationCubit.get returns instance',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => NavigationCubit(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final cubit = NavigationCubit.get(context);
                expect(cubit, isA<NavigationCubit>());
                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        ),
      );
    });

    testWidgets('navigate emits PagePushed state', (WidgetTester tester) async {
      final cubit = NavigationCubit();
      late BuildContext testContext;

      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const Scaffold(body: Text('Home'));
              },
            ),
          ),
        ),
      );

      // Don't await because Navigator.push completes when route is popped
      cubit.navigate(testContext, const SecondPage());
      await tester.pumpAndSettle();

      expect(cubit.state, isA<PagePushed>());
      expect((cubit.state as PagePushed).pageName, SecondPage);
    });

    testWidgets('navigateOff emits PagePushedOff state',
        (WidgetTester tester) async {
      final cubit = NavigationCubit();
      late BuildContext testContext;

      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const Scaffold(body: Text('Home'));
              },
            ),
          ),
        ),
      );

      // Don't await because Navigator.pushAndRemoveUntil completes when route is popped
      cubit.navigateOff(testContext, const SecondPage());
      await tester.pumpAndSettle();

      expect(cubit.state, isA<PagePushedOff>());
      expect((cubit.state as PagePushedOff).pageName, SecondPage);
    });

    testWidgets('pop emits PagePopped state', (WidgetTester tester) async {
      final cubit = NavigationCubit();
      late BuildContext testContext;

      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const Scaffold(body: Text('Home'));
              },
            ),
          ),
        ),
      );

      // Push page without awaiting
      testContext.push(const SecondPage());
      await tester.pumpAndSettle();

      final secondContext = tester.element(find.byType(SecondPage));
      cubit.pop(secondContext);
      await tester.pumpAndSettle();

      expect(cubit.state, isA<PagePopped>());
    });
  });

  group('Global Configuration Tests', () {
    test('initNavigation sets global values', () {
      initNavigation(
        primaryColor: Colors.red,
        guestMode: true,
      );

      expect(appColor, Colors.red);
      expect(isGuestMode, true);

      // Reset for other tests
      initNavigation(
        primaryColor: Colors.blue,
        guestMode: false,
      );
    });

    test('isGuestMode can be toggled', () {
      isGuestMode = true;
      expect(isGuestMode, true);

      isGuestMode = false;
      expect(isGuestMode, false);
    });

    test('appColor can be changed', () {
      appColor = Colors.purple;
      expect(appColor, Colors.purple);

      appColor = Colors.blue;
      expect(appColor, Colors.blue);
    });
  });

  group('Dialog Components Tests', () {
    testWidgets('showChoiceDialog displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => NavigationCubit(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      showChoiceDialog(
                        context: context,
                        title: 'Test Title',
                        content: 'Test Content',
                        onYes: () {},
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('showSuccessDialog displays with icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showSuccessDialog(
                      context,
                      title: 'Success',
                      message: 'Operation completed',
                    );
                  },
                  child: const Text('Show Success'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pumpAndSettle();

      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Operation completed'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('showErrorDialog displays with icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showErrorDialog(
                      context,
                      title: 'Error',
                      message: 'Something went wrong',
                    );
                  },
                  child: const Text('Show Error'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('showLoadingDialog displays progress indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showLoadingDialog(context, message: 'Loading...');
                  },
                  child: const Text('Show Loading'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Navigate Class Tests', () {
    test('Navigate calls callbacks', () {
      bool preCalled = false;
      bool postCalled = false;

      final navigate = Navigate(
        preNavigationCallback: () => preCalled = true,
        postNavigationCallback: () => postCalled = true,
      );

      navigate.init(isGuestMode: false);

      expect(preCalled, true);
      expect(postCalled, true);
    });

    test('preNavigation and postNavigation do not throw', () {
      expect(() => preNavigation(), returnsNormally);
      expect(() => postNavigation(), returnsNormally);
    });
  });

  group('Custom Transitions Tests', () {
    testWidgets('fadeTransition works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.fadeTransition(const SecondPage()),
                  child: const Text('Fade'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Fade'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(FadeTransition).at(1), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SecondPage), findsOneWidget);
    });

    testWidgets('slideTransition works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.slideTransition(const SecondPage()),
                  child: const Text('Slide'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Slide'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(SlideTransition).at(1), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SecondPage), findsOneWidget);
    });

    testWidgets('scaleTransition works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.scaleTransition(const SecondPage()),
                  child: const Text('Scale'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Scale'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(ScaleTransition).at(1), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SecondPage), findsOneWidget);
    });

    testWidgets('rotationTransition works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () =>
                      context.rotationTransition(const SecondPage()),
                  child: const Text('Rotate'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Rotate'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(RotationTransition).at(1), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SecondPage), findsOneWidget);
    });
  });
}

// Helper widget for tests
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Second Page'),
      ),
    );
  }
}
