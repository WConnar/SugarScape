import java.util.Collections;
import java.util.Random;
import java.util.List;

class FertilityRule {
  int startFertileF;
  int endFertileF;
  int startFertileM;
  int endFertileM;
  
  int startClimF;
  int endClimF;
  int startClimM;
  int endClimM;
  
  private Random r = new Random();
  LinkedList<Agent> fa = new LinkedList<Agent>();
  HashMap<Agent, Integer[]> agentFertility;

  public FertilityRule(HashMap<Character, Integer[]> childbearingOnset, HashMap<Character, Integer[]> climactericOnset) {
    this.startFertileF = childbearingOnset.get('X')[0];
    this.startFertileM = childbearingOnset.get('Y')[0];
    this.endFertileF = childbearingOnset.get('X')[1];
    this.endFertileM = childbearingOnset.get('Y')[1];
    
    this.startClimF = climactericOnset.get('X')[0];
    this.startClimM = climactericOnset.get('Y')[0];
    this.endClimF = climactericOnset.get('X')[1];
    this.endClimM = climactericOnset.get('Y')[1];
  }
  
  public boolean isFertile(Agent a){
   int c = 0;
   int o = 0;
   int sug = a.getSugarLevel();
   if(a == null || a.isAlive() == false) return false;
   if(!fa.contains(a)){
     c = r.nextInt();
     o = r.nextInt();
     if(a.sex == 'X'){
      while(!(c >= startFertileF) && !(c <= endFertileF)){
        c = r.nextInt();
      }
      while(!(o >= startClimF) && !(o <= endClimF)){
        o = r.nextInt();
      }
     }
     if(a.sex == 'Y'){
      while(!(c >= startFertileM) && !(c <= endFertileM)){
        c = r.nextInt();
      }
      while(!(o >= startClimM) && !(o <= endClimM)){
        o = r.nextInt();
      }
     }
     Integer[] fert = new Integer[]{c,o};
     agentFertility.put(a,fert);
     fa.add(a);
   }
   if(c <= a.getAge() && a.getAge() < o && a.getSugarLevel() >= sug){
     return true;
   }
   else{ return false;
   }
  }
  
  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local){
    boolean hasEmpty = false;
    for(int i = 0; i < local.size(); i++){
      if(local.get(i).getAgent() == null){
        hasEmpty = true;
      }
    if(isFertile(a) && isFertile(b) && a.getSex() != b.getSex() && local.contains(b.getSquare()) && hasEmpty == true){
      return true;
    }
  }
  return false;
 }
 
 public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal){
   if(canBreed(a,b,aLocal)){
    int pip = r.nextInt();
    int pop = r.nextInt();
    int pup = r.nextInt();
    int pep = r.nextInt();
    int sl;
    Square sq;
    int met;
    int vis;
    MovementRule mr = a.getMovementRule();
    char sex;
    
    if(pep % 2 == 0){
      sl = 0;
    }
    else{
      sl = 1;
    }
    if(sl == 0){
      int s = r.nextInt(aLocal.size());
      sq = aLocal.get(s);
    }
    else{
      int s = r.nextInt(bLocal.size());
      sq = bLocal.get(s);
    }
    
    if(pup % 2 == 0){
      sex = 'X';
    }
    else{
      sex = 'Y';
    }
    if(pip % 2 == 0){
      met = a.getMetabolism();
    }
    else{
      met = b.getMetabolism();
    }
    if(pop % 2 == 0){
      vis = a.getVision();
    }
    else{
      vis = b.getVision();
    }
    
    Agent child = new Agent(met, vis, 0, mr, sex);
    a.gift(child, a.getSugarLevel()/2);
    b.gift(child, b.getSugarLevel()/2);
    
    child.nurture(a, b);
    child.setSquare(sq);
    
    return child;
   }
   else{
     return null;
   }
 }
 
 
}
