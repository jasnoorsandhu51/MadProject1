import 'package:flutter/material.dart';
import '../models/dialogue.dart';
import '../widgets/dialogue_overlay.dart';
import 'intro_background_screen.dart';

class DialogueScreen extends StatelessWidget {
  final List<Dialogue> dialogues;
  final String backgroundImage;
  final Widget nextScreen;

  const DialogueScreen({
    super.key,
    required this.dialogues,
    required this.backgroundImage,
    required this.nextScreen,
  });

  @override
  Widget build(BuildContext context) {
    final useIntro = backgroundImage == 'scene0' || backgroundImage.isEmpty;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (useIntro)
            const IntroBackground()
          else ...[
            Image.asset(backgroundImage, fit: BoxFit.cover),
            Container(color: Colors.black.withValues(alpha: 0.5)),
          ],
          DialogueOverlay(
            dialogues: dialogues,
            onComplete: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => nextScreen),
              );
            },
          ),
        ],
      ),
    );
  }
}
