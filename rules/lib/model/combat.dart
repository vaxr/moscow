enum CombatResults {
  AttackerLoss,
  DefenderRetreats,
  DefenderRetreatsLoss,
  DefenderEliminated,
  NoEffect,
  Exchange,
}

const combatResultsTable = {
  1: {
    1: CombatResults.DefenderRetreats,
    2: CombatResults.Exchange,
    3: CombatResults.Exchange,
    4: CombatResults.NoEffect,
    5: CombatResults.NoEffect,
    6: CombatResults.AttackerLoss,
  },
  2: {
    1: CombatResults.DefenderRetreats,
    2: CombatResults.DefenderRetreats,
    3: CombatResults.Exchange,
    4: CombatResults.Exchange,
    5: CombatResults.NoEffect,
    6: CombatResults.NoEffect,
  },
  3: {
    1: CombatResults.DefenderRetreats,
    2: CombatResults.DefenderRetreats,
    3: CombatResults.DefenderRetreats,
    4: CombatResults.Exchange,
    5: CombatResults.Exchange,
    6: CombatResults.DefenderRetreatsLoss,
  },
  4: {
    1: CombatResults.DefenderRetreats,
    2: CombatResults.DefenderRetreats,
    3: CombatResults.Exchange,
    4: CombatResults.DefenderRetreatsLoss,
    5: CombatResults.DefenderRetreatsLoss,
    6: CombatResults.DefenderEliminated,
  },
  5: {
    1: CombatResults.DefenderRetreats,
    2: CombatResults.DefenderRetreatsLoss,
    3: CombatResults.DefenderRetreatsLoss,
    4: CombatResults.DefenderRetreatsLoss,
    5: CombatResults.DefenderRetreats,
    6: CombatResults.DefenderRetreats,
  },
  6: {
    1: CombatResults.DefenderRetreatsLoss,
    2: CombatResults.DefenderRetreatsLoss,
    3: CombatResults.DefenderEliminated,
    4: CombatResults.DefenderEliminated,
    5: CombatResults.DefenderEliminated,
    6: CombatResults.DefenderEliminated,
  },
};
