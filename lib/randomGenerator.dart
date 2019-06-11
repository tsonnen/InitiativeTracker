import 'dart:math';

int rollDice(int amount, int sides){
  if(amount > 0){
    return 1 + Random().nextInt(sides - 1) + rollDice(amount - 1, sides);
  }
  return 0;
}
