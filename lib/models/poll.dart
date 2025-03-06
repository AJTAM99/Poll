class Poll {
  String question;
  List<String> options;
  List<int> votes;

  Poll({required this.question, required this.options})
      : votes = List.filled(options.length, 0);

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      question: json['question'],
      options: List<String>.from(json['options']),
    )..votes = List<int>.from(json['votes']);
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'votes': votes,
    };
  }
}
