function calcScores(scores) {
  let counterScoreMax = 0;
  let counterScoreMin = 0;

  let scoreMax = null;
  let scoreMin = null;

  for (let i = 0; i < scores.length; i++) {
    const currentScore = scores[i];

    if (scoreMax === null || scoreMin === null) {
      scoreMax = currentScore;
      scoreMin = currentScore;
    } else {
      if (currentScore > scoreMax) {
        scoreMax = currentScore;
        counterScoreMax ++;
      }
      if (currentScore < scoreMin) {
        scoreMin = currentScore
        counterScoreMin ++;
      }
    }
  }

  return [counterScoreMax, counterScoreMin];
}

console.log(calcScores([10, 15, 10, 20, 8, 5, 25, 0, 20, 10]));