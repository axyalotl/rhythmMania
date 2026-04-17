import processing.sound.*;

// Final Project 1
// global variables
int gameState = 0; // 0: Menu, 1: HowToPlay, 2: Easy, 3: Hard
Game currentGame;
int finalScore = 0; // Stores the score to show on the end screen
int finalMaxScore = 0;
// TODO: insert media into data folder
// PImage mikuDance, bgImage, noteIcon;
// SoundFile easySong, hardSong, hitSound, clickSound;
PImage bgMain, bgEasy, bgHard, mikuImg;
SoundFile sfxPerfect, sfxPop, bgmMenu, songEasy, songHard;
// audio global variable
float songVolume = .1;
// SFX global variable
float sfxVolume = .2;

// SETUP
void setup() {
  size(800, 600);
  
  frameRate(60); 
  smooth(4);
  
  // TODO: Load images and sounds here
  // mikuDance = loadImage("miku.png");
  // hitSound = new SoundFile(this, "perfect_hit.wav");
  // load Images
  bgMain = loadImage("background.jpg");
  bgEasy = loadImage("ez_mode_background.jpg");
  bgHard = loadImage("hard_mode_background.jpg"); 
  mikuImg = loadImage("hatsune-miku.png");
  
  // load audio
  sfxPerfect = new SoundFile(this, "perfect.mp3");
  sfxPop = new SoundFile(this, "pop.wav");
  bgmMenu = new SoundFile(this, "Perfume cut.mp3");
  songEasy = new SoundFile(this, "Replay cut.mp3");
  songHard = new SoundFile(this, "True Romance cut.mp3");
  
  // start menu music on loop
  bgmMenu.loop();
  // menu music volume
  bgmMenu.amp(songVolume);
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
  
  // menu buttons setup
  rectMode(CENTER);
  float button_width = 400;
  float button_height = 50;
  float startY = height/2 + 10;
  
  // easy button
  // dynamic button coloring
  if (overButton(width / 2, startY, button_width, button_height)) {
    fill(150, 150, 150, 200);
  } else {
    fill(50, 50, 50, 200);
  }
  rect(width / 2, startY, button_width, button_height, 10);
  fill(255);
  textSize(20);
  text("(E) Easy Mode - 100 BPM", width / 2, startY);
  
  // hard mode
  if (overButton(width / 2, startY + 55, button_width, button_height)) {
    fill(150, 150, 150, 200);
  } else {
    fill(50, 50, 50, 200);
  }
  rect(width / 2, startY + 55, button_width, button_height, 10);
  fill(255);
  textSize(20);
  text("(H) Hard Mode - 160 BPM", width / 2, startY + 55);
  
  // user manual
  if (overButton(width / 2, startY + 110, button_width, button_height)) {
    fill(150, 150, 150, 200);
  } else {
    fill(50, 50, 50, 200);
  }
  rect(width / 2, startY + 110, button_width, button_height, 10);
  fill(255);
  textSize(20);
  text("(M) User Manual", width / 2, startY + 110);
  
  // quit button
  if (overButton(width / 2, startY + 165, button_width, button_height)) {
    fill(150, 150, 150, 200);
  } else {
    fill(50, 50, 50, 200);
  }
  rect(width / 2, startY + 165, button_width, button_height, 10);
  fill(255);
  textSize(20);
  text("(Q) Quit", width / 2, startY + 165);
  
  // change rect mode back to corner
  rectMode(CORNER);
  
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
  
  float titleY = height/2 - 90;
  float scoreY = height/2 - 10;
  float gradeY = height/2 + 60;
  String titleText = "SONG COMPLETE!";
  String scoreText = "Final Score: " + finalScore;
  
  float accuracy = 0;
  if (finalMaxScore > 0) {
    accuracy = ((float)finalScore / finalMaxScore) * 100;
  }
  
  String grade = "F";
  color gradeColor =   color(255, 50, 50);
  
  if (accuracy >= 95) {
    grade = "S";
    gradeColor = color(255, 215, 0);
  } else if (accuracy >= 85) {
    grade = "A";
    gradeColor = color(50, 255, 50);
  } else if (accuracy >= 75) {
    grade = "B";
    gradeColor = color(50, 150, 255);
  } else if (accuracy >= 65) {
    grade = "C";
    gradeColor = color(255, 255, 0);
  } else if (accuracy >= 55) {
    grade = "D";
    gradeColor = color(255, 150, 0);
  }
  
  String gradeText = "Rank: " + grade;
  
  textSize(50);
  fill(0); // Black outline
  text(titleText, width/2 - 3, titleY);
  text(titleText, width/2 + 3, titleY);
  text(titleText, width/2, titleY - 3);
  text(titleText, width/2, titleY + 3);
  
  fill(255); // White main text
  text(titleText, width/2, titleY);
  
  // score Text with Outline
  // score text 
  textSize(40);
  fill(0); // Black shadow
  text(scoreText, width/2 + 2, scoreY + 2); 
  
  fill(0, 255, 255); // Cyan main text
  text(scoreText, width/2, scoreY);
  
  // grade text
  textSize(60);
  fill(0); // Black shadow
  text(gradeText, width/2 + 3, gradeY + 3);
  
  fill(gradeColor); // Main grade color
  text(gradeText, width/2, gradeY);
  
  fill(255, 255, 0);
  textSize(24);
  text("Press 'B' to return to Menu", width/2, height/2 + 140);
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
      songEasy.amp(songVolume);
      currentGame = new Game(100, 3.5, songEasy);
      gameState = 2;
      
    } else if (key == 'h' || key == 'H') {
      // audio transition and safety stops
      bgmMenu.stop();
      songEasy.stop(); 
      songHard.stop();
      
      songHard.play();
      songHard.amp(songVolume);
      currentGame = new Game(160, 6.5, songHard); 
      gameState = 3; 
      
    } else if (key == 'm' || key == 'M') {
      gameState = 1;
    }
  } else if (gameState == 1 || gameState == 4) {
    if (key == 'b' || key == 'B') {
      //all game songs are fully stopped when returning to menu
      songEasy.stop();
      songHard.stop();
      bgmMenu.stop();
      bgmMenu.loop(); 
      bgmMenu.amp(songVolume);
      gameState = 0;
    }
  } else if (gameState == 2 || gameState == 3) {
      if (key == 'b' || key == 'B') {
        //all game songs are fully stopped when returning to menu
        songEasy.stop();
        songHard.stop();
        bgmMenu.stop();
        bgmMenu.loop(); 
        bgmMenu.amp(songVolume);
        gameState = 0;
      }
      else {
        currentGame.checkInput(keyCode); 
      }
  }
}

