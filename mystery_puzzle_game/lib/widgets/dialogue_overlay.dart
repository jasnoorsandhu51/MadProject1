import 'dart:async';
import 'package:flutter/material.dart';
import '../models/dialogue.dart';

class DialogueOverlay extends StatefulWidget {
  final List<Dialogue> dialogues;
  final VoidCallback onComplete;

  const DialogueOverlay({
    super.key,
    required this.dialogues,
    required this.onComplete,
  });

  @override
  State<DialogueOverlay> createState() => _DialogueOverlayState();
}

class _DialogueOverlayState extends State<DialogueOverlay> {
  int _index = 0;
  String _displayedText = '';
  bool _isTyping = false;
  Timer? _typeTimer;

  @override
  void initState() {
    super.initState();
    if (widget.dialogues.isNotEmpty) {
      _startTyping();
    }
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    final fullText = widget.dialogues[_index].text;
    _displayedText = '';
    _isTyping = true;
    int charIndex = 0;

    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (charIndex < fullText.length) {
        setState(() {
          charIndex++;
          _displayedText = fullText.substring(0, charIndex);
        });
      } else {
        timer.cancel();
        setState(() => _isTyping = false);
      }
    });
  }

  void _onTap() {
    if (widget.dialogues.isEmpty) {
      widget.onComplete();
      return;
    }

    if (_isTyping) {
      // Show full text immediately
      _typeTimer?.cancel();
      setState(() {
        _displayedText = widget.dialogues[_index].text;
        _isTyping = false;
      });
      return;
    }

    // Advance to next line
    if (_index < widget.dialogues.length - 1) {
      setState(() => _index++);
      _startTyping();
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dialogues.isEmpty) {
      // Auto-complete if no dialogues
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onComplete());
      return const SizedBox.shrink();
    }

    final dialogue = widget.dialogues[_index];
    final screenHeight = MediaQuery.of(context).size.height;
    final panelHeight = screenHeight * 0.38;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Stack(
        children: [
          // Dialogue panel at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: panelHeight,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xF80D1020),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(top: BorderSide(color: Colors.amber, width: 2)),
              ),
              padding: const EdgeInsets.only(
                left: 10,
                right: 20,
                top: 16,
                bottom: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT: Portrait column
                  SizedBox(
                    width: 110,
                    child: Column(
                      children: [
                        // "DET. BEN" label
                        const Text(
                          'DET. BEN',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Portrait box elevated above panel
                        Transform.translate(
                          offset: const Offset(0, -24),
                          child: Container(
                            width: 100,
                            height: 130,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1020),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                dialogue.benImage,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // RIGHT: Dialogue text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detective Ben',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _displayedText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            height: 1.6,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _isTyping ? '...' : 'TAP TO CONTINUE ▶',
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
