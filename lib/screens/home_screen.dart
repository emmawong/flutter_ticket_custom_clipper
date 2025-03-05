import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_five_ticket.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_four_ticket.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_one_ticket.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_six_animated_ticket.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_three_ticket.dart';
import 'package:flutter_ticket_custom_clipper/widgets/solution_two_ticket.dart';

/// Home screen to display the different ticket solutions.
class HomeScreen extends StatefulWidget {
  /// Create a HomeScreen widget.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  final _triggerAnimationHints =
      kIsWeb || (!Platform.isAndroid && !Platform.isIOS)
          ? '(Hover to see animation)'
          : '(Tap and hold to see animation)';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build home');
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Custom Clipper')),
      // backgroundColor: Colors.blueGrey.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              '''
Click the floating button at the bottom right corner to increment the counter and see if any unexpected widget rebuilds.
Check the debug console for unexpected rebuild logs. Set debugRepaintRainbowEnabled to true in main.dart to visualize repaint areas.''',
              textAlign: TextAlign.center,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Divider(),
            // TitledItem contains a Text title and a ticket widget wrapped in Center widget.
            // Widget in ListView takes the full width of the list by default.
            // To force the ticket widget to maintain its original size, we need to wrap it in a Center widget.
            const TitledItem(title: 'Solution One', child: SolutionOneTicket()),
            const TitledItem(title: 'Solution Two', child: SolutionTwoTicket()),
            const TitledItem(
              title: 'Solution Three',
              child: SolutionThreeTicket(),
            ),
            const TitledItem(
              title: 'Solution Four',
              child: SolutionFourTicket(),
            ),
            const TitledItem(
              title: 'Solution Five',
              child: SolutionFiveTicket(),
            ),
            TitledItem(
              title: 'Solution Six $_triggerAnimationHints',
              child: const SolutionSixAnimatedTicket(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// A Center aligned widget with title and bottom spacing.
class TitledItem extends StatelessWidget {
  /// Creates a Center aligned widget with title and bottom spacing.
  const TitledItem({required this.title, required this.child, super.key});

  /// The title of the item.
  final String title;

  /// The child of the item.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Widget in ListView takes the full width of the list by default.
    // To force the ticket widget to maintain its original size, we need to wrap it in a Center widget.
    return Center(
      child: Column(
        children: [
          Text(title),
          Center(child: child),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
