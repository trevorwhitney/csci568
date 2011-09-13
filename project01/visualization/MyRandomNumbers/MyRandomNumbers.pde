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
    
    fill(255,40);
    noStroke();
    
    //draw a line from the google numbers
    for (int i = 0; i < numbers.length; i++) {
      ellipse(numbers[i] * 8, height/2, 8,8);
    }
    
    //draw a line of real numbers for comparison
    for (int i = 0; i < numbers.length; i++) {
      ellipse(ceil(random(0,99)) * 8, height/2 + 20, 8, 8)
    }
}

void draw() {
  //This code happens once every frame.

}

