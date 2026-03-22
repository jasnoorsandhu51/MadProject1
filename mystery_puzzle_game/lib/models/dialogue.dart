class Dialogue {
  final String text;
  final String benImage;
  final bool isLastLine;

  const Dialogue({
    required this.text,
    required this.benImage,
    this.isLastLine = false,
  });
}

class DialogueScript {
  DialogueScript._();

  static const List<Dialogue> openingScene = [
    Dialogue(
      text:
          "We've got broken glass everywhere. Whoever did this left in a hurry.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(
      text:
          "I've already been to the crime scene, but I need you to help me investigate further.",
      benImage: "assets/images/ben_think.png",
    ),
    Dialogue(
      text: "Let's head inside. The exhibition room is where it all started.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(
      text:
          "You try to look for any clues around the room. I'll go check the security footage.",
      benImage: "assets/images/ben_talk.png",
      isLastLine: true,
    ),
  ];

  static const List<Dialogue> afterLevel1 = [
    Dialogue(
      text: "I see you found those clues. Good job, partner.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(
      text:
          "Here's what I found from the CCTV footage. We had over 50 visitors on the day of the robbery.",
      benImage: "assets/images/ben_think.png",
    ),
    Dialogue(
      text:
          "But here's what caught my attention. I examined the lock on the exhibition room door.",
      benImage: "assets/images/ben_think.png",
    ),
    Dialogue(
      text:
          "No scratch marks. No signs of lockpicking whatsoever. That lockpick you found was planted.",
      benImage: "assets/images/ben_crossedarms.png",
    ),
    Dialogue(
      text:
          "Whoever did this already had a key. We're either dealing with an insider, or someone very, very smart.",
      benImage: "assets/images/ben_think.png",
    ),
    Dialogue(
      text:
          "Head outside and investigate the perimeter of the building. I'll stay here and start shortlisting suspects.",
      benImage: "assets/images/ben_talk.png",
      isLastLine: true,
    ),
  ];

  static const List<Dialogue> afterLevel2 = [
    Dialogue(
      text:
          "Okay. After going through the full CCTV logs, I've narrowed it down to three people with key access to that room.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(
      text:
          "William, the gardener. Stacy, the exhibition maid. And Stephen, the painting broker.",
      benImage: "assets/images/ben_think.png",
    ),
    Dialogue(
      text:
          "Now this is interesting. That wallet you found — it belongs to William the gardener.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(
      text: "Hmm. Let me think for a second.",
      benImage: "assets/images/ben_think.png",
    ),
    Dialogue(
      text:
          "No. Someone this careful wouldn't just drop their wallet at the scene. That's too convenient.",
      benImage: "assets/images/ben_crossedarms.png",
    ),
    Dialogue(
      text:
          "Something isn't adding up. I'm going to pull William in for questioning.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(
      text:
          "While I do that, you go check the staff quarters. Investigate the other two suspects.",
      benImage: "assets/images/ben_talk.png",
      isLastLine: true,
    ),
  ];

  static const List<Dialogue> closingScene = [
    Dialogue(
      text: "Ah! A journal of some sort. Let me see that.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(text: "...", benImage: "assets/images/ben_think.png"),
    Dialogue(
      text:
          "This explains everything. Entry times, decoy placements, even a note about finding William's wallet.",
      benImage: "assets/images/ben_crossedarms.png",
    ),
    Dialogue(
      text:
          " I was the maid. She wrote it all down. She found William's wallet two days before the heist and saw her opportunity.",
      benImage: "assets/images/ben_think.png",
    ),
    Dialogue(
      text:
          "Also after interrogating William i found out his shoe size is a 12. Those footprints outside were a size 7.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(
      text:
          " A complete mismatch! Poor guy was about to get framed. Not on our watch.",
      benImage: "assets/images/ben_talk.png",
    ),
    Dialogue(
      text: "Great find, partner. It's Stacy. Case solved.",
      benImage: "assets/images/ben_crossedarms.png",
      isLastLine: true,
    ),
  ];
}
