import 'mission_candidate.dart';

/// Represents a mission candidate with its computed planning score.
class ScoredMissionCandidate {
  /// Candidate being scored.
  final MissionCandidate candidate;

  /// Numeric score computed by the priority engine.
  final double score;

  const ScoredMissionCandidate({required this.candidate, required this.score});
}
