import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

// ─── Models ───────────────────────────────────────────────────
enum TokenStatus { pending, accepted, rejected }

class TokenRequest {
  final String id;
  final String name;
  final String profession;
  final String familySize;
  final int tokenAmount;
  final String date;
  final TokenStatus status;
  final String imageUrl;

  const TokenRequest({
    required this.id,
    required this.name,
    required this.profession,
    required this.familySize,
    required this.tokenAmount,
    required this.date,
    required this.status,
    required this.imageUrl,
  });
}

class TokenDetail {
  final String fullName;
  final String mobile;
  final String email;
  final String profession;
  final String company;
  final String monthlyIncome;
  final int familyMembers;
  final String maritalStatus;
  final String currentAddress;
  final String idProof;
  final String property;
  final int tokenAmount;
  final String bookingDate;
  final String remarks;
  final bool aadhaarVerified;
  final bool panVerified;
  final String imageUrl;

  const TokenDetail({
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.profession,
    required this.company,
    required this.monthlyIncome,
    required this.familyMembers,
    required this.maritalStatus,
    required this.currentAddress,
    required this.idProof,
    required this.property,
    required this.tokenAmount,
    required this.bookingDate,
    required this.remarks,
    required this.aadhaarVerified,
    required this.panVerified,
    required this.imageUrl,
  });
}

// ─── Providers ────────────────────────────────────────────────
final selectedTabProvider = StateProvider<TokenStatus>(
  (ref) => TokenStatus.pending,
);

final tokenRequestsProvider = Provider<List<TokenRequest>>((ref) {
  return const [
    TokenRequest(
      id: '1',
      name: 'Rahul Sharma',
      profession: 'IT Engineer',
      familySize: 'Family of 4',
      tokenAmount: 5000,
      date: '12 Jun 2026',
      status: TokenStatus.pending,
      imageUrl: '',
    ),
    TokenRequest(
      id: '2',
      name: 'Rahul Sharma',
      profession: 'IT Engineer',
      familySize: 'Family of 4',
      tokenAmount: 5000,
      date: '12 Jun 2026',
      status: TokenStatus.pending,
      imageUrl: '',
    ),
    TokenRequest(
      id: '3',
      name: 'Rahul Sharma',
      profession: 'IT Engineer',
      familySize: 'Family of 4',
      tokenAmount: 5000,
      date: '12 Jun 2026',
      status: TokenStatus.pending,
      imageUrl: '',
    ),
    TokenRequest(
      id: '4',
      name: 'Rahul Sharma',
      profession: 'IT Engineer',
      familySize: 'Family of 4',
      tokenAmount: 5000,
      date: '12 Jun 2026',
      status: TokenStatus.accepted,
      imageUrl: '',
    ),
    TokenRequest(
      id: '5',
      name: 'Rahul Sharma',
      profession: 'IT Engineer',
      familySize: 'Family of 4',
      tokenAmount: 5000,
      date: '12 Jun 2026',
      status: TokenStatus.rejected,
      imageUrl: '',
    ),
  ];
});

final filteredTokensProvider = Provider<List<TokenRequest>>((ref) {
  final tab = ref.watch(selectedTabProvider);
  final all = ref.watch(tokenRequestsProvider);
  return all.where((t) => t.status == tab).toList();
});

final tabCountsProvider = Provider<Map<TokenStatus, int>>((ref) {
  final all = ref.watch(tokenRequestsProvider);
  return {
    TokenStatus.pending: all
        .where((t) => t.status == TokenStatus.pending)
        .length,
    TokenStatus.accepted: all
        .where((t) => t.status == TokenStatus.accepted)
        .length,
    TokenStatus.rejected: all
        .where((t) => t.status == TokenStatus.rejected)
        .length,
  };
});

final selectedTokenDetailProvider = Provider<TokenDetail>((ref) {
  return const TokenDetail(
    fullName: 'Rahul Sharma',
    mobile: '9876543210',
    email: 'rahul.sharma@email.com',
    profession: 'IT Engineer',
    company: 'TCS Pvt. Ltd.',
    monthlyIncome: '₹1,20,000',
    familyMembers: 4,
    maritalStatus: 'Married',
    currentAddress: 'Sector 62, Noida',
    idProof: 'Aadhaar Verified',
    property: 'Skyline Heights – 3 BHK',
    tokenAmount: 5000,
    bookingDate: '12 Jun 2026, 10:30 AM',
    remarks: 'Interested in 3 BHK, Requesting site visit',
    aadhaarVerified: true,
    panVerified: true,
    imageUrl: '',
  );
});

// Decision page action
enum DecisionAction { none, accepted, rejected, needMoreTime }

final decisionActionProvider = StateProvider<DecisionAction>(
  (ref) => DecisionAction.none,
);