void mousePressed() {
  if (gameState == 0) {
    // button config
    float button_width = 350;
    float button_height = 45;
    float startY = height/2 + 10;
    // checks if button is clicked, stop all music and play the easy song, set to easy state
    if (overButton(width / 2, startY, button_width, button_height)) {
      bgmMenu.stop();
      songHard.stop();
      songEasy.stop();
      songEasy.play();
      songEasy.amp(songVolume);
      currentGame = new Game(100, 3.5, songEasy);
      gameState = 2;
    }
    // same as above but for hard mode
    else if (overButton(width / 2, startY + 55, button_width, button_height)) {
      bgmMenu.stop();
      songHard.stop();
      songEasy.stop();
      songHard.play();
      songHard.amp(songVolume);
      currentGame = new Game(160, 6.5, songHard);
      gameState = 3;
    } 
    // opens user manual
    else if (overButton(width/2, startY + 110, button_width, button_height)) {
      gameState = 1;
    } 
    // exits the game
    else if (overButton(width/2, startY + 165, button_width, button_height)) {
      exit();
    }
  }
}

boolean overButton(float x, float y, float width_rect, float height_rect) {
  if (mouseX >= x - width_rect/2 && mouseX <= x + width_rect/2 && mouseY >= y - height_rect/2 && mouseY <= y + height_rect/2) {
    return true;
  }
  return false;
}
// CLASSES

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
  
  // note count to calculate grade
  int noteCount;
  
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
    noteCount = 0;
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
      finalMaxScore = noteCount * 100; // calculate max score at the end
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
      noteCount ++;
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
            sfxPerfect.stop();
            sfxPerfect.play();
            sfxPerfect.amp(sfxVolume);
          }
          else if (distance < 20) {
            score += 50;
            combo += 1;
            feedbackColor = color(50, 255, 50);
            displayText = "GOOD";
            sfxPop.stop();
            sfxPop.play();
            sfxPop.amp(sfxVolume);
          }
          else {
            score += 25;
            combo = 0;
            feedbackColor = color(255, 150, 0);
            displayText = "POOR";
            sfxPop.stop();
            sfxPop.play();
            sfxPop.amp(sfxVolume);
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
