import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/promoter_score/bloc.dart';
import 'package:hookshot_app/pages/promoter_score/event.dart';
import 'package:hookshot_app/pages/promoter_score/state.dart';
import 'package:hookshot_client/hookshot_client.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class PromoterScorePage extends StatelessWidget {
  const PromoterScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final hookshotClient = context.read<HookshotClient>();
    return BlocProvider(
      create: (context) => PromoterScoreBloc(
        hookshotClient,
      )..add(PromoterScoreStarted()),
      child: const PromoterScoreView(),
    );
  }
}

class PromoterScoreView extends StatelessWidget {
  const PromoterScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromoterScoreBloc, PromoterScoreState>(
      builder: (context, state) => switch (state) {
        PromoterScoreInitial() => _buildInitial(context, state),
        PromoterScoreLoading() => _buildLoading(context, state),
        PromoterScoreSuccess() => _buildSuccess(context, state),
        PromoterScoreFailure() => _buildFailure(context, state),
      },
    );
  }

  Widget _buildInitial(BuildContext context, PromoterScoreInitial state) {
    return const SizedBox();
  }

  Widget _buildLoading(BuildContext context, PromoterScoreLoading state) {
    return const Center(child: Text('Loading'));
  }

  Widget _buildSuccess(BuildContext context, PromoterScoreSuccess state) {
    final promoterScores = state.promoterScores;
    final currentScore = state.currentScore;
    final total = state.total;
    final promoters = state.promoters;
    final passives = state.passives;
    final detractors = state.detractors;
    final rollingScores = state.rollingScores;
    return Column(
      children: [
        _buildSummary(
          context,
          currentScore,
          total,
          promoters,
          passives,
          detractors,
          rollingScores,
        ),
        Container(height: 1, color: Colors.gray50),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) => _buildPromoterScore(
              context,
              promoterScores[index],
            ),
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Colors.gray50,
            ),
            itemCount: promoterScores.length,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(
    BuildContext context,
    int currentScore,
    int total,
    int promoters,
    int passives,
    int detractors,
    List<int> rollingScores,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1024),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radius.medium),
            color: Colors.gray50,
          ),
          padding: const EdgeInsets.all(Spacing.medium),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildScore(context, currentScore),
                const SizedBox(width: Spacing.medium),
                Container(width: 1, color: Colors.gray200),
                const SizedBox(width: Spacing.medium),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCount(context, 'Total', total),
                        const SizedBox(height: Spacing.medium),
                        _buildCount(context, 'Passives', passives),
                      ],
                    ),
                    const SizedBox(width: Spacing.medium),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCount(context, 'Promoters', promoters),
                        const SizedBox(height: Spacing.medium),
                        _buildCount(context, 'Detractors', detractors),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: Spacing.medium),
                Container(width: 1, color: Colors.gray200),
                const SizedBox(width: Spacing.medium),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          for (final score in rollingScores) ...[
                            Expanded(
                              child: Column(
                                children: [
                                  if (score != 200) ...[
                                    Spacer(flex: 200 - score),
                                  ],
                                  Expanded(
                                    flex: score,
                                    child: Container(color: Colors.gray100),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      Container(
                        height: 1,
                        color: Colors.gray200,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScore(BuildContext context, int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current score',
          style: TextStyle(fontSize: FontSize.large),
        ),
        const SizedBox(height: 2),
        Text(
          '$score',
          style: const TextStyle(fontSize: 64),
        ),
      ],
    );
  }

  Widget _buildCount(BuildContext context, String label, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: FontSize.large),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: FontSize.small,
            color: Colors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoterScore(
    BuildContext context,
    PromoterScore promoterScore,
  ) {
    final email = promoterScore.email;
    final question = promoterScore.question;
    final message = promoterScore.message;
    final score = promoterScore.score;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1024),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildQuestionAndMessage(context, question, message),
                  ),
                  const SizedBox(width: Spacing.medium),
                  _buildEmailAndScore(context, email, score),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionAndMessage(
    BuildContext context,
    String question,
    String? message,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(color: Colors.gray500),
        ),
        if (message != null) ...[
          const SizedBox(height: Spacing.small),
          Text(message),
        ],
      ],
    );
  }

  Widget _buildEmailAndScore(BuildContext context, String? email, int? score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          email ?? 'Anonymous',
          style: TextStyle(
            color: Colors.gray500,
            fontStyle: email == null ? FontStyle.italic : null,
          ),
        ),
        if (score != null) ...[
          const SizedBox(height: Spacing.small),
          _buildStars(context, score),
        ],
      ],
    );
  }

  Widget _buildStars(BuildContext context, int stars) {
    return Row(
      children: [
        for (var i = 0; i < stars; i++) ...[
          const Icon(
            Icons.star,
            size: IconSize.small,
            color: Colors.gray500,
          ),
        ],
        for (var i = 0; i < 10 - stars; i++) ...[
          const Icon(
            Icons.star_outline,
            size: IconSize.small,
            color: Colors.gray500,
          ),
        ],
      ],
    );
  }

  Widget _buildFailure(BuildContext context, PromoterScoreFailure state) {
    return Center(child: Text(state.error));
  }
}
