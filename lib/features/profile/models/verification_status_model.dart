// verification_status_model.dart

import 'package:gharmb_app/features/profile/models/profile_model.dart';

class VerificationStatusResponse {
  final String? status;
  final String? message;
  final VerificationStatusData? data;

  VerificationStatusResponse({this.status, this.message, this.data});

  factory VerificationStatusResponse.fromJson(Map<String, dynamic> json) {
    return VerificationStatusResponse(
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
      data: json["data"] is Map
          ? VerificationStatusData.fromJson(
              Map<String, dynamic>.from(json["data"]),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class VerificationStatusData {
  final bool isVerified;
  final String verificationStatus;
  final String role;
  final bool hasSubmittedDetails;
  final bool isPending;
  final bool isApproved;
  final bool isRejected;
  final String? rejectionReason;
  final String badge;
  final String message;
  final String actionRequired;
  final bool canPostListings;
  final Map<String, dynamic>? submittedDetails;
  final UserModel? user;

  VerificationStatusData({
    this.isVerified = false,
    this.verificationStatus = 'unverified',
    this.role = '',
    this.hasSubmittedDetails = false,
    this.isPending = false,
    this.isApproved = false,
    this.isRejected = false,
    this.rejectionReason,
    this.badge = '',
    this.message = '',
    this.actionRequired = 'submit_details',
    this.canPostListings = false,
    this.submittedDetails,
    this.user,
  });

  factory VerificationStatusData.fromJson(Map<String, dynamic> json) {
    final status = (json["verificationStatus"] ?? json["status"] ?? 'unverified')
        .toString()
        .toLowerCase()
        .trim();
    final isApproved = json["isApproved"] == true ||
        status == 'approved' ||
        status == 'verified';
    final isPending = json["isPending"] == true ||
        status == 'pending' ||
        status == 'under_review' ||
        status == 'in_review';
    final isRejected = json["isRejected"] == true || status == 'rejected';

    final isVerified = json["isVerified"] == true || isApproved;
    final canPostListings = json["canPostListings"] == true || isVerified;

    UserModel? user;
    if (json["user"] is Map) {
      user = UserModel.fromJson(Map<String, dynamic>.from(json["user"]));
    }

    return VerificationStatusData(
      isVerified: isVerified,
      verificationStatus: status,
      role: json["role"]?.toString() ?? '',
      hasSubmittedDetails: json["hasSubmittedDetails"] as bool? ?? isPending || isApproved,
      isPending: isPending,
      isApproved: isApproved,
      isRejected: isRejected,
      rejectionReason: json["rejectionReason"]?.toString() ??
          (json["submittedDetails"] is Map
              ? (json["submittedDetails"]["agentRejectionReason"] ??
                      json["submittedDetails"]["builderRejectionReason"])
                  ?.toString()
              : null),
      badge: json["badge"]?.toString() ??
          (isApproved
              ? 'Verified'
              : (isPending ? 'Pending Verification' : 'Unverified')),
      message: json["message"]?.toString() ?? '',
      actionRequired: json["actionRequired"]?.toString() ??
          (isPending
              ? 'wait_for_admin_approval'
              : (isApproved ? 'none' : 'submit_details')),
      canPostListings: canPostListings,
      submittedDetails: json["submittedDetails"] is Map
          ? Map<String, dynamic>.from(json["submittedDetails"])
          : null,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isVerified": isVerified,
      "verificationStatus": verificationStatus,
      "role": role,
      "hasSubmittedDetails": hasSubmittedDetails,
      "isPending": isPending,
      "isApproved": isApproved,
      "isRejected": isRejected,
      "rejectionReason": rejectionReason,
      "badge": badge,
      "message": message,
      "actionRequired": actionRequired,
      "canPostListings": canPostListings,
      "submittedDetails": submittedDetails,
      "user": user?.toJson(),
    };
  }
}
