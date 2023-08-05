import 'package:hookshot_client/hookshot_client.dart';

sealed class PromoterScoreState {}

class PromoterScoreInitial extends PromoterScoreState {}

class PromoterScoreLoading extends PromoterScoreState {}

class PromoterScoreSuccess extends PromoterScoreState {
  PromoterScoreSuccess(
    this.promoterScores,
    this.currentScore,
    this.promoters,
    this.passives,
    this.detractors,
  );

  final List<PromoterScore> promoterScores;
  final int currentScore;
  final int promoters;
  final int passives;
  final int detractors;
}

class PromoterScoreFailure extends PromoterScoreState {
  PromoterScoreFailure(this.error);

  final String error;
}
