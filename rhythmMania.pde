import processing.sound.*;

// Final Project 1
// global variables
int gameState = 0; // 0: Menu, 1: HowToPlay, 2: Easy, 3: Hard
Game currentGame;
int finalScore = 0; // Stores the score to show on the end screen
// TODO: insert media into data folder
// PImage mikuDance, bgImage, noteIcon;
// SoundFile easySong, hardSong, hitSound, clickSound;
PImage bgMain, bgEasy, bgHard, mikuImg;
SoundFile sfxPerfect, sfxPop, bgmMenu, songEasy, songHard;

// SETUP
void setup() {
  size(800, 600);
  
  
  // TODO: Load images and sounds here
  // mikuDance = loadImage("miku.png");
  // hitSound = new SoundFile(this, "perfect_hit.wav");
  // --- Load Images ---
  bgMain = loadImage("background.jpg");
  bgEasy = loadImage("ez_mode_background.jpg");
  // NOTE: Converted from webp to jpg for Processing compatibility
  bgHard = loadImage("hard_mode_background.jpg"); 
  mikuImg = loadImage("hatsune-miku.png");
  
  // --- Load Audio ---
  sfxPerfect = new SoundFile(this, "perfect.mp3");
  sfxPop = new SoundFile(this, "pop.wav");
  bgmMenu = new SoundFile(this, "Perfume cut.mp3");
  songEasy = new SoundFile(this, "Replay cut.mp3");
  songHard = new SoundFile(this, "True Romance cut.mp3");
  
  // Start menu music on loop right away
  bgmMenu.loop();
}

// main screen for navigation
void draw() {
  
  if (gameState == 0) {
    // menu
    image(bgMain, 0, 0, width, height);
    menu();
  } else if (gameState == 1) {
    image(bgMain, 0, 0, width, height);
    // how to play
    userManual();
  } else if (gameState == 2) {
    tint(80); 
    image(bgEasy, 0, 0, width, height);
    noTint(); 
    currentGame.game(); 
  } else if (gameState == 3) {
    tint(80); 
    image(bgHard, 0, 0, width, height);
    noTint(); 
    currentGame.game(); 
  } else if (gameState == 4) {
    image(bgMain, 0, 0, width, height); // Show menu background
    gameOverScreen(); // Show results
  }
}

// USER INTERFACE
// text + buttons to help navigate to different screens
void menu() {
  // Skeleton UI: Display title and buttons
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(40);
  text("RHYTHM MANIA", width/2, height/2 - 50);
  
  textSize(20);
  text("Press 'E' for Easy Mode (100 BPM)", width/2, height/2 + 20);
  text("Press 'H' for Hard Mode (160 BPM)", width/2, height/2 + 50);
  text("Press 'M' for User Manual", width/2, height/2 + 80);
  text("Press 'Q' to Quit", width/2, height/2 + 110);
  
  if (mikuImg != null) {
    image(mikuImg, width - 200, height - 200, 150, 150); 
  }
}

// text display + iages for how to play the game
void userManual() {
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(32);
  text("HOW TO PLAY", width/2, height/2 - 50);
  
  textSize(20);
  text("Notes will scroll from right to left.", width/2, height/2 + 10);
  text("Press the matching arrow key when the note hits the gold ring!", width/2, height/2 + 40);
  
  fill(255, 255, 0);
  text("Press 'B' to return to Menu", width/2, height/2 + 100);
}

// game over screen
void gameOverScreen() {
  textAlign(CENTER, CENTER);
  
  float titleY = height/2 - 60;
  float scoreY = height/2 + 10;
  String titleText = "SONG COMPLETE!";
  String scoreText = "Final Score: " + finalScore;
  
  // --- Title Text with Outline ---
  textSize(50);
  fill(0); // Black outline
  text(titleText, width/2 - 3, titleY);
  text(titleText, width/2 + 3, titleY);
  text(titleText, width/2, titleY - 3);
  text(titleText, width/2, titleY + 3);
  
  fill(255); // White main text
  text(titleText, width/2, titleY);
  
  // --- Score Text with Outline ---
  textSize(40);
  fill(0); // Black outline
  text(scoreText, width/2 - 3, scoreY);
  text(scoreText, width/2 + 3, scoreY);
  text(scoreText, width/2, scoreY - 3);
  text(scoreText, width/2, scoreY + 3);
  
  fill(0, 255, 255); // Cyan main text
  text(scoreText, width/2, scoreY);
  
  // Instruction text
  fill(255, 255, 0);
  textSize(24);
  text("Press 'B' to return to Menu", width/2, height/2 + 100);
}

