bool isNumeric(String s){
  if(s == null) {
    return false;
  }
  return int.parse(s) != null;
}