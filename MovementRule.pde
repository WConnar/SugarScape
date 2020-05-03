import java.util.LinkedList;
import java.util.Collections;

interface MovementRule {
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle);
}

class SugarSeekingMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public SugarSeekingMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    for (Square s : neighborhood) {
      if (s.getSugar() > retval.getSugar() ||
          (s.getSugar() == retval.getSugar() && 
           g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle)
          )
         ) {
        retval = s;
      } 
    }
    return retval;
  }
}

class PollutionMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public PollutionMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    boolean bestSquareHasNoPollution = (retval.getPollution() == 0);
    for (Square s : neighborhood) {
      boolean newSquareCloser = (g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle));
      if (s.getPollution() == 0) {
        if (!bestSquareHasNoPollution || s.getSugar() > retval.getSugar() ||
            (s.getSugar() == retval.getSugar() && newSquareCloser)
           ) {
          retval = s;
        }
      }
      else if (!bestSquareHasNoPollution) { 
        float newRatio = s.getSugar()*1.0/s.getPollution();
        float curRatio = retval.getSugar()*1.0/retval.getPollution();
        if (newRatio > curRatio || (newRatio == curRatio && newSquareCloser)) {
          retval = s;
        }
      }
    }
    return retval;
  }
}

class CombatMovementRule extends SugarSeekingMovementRule{
  int alpha;
  
  public CombatMovementRule(int alpha){
    this.alpha = alpha;
  }
  
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle){
    for(int i = 0; i < neighbourhood.size(); i++){
      if(neighbourhood.get(i).getAgent().getTribe() == middle.getAgent().getTribe()){
       neighbourhood.remove(i);
      }
      if(neighbourhood.get(i).getAgent().getSugarLevel() >= middle.getAgent().getSugarLevel()){
        neighbourhood.remove(i);
      }
    }
    for(int i = 0; i < neighbourhood.size(); i++){
      if(neighbourhood.get(i) != null){
       LinkedList<Square> killSight = g.generateVision(neighbourhood.get(i).getX(), neighbourhood.get(i).getY(), middle.getAgent().getVision());
       for(int j = 0; j < killSight.size(); j++){
        if(killSight.get(i).getAgent().getSugarLevel() >= middle.getAgent().getSugarLevel() && killSight.get(i).getAgent().getTribe() != middle.getAgent().getTribe()){
          neighbourhood.remove(i);
        }
       }
      }
    }
    for(int i = 0; i < neighbourhood.size(); i++){
      if(neighbourhood.get(i) != null){
        int tempX = neighbourhood.get(i).getX();
        int tempY = neighbourhood.get(i).getY();
        int tempSL = neighbourhood.get(i).getSugar();
        int tempMaxSL = neighbourhood.get(i).getMaxSugar();
        
        // I wasn't sure if "occupying agent" in #4 of Q4 meant the agent already there, or the attacking agent. This adds the sugar of the attacking agent as well.
        neighbourhood.set(i, new Square((tempSL + alpha + middle.getAgent().getSugarLevel()), (tempMaxSL + alpha + middle.getAgent().getSugarLevel()), tempX, tempY));
      }
    }
      Square target = super.move(neighbourhood, g, middle);
      if(target.getAgent() == null) return target;
      else{
        Agent casualty = target.getAgent();
        target.setAgent(null);
        middle.sugarLevel += (casualty.sugarLevel + alpha);
        g.killAgent(casualty);
        return target;
      }
    
  }
  
}

class SugarSeekingMovementRuleTester {
  public void test() {
    SugarSeekingMovementRule mr = new SugarSeekingMovementRule();
    //stubbed
  }
}

class PollutionMovementRuleTester {
  public void test() {
    PollutionMovementRule mr = new PollutionMovementRule();
    //stubbed
  }
}
