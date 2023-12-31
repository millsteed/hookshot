import 'package:hookshot_client/hookshot_client.dart';

sealed class PromoterScoreState {}

class PromoterScoreInitial extends PromoterScoreState {}

class PromoterScoreLoading extends PromoterScoreState {}

class PromoterScoreSuccess extends PromoterScoreState {
  PromoterScoreSuccess(
    this.promoterScores,
    this.currentScore,
    this.total,
    this.promoters,
    this.passives,
    this.detractors,
    this.rollingScores,
  );

  final List<PromoterScore> promoterScores;
  final int currentScore;
  final int total;
  final int promoters;
  final int passives;
  final int detractors;
  final List<int> rollingScores;
}

class PromoterScoreFailure extends PromoterScoreState {
  PromoterScoreFailure(this.error);

  final String error;
}