// INTERACTIONS
//Detects key presses to navigate menus and pass input to the game.

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    exit(); 
  }
  
  if (gameState == 0) {
    if (key == 'e' || key == 'E') {
      // Audio transition and safety stops
      bgmMenu.stop();
      songHard.stop(); 
      songEasy.stop();
      
      songEasy.play();
      currentGame = new Game(100, 7.0, songEasy);
      gameState = 2;
      
    } else if (key == 'h' || key == 'H') {
      // Audio transition and safety stops
      bgmMenu.stop();
      songEasy.stop(); 
      songHard.stop();
      
      songHard.play();
      // FIXED: Now properly sets up the Hard game, 160 BPM, speed 13.0, hard track
      currentGame = new Game(160, 13.0, songHard); 
      gameState = 3; 
      
    } else if (key == 'm' || key == 'M') {
      gameState = 1;
    }
  } else if (gameState == 1 || gameState == 4) {
    if (key == 'b' || key == 'B') {
      // Ensure all game songs are fully stopped when returning to menu
      songEasy.stop();
      songHard.stop();
      if (!bgmMenu.isPlaying()) bgmMenu.loop(); 
      gameState = 0;
    }
  } else if (gameState == 2 || gameState == 3) {
    currentGame.checkInput(keyCode); 
  }
}


// CLASSES

// Class for holding all functionalities within the game. 
// game loop, checkInput, and spawnNotes functions.
class Game {
  int bpm;
  int msPerBeat;
  int lastBeatTime;
  ArrayList<Note> activeNotes;
  int score;
  float currentSpeed; // Passed to the notes
  SoundFile track;    // The song currently playing
  int gameStartTime;  // Tracks when the level started
  
  // target zone properties
  float targetX = 150; 
  float targetY; 
  
  // feedback variables
  String displayText;
  int feedbackTimer;
  int combo;
  color feedbackColor;
  
  Game(int setBpm, float noteSpeed, SoundFile currentTrack) {
    bpm = setBpm;
    msPerBeat = 60000 / bpm; 
    currentSpeed = noteSpeed;
    track = currentTrack;
    
    activeNotes = new ArrayList<Note>();
    lastBeatTime = millis();
    gameStartTime = millis();
    
    score = 0;
    displayText = "";
    feedbackTimer = 0;
    combo = 0;
    feedbackColor = color(255);
  }
  
  //Main Game play loop called from draw
  void game() {
    // If 1000ms has passed (giving the song time to start) AND the song stops playing
    if (millis() - gameStartTime > 1000 && !track.isPlaying()) {
      finalScore = score; // Save the score globally
      gameState = 4;      // Move to Game Over screen
      return;             // Stop drawing the game
    }
    // center the track vertically
    targetY = height / 2; 
    
    // draw track background
    fill(50, 50, 50, 150);
    rectMode(CENTER);
     // gray track spanning the screen
    rect(width/2, targetY, width, 100);
    
    // target hit zone on the left side
    noFill();
    stroke(255, 200, 0); // Gold outline
    strokeWeight(4);
    ellipse(targetX, targetY, 60, 60); 
    // reset
    strokeWeight(1); 
    noStroke();
    
    spawnNotes();
    
    // update and draw all active notes
    for (int i = activeNotes.size() - 1; i >= 0; i--) {
      Note n = activeNotes.get(i);
      n.update();
      n.display();
      
      // remove note if it passes the left edge of the screen
      if (n.x < targetX - 75) {
        // miss logic
        activeNotes.remove(i);
        combo = 0;
        displayText = "MISS";
        feedbackColor = color(255, 50, 50);
        feedbackTimer = 30;
      }
    }
    
    
    // display Score UI
    textAlign(LEFT, TOP);
    fill(255);
    textSize(24);
    text("Score: " + score, 20, 20);
    text("BPM: " + bpm, 20, 50);
    
    if (feedbackTimer > 0) {
      fill(feedbackColor);
      textSize(32);
      textAlign(CENTER, CENTER);
      text(displayText, targetX, targetY - 100);
      feedbackTimer -= 1;
    }
  }
  
