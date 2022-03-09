import de.bezier.guido.*;

public final static int NUM_ROWS = 3;
public final static int NUM_COLS = 3;
public final static int NUM_MINES = 2;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
public int nonMineClicked=0;
void setup ()
{
    size(800, 800);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0;r<NUM_ROWS;r++){
      for(int c=0;c<NUM_COLS;c++)
        buttons[r][c]= new MSButton(r,c);
    }
    mines = new ArrayList<MSButton>();
    setMines();
}
public void setMines()
{
    while(mines.size()<NUM_MINES){
    int r=(int)(Math.random()*NUM_ROWS);
    int c=(int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[r][c])){
      mines.add(buttons[r][c]);
      System.out.println(r+", "+c);}
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r=0;r<NUM_ROWS;r++)
      for(int c=0;c<NUM_COLS;c++){
       if(mines.contains(buttons[r][c])&&buttons[r][c].clicked==true)return false;
       if(nonMineClicked<(NUM_ROWS*NUM_COLS)-NUM_MINES)return false;
      }
    return true;
}
public void displayLosingMessage()
{
    System.out.println("YOU LOST");
}
public void displayWinningMessage()
{
    System.out.println("YOU WON");
}
public boolean isValid(int r, int c)
{
    
    return r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1;r<=row+1;r++)
      for(int c = col-1; c<=col+1;c++)
        if(isValid(r,c) && mines.contains(buttons[r][c]))
          numMines++;
    if(isValid(row,col) && mines.contains(buttons[row][col])) 
      numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(!mines.contains(this))nonMineClicked++;
        if(mouseButton==RIGHT){
          flagged=!flagged;
          if (flagged==false) 
            clicked=false;
        }else if(mines.contains(this)){
          displayLosingMessage();
        }else if(countMines(this.myRow,this.myCol)>0){
          this.setLabel(Integer.toString(countMines(this.myRow,this.myCol)));
        }else{
          for(int r=this.myRow-1;r<=this.myRow+1;r++)
            for(int c=this.myCol-1;c<=this.myCol+1;c++)
              if(isValid(r,c)==true && buttons[r][c].clicked==false)
                buttons[r][c].mousePressed();
        }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
