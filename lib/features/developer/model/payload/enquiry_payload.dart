class EnquirySubmitPayload {
  final String developerId;
  final String message;

  EnquirySubmitPayload({
    required this.developerId,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'developerId': developerId,
      'message': message,
    };
  }
}