class RevisionItem {
  const RevisionItem({
    required this.title,
    required this.content,
    required this.importanceTag, // e.g., "Must Read", "Repeated 5x"
  });

  final String title;
  final String content;
  final String importanceTag;
}

class RevisionPack {
  const RevisionPack({
    required this.courseCode,
    required this.formulas,
    required this.probableQuestions,
    required this.summaries,
  });

  final String courseCode;
  final List<RevisionItem> formulas;
  final List<RevisionItem> probableQuestions;
  final List<RevisionItem> summaries;
}