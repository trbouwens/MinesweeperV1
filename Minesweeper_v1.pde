int n_Side = 18;
int n_Square = (n_Side * n_Side);
int n_Mines = ceil(n_Square / 6.4);
boolean gameOver = false;

Tile[][] field;

void countAdj() {
  
  for (int i = 0; i < n_Side; i++) {
    for (int j = 0; j < n_Side; j++) {
      int count = 0;
      int min = 0;
      int max = (n_Side - 1);
      boolean N = (j > min);
      boolean S = (j < max);
      boolean W = (i > min);
      boolean E = (i < max);
      
      // If we can check North
      if (N) {
        if (field[i][j-1].isBomb()) {
          count++; 
        }
      }
      if (S) {
        if (field[i][j+1].isBomb()) {
          count++; 
        }
      }
      if (W) {
        if (field[i-1][j].isBomb()) {
          count++; 
        }
      }
      if (E) {
        if (field[i+1][j].isBomb()) {
          count++; 
        }
      }
      if (N && W) {
        if (field[i-1][j-1].isBomb()) {
          count++; 
        }
      }
      if (N && E) {
        if (field[i+1][j-1].isBomb()) {
          count++; 
        }
      }
      if (S && W) {
        if (field[i-1][j+1].isBomb()) {
          count++; 
        }
      }
      if (S && E) {
        if (field[i+1][j+1].isBomb()) {
          count++; 
        }
      }
      
      field[i][j].setAdj(count);
    }
  }
}

void set() {
  for (int i = 0; i < n_Side; i++) {
    for (int j = 0; j < n_Side; j++) {
      field[i][j] = new Tile();
    }
  }
}

void setMines() {
  int placed = 0;
  
  while(placed != n_Mines) {
    for (int i = 0; i < n_Side; i++) {
      for (int j = 0; j < n_Side; j++) {
        if (!(placed == n_Mines)) {
          int rand = floor(random(n_Square));
          if (rand == 7 && !(field[i][j].isBomb()) && !(field[i][j].isVisible())) {
            field[i][j].setBomb();
            placed++;
          }
        }
      } 
    }
  }
}

void drawTiles() {
 for (int i = 0, x = 0; x < width && i < n_Side; x += (width / n_Side), i++) {
    for (int j = 0, y = 0; y < height&& j < n_Side; y += (height / n_Side), j++) {
      if (field[i][j].isVisible()) { 
        if (field[i][j].isBomb()) {
          fill(255, 0,0);
          square(x, y, width/n_Side);
        }
        else {
          fill(230, 230, 230);
          square(x, y, width/n_Side);
          
          if (field[i][j].nAdj() != 0) {
            fill(0, 0, 0);
            textAlign(CENTER, CENTER);
            textSize(32);
            text(field[i][j].nAdj(), x+((width/n_Side)/2), y+((width/n_Side)/2)); 
          }
        }
      }
      else if (field[i][j].isWin()) {
        fill(0, 230, 0);
        square(x, y, width/n_Side); 
      }
      else if (field[i][j].isFlagged()) {
        fill(0, 0, 230);
        square(x, y, width/n_Side); 
      }
      else if (field[i][j].isHovered()) {
        fill(121, 121, 121);
        square(x, y, width/n_Side);
        field[i][j].unhover();
      }
      else {
        fill(131, 131, 131);
        square(x, y, width/n_Side);
      }
    }
  } 
}

// Draws the tiles with all tile visible, bombs and spaces alike
void drawTiles_test() {
 for (int i = 0, x = 0; x < width && i < n_Side; x += (width / n_Side), i++) {
    for (int j = 0, y = 0; y < height && j < n_Side; y += (height / n_Side), j++) {
      if (field[i][j].isBomb()) {
        fill(255, 0,0);
        square(x, y, width/n_Side);
      }
      else {
        fill(230, 230, 230);
        square(x, y, width/n_Side);
        
          if (field[i][j].nAdj() != 0) {
            fill(0, 0, 0);
            textAlign(CENTER, CENTER);
            textSize(32);
            text(field[i][j].nAdj(), x+((width/n_Side)/2), y+((width/n_Side)/2)); 
          }
      }
    }
  } 
}

void mouse() {
  float div = (width / n_Side);
  
  int mX = floor((mouseX/div));
  int mY = floor((mouseY/div));
  
  if (!(field[mX][mY].isHovered())) {
    field[mX][mY].hover();
  }
  
  if (mousePressed && mouseButton == LEFT) {
    if (field[mX][mY].isBomb() && !(field[mX][mY].isFlagged())) {
      gameOver();
    }
    else if (field[mX][mY].nAdj() == 0) {
      field[mX][mY].revealTile();
      emptyTile(mX, mY);
    }
    else {
      field[mX][mY].revealTile();
    }
  }
  
  if (mousePressed && mouseButton == RIGHT) {
    if (!field[mX][mY].isVisible()) {
      field[mX][mY].flag(); 
    }
  }
}

