import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/promoter_score/event.dart';
import 'package:hookshot_app/pages/promoter_score/state.dart';
import 'package:hookshot_app/repositories/promoter_score_repository.dart';
import 'package:hookshot_client/hookshot_client.dart';

class PromoterScoreBloc extends Bloc<PromoterScoreEvent, PromoterScoreState> {
  PromoterScoreBloc(this.promoterScoreRepository, this.projectId)
      : super(PromoterScoreInitial()) {
    on<PromoterScoreEvent>(
      (event, emit) => switch (event) {
        PromoterScoreStarted() => _handleStarted(event, emit),
      },
    );
  }

  static const _promoters = [9, 10];
  static const _passives = [7, 8];
  static const _detractors = [0, 1, 2, 3, 4, 5, 6];

  final PromoterScoreRepository promoterScoreRepository;
  final String projectId;

  Future<void> _handleStarted(
    PromoterScoreStarted event,
    Emitter<PromoterScoreState> emit,
  ) async {
    emit(PromoterScoreLoading());
    try {
      final response = await promoterScoreRepository.getPromoterScores(
        projectId: projectId,
      );
      final promoterScores = response.promoterScores;
      if (promoterScores.isNotEmpty) {
        final total = promoterScores
            .map((promoterScore) => promoterScore.score)
            .whereType<int>()
            .length;
        final promoters = promoterScores
            .map((promoterScores) => promoterScores.score)
            .where(_promoters.contains)
            .length;
        final passives = promoterScores
            .map((promoterScores) => promoterScores.score)
            .where(_passives.contains)
            .length;
        final detractors = promoterScores
            .map((promoterScores) => promoterScores.score)
            .where(_detractors.contains)
            .length;
        final currentScore =
            total == 0 ? 0 : ((promoters - detractors) / total * 100).toInt();
        final rollingScores = _calculateRollingScores(promoterScores);
        emit(
          PromoterScoreSuccess(
            promoterScores,
            currentScore,
            total,
            promoters,
            passives,
            detractors,
            rollingScores,
          ),
        );
      } else {
        emit(PromoterScoreFailure('No promoter score yet. Check back soon.'));
      }
    } on HookshotClientException catch (e) {
      emit(PromoterScoreFailure(e.message));
    } on Exception {
      emit(PromoterScoreFailure('Something unexpected happened.'));
    }
  }

  List<int> _calculateRollingScores(List<PromoterScore> promoterScores) {
    final rollingScores = <int>[];
    var total = 0;
    var promoters = 0;
    var detractors = 0;
    for (final promoterScore in promoterScores.reversed) {
      final score = promoterScore.score;
      if (score == null) {
        continue;
      }
      total++;
      if (_promoters.contains(score)) {
        promoters++;
      } else if (_detractors.contains(score)) {
        detractors++;
      }
      rollingScores.add(((promoters - detractors) / total * 100 + 100).toInt());
    }
    return rollingScores;
  }
}
