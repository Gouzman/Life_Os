enum PlannerRuleType {
  protectFixedEvents,
  preferEnergyMatch,
  balanceLifeAreas,
  keepRecoveryTime,
}

class PlannerRule {
  final PlannerRuleType type;
  final int weight;

  const PlannerRule({required this.type, this.weight = 1});
}
