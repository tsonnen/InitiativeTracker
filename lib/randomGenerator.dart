import 'dart:math';

int rollDice(int amount, int sides){
  if(amount > 0){
    return Random().nextInt(sides) + rollDice(amount - 1, sides);
  }
  return 0;
}