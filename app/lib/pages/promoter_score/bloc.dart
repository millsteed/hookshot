import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/promoter_score/event.dart';
import 'package:hookshot_app/pages/promoter_score/state.dart';
import 'package:hookshot_client/hookshot_client.dart';

class PromoterScoreBloc extends Bloc<PromoterScoreEvent, PromoterScoreState> {
  PromoterScoreBloc(this.hookshotClient) : super(PromoterScoreInitial()) {
    on<PromoterScoreEvent>(
      (event, emit) => switch (event) {
        PromoterScoreStarted() => _handleStarted(event, emit),
      },
    );
  }

  static const _promoters = [9, 10];
  static const _passives = [7, 8];
  static const _detractors = [0, 1, 2, 3, 4, 5, 6];

  final HookshotClient hookshotClient;

  Future<void> _handleStarted(
    PromoterScoreStarted event,
    Emitter<PromoterScoreState> emit,
  ) async {
    emit(PromoterScoreLoading());
    try {
      final promoterScores = await hookshotClient.getAllPromoterScores();
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
        final currentScore = ((promoters - detractors) / total * 100).toInt();
        emit(
          PromoterScoreSuccess(
            promoterScores,
            currentScore,
            promoters,
            passives,
            detractors,
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
}