  //timing system for notes. predefines when notes appear based on BPM.
  void spawnNotes() {
    if (millis() - lastBeatTime >= msPerBeat) {
      int randomDirection = int(random(4)); // 0: Left, 1: Up, 2: Down, 3: Right
      activeNotes.add(new Note(randomDirection, height/2, currentSpeed));
      lastBeatTime = millis();
    }
  }
  
  // detect arrow key presses and check timing accuracy (hit window)
  void checkInput(int kCode) {
    // 1. Find the note closest to targetX
    // 2. Check if the distance is within your +/- 200ms hit window
    // 3. Check if the kCode matches the Note's direction
    // 4. Update score and play sound effect based on Perfect/Good/Miss
    
    // default value: -1, for non-arrow key 
    int direction = -1;
    // maps arrow keys to one of 4 possible directions
    if (kCode == LEFT) {
      direction = 0;
    }
    else if (kCode == UP) {
      direction = 1;
    }
    else if (kCode == DOWN) {
      direction =2;
    }
    else if (kCode == RIGHT) {
      direction = 3;
    }
    // exit function if none of the arrow keys are pressed 
    if (direction == -1) {
      return;
    }
    // make sure notes are on screen
    if (activeNotes.size() > 0) {
      // get note closest to target circle
      Note frontNote = activeNotes.get(0);
      // calculate distance from circle
      float distance = abs(frontNote.x - targetX);
      // only make note hittable if < 50 pixels
      if (distance < 50) {
        // check if correct arrow key pressed, update score and display text accordingly.
        if (frontNote.direction == direction) {
          if (distance < 10) {
            score += 100;
            combo += 1;
            feedbackColor = color(0, 255, 255);
            displayText = "PERFECT";
            sfxPerfect.play();
          }
          else if (distance < 20) {
            score += 50;
            combo += 1;
            feedbackColor = color(50, 255, 50);
            displayText = "GOOD";
            sfxPop.play();
          }
          else {
            score += 25;
            combo = 0;
            feedbackColor = color(255, 150, 0);
            displayText = "POOR";
            sfxPop.play();
          }
        // miss
        } else {
          score += 0;
          combo = 0;
          feedbackColor = color(255, 50, 50);
          displayText = "MISS";

        }
        // timer for how long text appears on screen
        feedbackTimer = 30;
        // remove note when done
        activeNotes.remove(0);
      }
    }
  }
}

//Helper class to manage individual horizontal scrolling notes
class Note {
  // horizontal scroll speed
  float x, y;
  int direction; 
  float speed; 
  
  // Note constructor now takes a custom speed
  Note(int dir, float trackY, float nSpeed) {
    direction = dir;
    y = trackY; 
    speed = nSpeed;
    x = width + 50; 
  }
  
  void update() {
    x -= speed; // move left towards the target zone
  }
  
  void display() {
    // color display for notes
    if (direction == 0 || direction == 3) {
      fill(255, 50, 50); // red for left/right
    } else {
      fill(50, 150, 255); // blue for up/down
    }
    // draw the note circle
    ellipse(x, y, 60, 60); 
    
    // draw the directional arrow inside the circle
    fill(255); // White text
    textAlign(CENTER, CENTER);
    textSize(36); 
    
    // map the 0-3 int to visual arrow symbols
    String dirText = "";
    if (direction == 0) dirText = "←";
    else if (direction == 1) dirText = "↑";
    else if (direction == 2) dirText = "↓";
    else if (direction == 3) dirText = "→";
    
    text(dirText, x, y - 4);
  }
}