void gameOver() {
  for (int i = 0; i < n_Side; i++) {
    for (int j = 0; j < n_Side; j++) {
      if (field[i][j].isBomb()) {
        field[i][j].revealTile();
      }
    }
  }
  
  gameOver = true;
}
 //<>//
void emptyTile(int i, int j) {
  int min = 0; //<>//
  int max = (n_Side - 1); //<>//
  boolean N = (j > min);
  boolean S = (j < max);
  boolean W = (i > min);
  boolean E = (i < max); //<>// //<>//
  
  field[i][j].revealTile();
  
  if (N) { //<>//
    if (field[i][j-1].nAdj() == 0 && !field[i][j-1].isVisible()) {
      emptyTile(i, j-1);
    } //<>//
    field[i][j-1].revealTile();
  }
  
  if (S) {
    if (field[i][j+1].nAdj() == 0 && !field[i][j+1].isVisible()) {
      emptyTile(i, j+1);
    }
    field[i][j+1].revealTile();
  }
  
  if (W) {
    if (field[i-1][j].nAdj() == 0 && !field[i-1][j].isVisible()) {
      emptyTile(i-1, j);
    }
    field[i-1][j].revealTile();
  }
  
  if (E) {
    if (field[i+1][j].nAdj() == 0 && !field[i+1][j].isVisible()) {
      emptyTile(i+1, j);
    }
    field[i+1][j].revealTile();
  }
  
  if (N && W) {
    if (field[i-1][j-1].nAdj() == 0 && !field[i-1][j-1].isVisible()) {
      emptyTile(i-1, j-1);
    }
    field[i-1][j-1].revealTile();
  }
  
  if (N && E) {
    if (field[i+1][j-1].nAdj() == 0 && !field[i+1][j-1].isVisible()) {
      emptyTile(i+1, j-1);
    }
    field[i+1][j-1].revealTile();
  }
  
  if (S && W) {
    if (field[i-1][j+1].nAdj() == 0 && !field[i-1][j+1].isVisible()) {
      emptyTile(i-1, j+1);
    }
    field[i-1][j+1].revealTile();
  }
  
  if (S && E) {
    if (field[i+1][j+1].nAdj() == 0 && !field[i+1][j+1].isVisible()) {
      emptyTile(i+1, j+1);
    }
    field[i+1][j+1].revealTile();
  }
  
}

void gameWon() {
  int nHits = 0;
  
  for (int i = 0; i < n_Side; i++) {
    for (int j = 0; j < n_Side; j++) {
      if (field[i][j].isBomb() && field[i][j].isFlagged()) {
        nHits++;
      }
    }
  }
  
  if (nHits == n_Mines) {
    for (int i = 0; i < n_Side; i++) {
      for (int j = 0; j < n_Side; j++) {
        if (field[i][j].isFlagged()) {
          field[i][j].setWon();
        }
      }
    }
    gameOver = true;
  }
}

void setup() {
  size(900, 900);
  print(n_Mines);
  
  field = new Tile[n_Side][n_Side];
  
  set();
  setMines();
  countAdj();
}

void draw() {
  background(0);
  drawTiles();
  mouse();
  //drawTiles_test();
  gameWon();
  drawTiles();
  
  if (gameOver) {
    noLoop();
  }
  
  
}

class Tile {
  private int adj;
  private boolean bomb;
  private boolean visible;
  private boolean flagged;
  private boolean hovered;
  private boolean won;

  public Tile() {
    adj = 0;
    bomb = false;
    visible = false;
    flagged = false;
  }
  
  // Returns how many adjacent bombs
  int nAdj() {
    return adj;
  }

  // Checks if tile is bomb
  boolean isBomb() {
    return bomb;
  }

  // Checks if tile is visible to player
  boolean isVisible() {
    return visible;
  }

  // Checks if player has flagged tile
  boolean isFlagged() {
    return flagged;
  }
  
  boolean isHovered() {
    return hovered;
  }
  
  boolean isWin() {
    return won;
  }

  // Sets adjacent bombs to be a given value
  void setAdj(int x) {
    adj = x;
  }
  
  // Sets a tile to have a mine
  void setBomb() {
    bomb = true;
    adj = 0;
  }

  // Reveals a tile to the user
  void revealTile() {
    visible = true;
    flagged = false;
    hovered = false;
  }

  // Toggles the flag status of a tile
  void flag() {
    flagged = !flagged;
  }
  
  void hover() {
    hovered = true;
  }
  
  void unhover() {
    hovered = false;
  }
  
  void setWon() {
    won = true;
  }
}
