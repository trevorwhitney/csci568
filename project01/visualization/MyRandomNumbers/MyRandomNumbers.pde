/*
 #myrandomnumber Tutorial
 blprnt@blprnt.com
 April, 2010
 */

//This is the Google spreadsheet manager and the id of the spreadsheet that we want to populate, along with our Google username & password
SimpleSpreadsheetManager sm;
String sUrl = "t6mq_WLV5c5uj6mUNSryBIA";
String googleUser = GUSER;
String googlePass = GPASS;
  
void setup() {
    //This code happens once, right when our sketch is launched
    size(800,800);
    background(0);
    smooth();
    
    //Ask for a list of number
    int[] numbers = getNumbers();
    
    //Draw that graph!
    barGraph(numbers, 100);
    
    //Draw lots of graphs
    for(int i = 1; i < 7; i++) {
      int[] randomNumbers = getRandomNumbers(225);
      barGraph(randomNumbers, 100 + (i * 130));
    }
    
    //Backwards down the numberline
    /*
    fill(255,40);
    noStroke();
    
    //draw a line from the google numbers
    for (int i = 0; i < numbers.length; i++) {
      ellipse(numbers[i] * 8, height/2, 8,8);
    }
    
    //draw a line of real numbers for comparison
    for (int i = 0; i < numbers.length; i++) {
      ellipse(ceil(random(0,99)) * 8, height/2 + 20, 8, 8);
    }
    */
    
    
}

/*  This function will draw a bar graph representing the frequency of
*   each number 0-99 in our set
*   @param nums an array of numbers
*/
void barGraph( int[] nums, float y ) {
  //Make a list of number counts
  int[] counts = new int[100];
  //Fill it with zeros
  for (int i = 0; i < counts.length; i++) {
    counts[i] = 0;
  }
  //Tally the counts
  for (int i = 0; i < nums.length; i++) {
    counts[nums[i]] ++;
  }
  
  //Draw the pretty bar graph
  for (int i = 0; i < counts.length; i++) {
    colorMode(HSB);
    fill(counts[i] * 30, 255, 255);
    rect(i * 8, y, 8, -counts[i] * 10);
  }
}
  

void draw() {
  //This code happens once every frame.

}

