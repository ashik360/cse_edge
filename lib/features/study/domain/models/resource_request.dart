class ResourceRequest {
  const ResourceRequest({
    required this.id,
    required this.title,
    required this.authorName,
    required this.createdAtLabel,
    required this.replyCount,
  });

  final String id;
  final String title;
  final String authorName;
  final String createdAtLabel;
  final int replyCount;
}
