//Time to play some PONG!

/*
Feel free to read this quick guide to my version of PONG with a
 lot of added stuff!
 Firstly, to cover the basics:
 - While in the example given, players were color coded, I decided to go
 with the standard white, as this is closer to the OG PONG.
 - "w" and "s" control Player 1
 - Up and down arrows control Player 2
 
 And then some more advanced controls:
 - Spacebar can be used to play/pause the game
 - (It's also how you get the ball moving at first)
 - "r" can be used to reset the game
 - You can adjust the difficulty of the game by raising or lowering
 the "difficulty" integer in the global vars. It directly corresponds
 to how fast the ball moves after each bounce.
 
 And lastly, things I added that aren't control based:
 - The speed of the ball will gradually increase as the game goes on
 - When starting the game, the ball will choose a random direction to
 go in
 - Players are forced to stand still while the game is not in progress
 - I've got nothing else to add. Have fun!
 */

import processing.sound.*;

//////////////////////////////////////////////////////////////
//Global Vars
//////////////////////////////////////////////////////////////

Animation blueRightFist;
Animation blueLeftFist;
Animation blueRightFist2;
Animation blueLeftFist2;
Animation blueRightPunch;
Animation blueLeftPunch;
Animation redRightFist;
Animation redLeftFist;
Animation redRightFist2;
Animation redLeftFist2;
Animation redRightPunch;
Animation redLeftPunch;
PImage[] bRF = new PImage[1];
PImage[] bLF = new PImage[1];
PImage[] bRP = new PImage[7];
PImage[] bLP = new PImage[7];
PImage[] rRF = new PImage[1];
PImage[] rLF = new PImage[1];
PImage[] rRP = new PImage[7];
PImage[] rLP = new PImage[7];
SoundFile wall;
SoundFile paddle;
SoundFile bounds;
SoundFile smash;
int state;
boolean jumpMode;
boolean p1PunchingLeft;
boolean p1PunchingRight;
boolean p2PunchingLeft;
boolean p2PunchingRight;
int p1StartPunch;
int p1EndPunch;
int p1PunchDown = 500;
boolean p1JustPunched = false;
int p2StartPunch;
int p2EndPunch;
int p2PunchDown = 500;
boolean p2JustPunched = false;
int startTimer;
int timer3 = 0;
int timer2 = 1000;
int timer1 = 2000;
int timer0 = 3000;

// player 1 position & collision
int p1X;
int p1Y;
int p1Top;
int p1Bottom;
int p1Left;
int p1Right;
boolean p1FacingLeft;
boolean can1Jump;
int p1Health = 100;
boolean p1Challenge = false;

// player 2 position & collision
int p2X;
int p2Y;
int p2Top;
int p2Bottom;
int p2Left;
int p2Right;
boolean p2FacingLeft;
boolean can2Jump;
int p2Health = 100;
boolean p2Challenge = false;

// player speed
int playerSpeed = 15;
int player1XSpeed = 0;
int player2XSpeed = 0;
int jump = -20;
int p1FallSpeed = 0;
int p2FallSpeed = 0;
int gravity = 1;

// player 1 move booleans
boolean is1Up = false;
boolean is1Down = false;
boolean is1Left = false;
boolean is1Right = false;

// player 2 move booleans
boolean is2Up = false;
boolean is2Down = false;
boolean is2Left = false;
boolean is2Right = false;

// player colors
color p1Color = color(255, 0, 0);
color p2Color = color(0, 0, 255);

// player size
int playerWidth = 20;
int playerHeight = 125;

// ball size
int ballDiameter = 15;

// ball position & collision
int bx;
int by;
int ballTop;
int ballBottom;
int ballLeft;
int ballRight;

// ball speed
int ballXSpeed = 0;
int ballYSpeed = 0;

// ball color
color ballColor;

// current scores of player
int p1Score;
int p2Score;


// score positions
int p1ScoreX;
int p1ScoreY;
int p2ScoreX;
int p2ScoreY;

// winning score
int winScore = 3;

//allowance
boolean allowance = false;

//difficulty
int difficulty = 1;


//////////////////////////////////////////////////////////////
//Setup
//////////////////////////////////////////////////////////////


void setup() {
  size(1200, 800);
  background(0);
  rectMode(CENTER);
  textAlign(CENTER);
  textSize(45);
  state = 0;
  ballColor = color(255);
  jumpMode = false;
  positionStart();
  scoreStart();
  for (int index = 0; index < bLF.length; index++) {
    bLF[index] = loadImage("bLF"+index+".gif");
  }
  for (int index = 0; index < bLP.length; index++) {
    bLP[index] = loadImage("bLP"+index+".gif");
  }
  for (int index = 0; index < bRF.length; index++) {
    bRF[index] = loadImage("bRF"+index+".gif");
  }
  for (int index = 0; index < bRP.length; index++) {
    bRP[index] = loadImage("bRP"+index+".gif");
  }
  for (int index = 0; index < rLF.length; index++) {
    rLF[index] = loadImage("rLF"+index+".gif");
  }
  for (int index = 0; index < rLP.length; index++) {
    rLP[index] = loadImage("rLP"+index+".gif");
  }
  for (int index = 0; index < rRF.length; index++) {
    rRF[index] = loadImage("rRF"+index+".gif");
  }
  for (int index = 0; index < rRP.length; index++) {
    rRP[index] = loadImage("rRP"+index+".gif");
  }
  blueRightFist = new Animation(bRF, 1, 1);
  blueLeftFist = new Animation(bLF, 1, 1);
  redRightFist = new Animation(rRF, 1, 1);
  redLeftFist = new Animation(rLF, 1, 1);
  blueRightFist2 = new Animation(bRF, 1, 1);
  blueLeftFist2 = new Animation(bLF, 1, 1);
  redRightFist2 = new Animation(rRF, 1, 1);
  redLeftFist2 = new Animation(rLF, 1, 1);
  blueRightPunch = new Animation(bRP, .245, 1);
  blueLeftPunch = new Animation(bLP, .245, 1);
  redRightPunch = new Animation(rRP, .245, 1);
  redLeftPunch = new Animation(rLP, .245, 1);

  wall = new SoundFile(this, "wall.mp3");
  paddle = new SoundFile(this, "paddle.mp3");
  bounds = new SoundFile(this, "bounds.mp3");
  smash = new SoundFile(this, "FDSmash.mp3");
}

void positionStart() {
  // player 1 position
  p1X = 50;
  p1Y = height/2;
  p1FacingLeft = false;
  p2FacingLeft = true;

  // player 2 position
  p2X = width - 50;
  p2Y = height/2;

  // ball position
  bx = width/2;
  by = height/2;
}

void scoreStart() {
  // current scores of player
  p1Score = 0;
  p2Score = 0;

  // score positions
  p1ScoreX = width/2 - 50;
  p1ScoreY = 50;
  p2ScoreX = width/2 + 50;
  p2ScoreY = 50;
}


//////////////////////////////////////////////////////////////
//Draw
//////////////////////////////////////////////////////////////


void draw() {
  print("jumpMode = ");
  println(jumpMode);
  print("p1FacingLeft = ");
  println(p1FacingLeft);
  print("p2FacingLeft = ");
  println(p2FacingLeft);
  print("p1PunchingLeft = ");
  println(p1PunchingLeft);
  print("p1PunchingRight = ");
  println(p1PunchingRight);
  print("p2PunchingLeft = ");
  println(p2PunchingLeft);
  print("p2PunchingRight = ");
  println(p2PunchingRight);
  switch(state) {
  case 0:
    background(0);
    fill(255);
    stroke(255);
    textSize(100);
    text("ULTIMATE PONG", width/2, height/2 - 100);
    textSize(45);
    text("Get ready to RUMBLE!!!", width/2, height/2);
    textSize(30);
    text("Press 'q' to start/restart", width/2, height/2 + 50);
    text("'space' to play/pause", width/2, height/2 + 100);
    text("'e' or '0' to CHALLENGE", width/2, height/2 + 150);
    fill(255, 0, 0);
    stroke(255, 0, 0);
    text("Player 1: WASD", width/4 - 50, height/2 + 50);
    fill(0, 0, 255);
    stroke(0, 0, 255);
    text("Player 2: Arrows", 3*width/4 + 50, height/2 + 50);
    break;

  case 1:
    textSize(45);
    background(0);
    if (jumpMode == true) {
      if (p1FacingLeft == false) {
        redRightFist2.display(p1X + 19, p1Y - 5);
      } else {
        redLeftFist2.display(p1X - 19, p1Y - 5);
      }
      if (p2FacingLeft == false) {
        blueRightFist2.display(p2X + 19, p2Y - 5);
      } else {
        blueLeftFist2.display(p2X - 19, p2Y - 5);
      }
    }
    drawPlayer(p1X, p1Y, playerWidth, playerHeight, p1Color);
    drawPlayer(p2X, p2Y, playerWidth, playerHeight, p2Color);

    movePlayers();

    moveBall();

    ballHitP1();
    ballHitP2();

    drawScore(p1Score, p1ScoreX, p1ScoreY, p1Color);
    drawScore(p2Score, p2ScoreX, p2ScoreY, p2Color);
    if (jumpMode == true) {
      drawHealth(p1Health, 50, 50, p1Color);
      drawHealth(p2Health, width - 50, 50, p2Color);
    }

    if (p1Challenge == true) {
      textSize(50);
      fill(p1Color);
      stroke(p1Color);
      text("CHALLENGE", width/4, 50);
    }

    if (p2Challenge == true) {
      textSize(50);
      fill(p2Color);
      stroke(p2Color);
      text("CHALLENGE", 3*width/4, 50);
    }

    if (p2Challenge == false && p1Challenge == false) {
      startTimer = millis();
      drawBall(bx, by, ballDiameter, ballColor);
      fireball();
      particles();
    } else {
      allowance = false;
      textSize(100);
      fill(255);
      stroke(255);
      if (millis() - startTimer >= timer3 && millis() - startTimer < timer2) {
        text("3", width/2, height/2);
      } else if (millis() - startTimer >= timer2 && millis() - startTimer < timer1) {
        text("2", width/2, height/2);
      } else if (millis() - startTimer >= timer1 && millis() - startTimer < timer0) {
        text("1", width/2, height/2);
      } else if (millis() - startTimer >= timer0) {
        text("FIGHT!", width/2, height/2);
        textSize(45);
        text("(Down to punch)", width/2, height/2 + 75);
        jumpMode = true;
        if (smash.isPlaying() == false) {
          smash.play();
        }
        allowance = true;
      }
    }

    if (p1Health <= 0) {
      bx = width/2;
      by = height/2;
      ballXSpeed = 0;
      ballYSpeed = 0;
      p1Y = height/2;
      p2Y = height/2;
      p1Challenge = false;
      p2Challenge = false;
      allowance = false;
      jumpMode = false;
      p1X = 50;
      p2X = width - 50;
      p1Health = 100;
      p2Health = 100;
      player1XSpeed = 0;
      smash.stop();
      bounds.play();
      p2Score += 1;
    }
    if (p2Health <= 0) {
      bx = width/2;
      by = height/2;
      ballXSpeed = 0;
      ballYSpeed = 0;
      p1Y = height/2;
      p2Y = height/2;
      p1Challenge = false;
      p2Challenge = false;
      allowance = false;
      jumpMode = false;
      p1X = 50;
      p2X = width - 50;
      p1Health = 100;
      p2Health = 100;
      player2XSpeed = 0;
      smash.stop();
      bounds.play();
      p1Score += 1;
    }
    if (p1Score >= 3 || p2Score >= 3) {
      state = 2;
    }
    break;

  case 2:
    background(0);
    player1WinScreen();
    player2WinScreen();
    if (state >= 3) {
      state = 0;
    }
    break;
  }
}

void drawHealth(int h, int x, int y, color c) {
  fill(c);
  stroke(c);
  text(h, x, y);
}

void drawPlayer(int x, int y, int w, int h, color c) {
  fill(c);
  stroke(c);
  rect(x, y, w, h);
}

void keyPressed() {
  if (key == 'q') {
    if (state == 0) {
      state = 1;
    } else {
      allowance = false;
      jumpMode = false;
      p1X = 50;
      p2X = width - 50;
      p1Score = 0;
      p2Score = 0;
      bx = width/2;
      by = height/2;
      ballXSpeed = 0;
      ballYSpeed = 0;
      p1Y = height/2;
      p2Y = height/2;
      p1Health = 100;
      p2Health = 100;
      smash.stop();
      bounds.play();
      state = 0;
    }
  }
  if (key == 'w') {
    is1Up = true;
  }
  if (key == 's') {
    if (jumpMode == true && p1PunchingLeft == false && p1PunchingRight == false && p1JustPunched == false) {
      if (p1FacingLeft == true) {
        p1PunchingLeft = true;
      } else {
        p1PunchingRight = true;
      }
    } else {
      is1Down = true;
    }
  }
  if (key == CODED) {
    if (keyCode == UP) {
      is2Up = true;
    }
  }
  if (key == CODED) {
    if (keyCode == DOWN) {
      if (jumpMode == true && p2PunchingLeft == false && p2PunchingRight == false && p2JustPunched == false) {
        if (p2FacingLeft == true) {
          p2PunchingLeft = true;
        } else {
          p2PunchingRight = true;
        }
      } else {
        is2Down = true;
      }
    }
  }
  if (key == 'a') {
    is1Left = true;
    p1FacingLeft = true;
  }
  if (key == 'd') {
    is1Right = true;
    p1FacingLeft = false;
  }
  if (key == CODED) {
    if (keyCode == LEFT) {
      is2Left = true;
      p2FacingLeft = true;
    }
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      is2Right = true;
      p2FacingLeft = false;
    }
  }

  //ball start
  if (key == ' ' && state == 1) {
    allowance = !allowance;
    if (ballXSpeed == 0) {
      if (random(2) < 1) {
        ballXSpeed = 5;
      } else {
        ballXSpeed = -5;
      }

      if (random(2) < 1) {
        ballYSpeed = 5;
      } else {
        ballYSpeed = -5;
      }
    }
  }

  if (key == 'e') {
    p1Challenge = true;
  }

  if (key == '0') {
    p2Challenge = true;
  }
}

void keyReleased() {
  if (key == 'w') {
    is1Up = false;
  }
  if (key == 's') {
    is1Down = false;
  }
  if (key == CODED) {
    if (keyCode == UP) {
      is2Up = false;
    }
  }
  if (key == CODED) {
    if (keyCode == DOWN) {
      is2Down = false;
    }
  }
  if (key == 'a') {
    is1Left = false;
  }
  if (key == 'd') {
    is1Right = false;
  }
  if (key == CODED) {
    if (keyCode == LEFT) {
      is2Left = false;
    }
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      is2Right = false;
    }
  }
}

void movePlayers() {
  if (p1X < playerWidth/2) {
    p1X = playerWidth/2;
  }
  if (p1X > width - playerWidth/2) {
    p1X = width - playerWidth/2;
  }
  if (p2X < playerWidth/2) {
    p2X = playerWidth/2;
  }
  if (p2X > width - playerWidth/2) {
    p2X = width - playerWidth/2;
  }
  if (p1Y < height - playerHeight/2 - 1) {
    can1Jump = false;
  } else {
    can1Jump = true;
  }
  if (p2Y < height - playerHeight/2 - 1) {
    can2Jump = false;
  } else {
    can2Jump = true;
  }

  if (jumpMode == true) {
    if (p1PunchingLeft == false && p1PunchingRight == false) {
      if (p1FacingLeft == false) {
        redRightFist.display(p1X + 15, p1Y);
      } else {
        redLeftFist.display(p1X - 15, p1Y);
      }
    }
    if (p2PunchingLeft == false && p2PunchingRight == false) {
      if (p2FacingLeft == false) {
        blueRightFist.display(p2X + 15, p2Y);
      } else {
        blueLeftFist.display(p2X - 15, p2Y);
      }
    }

    if (p1PunchingLeft == false && p1PunchingRight == true) {
      redRightPunch.display(p1X + 45, p1Y);
      redRightPunch.isAnimating = true;
    } else {
      redRightPunch.isAnimating = false;
    }

    if (p1PunchingLeft == true && p1PunchingRight == false) {
      redLeftPunch.display(p1X - 45, p1Y);
      redLeftPunch.isAnimating = true;
    } else {
      redLeftPunch.isAnimating = false;
    }

    if (p2PunchingLeft == false && p2PunchingRight == true) {
      blueRightPunch.display(p2X + 45, p2Y);
      blueRightPunch.isAnimating = true;
    } else {
      blueRightPunch.isAnimating = false;
    }

    if (p2PunchingLeft == true && p2PunchingRight == false) {
      blueLeftPunch.display(p2X - 45, p2Y);
      blueLeftPunch.isAnimating = true;
    } else {
      blueLeftPunch.isAnimating = false;
    }

    if (can1Jump == true && is1Left == false && is1Right == false) {
      player1XSpeed = 0;
    } else {
      p1X += player1XSpeed;
      if (is1Left == false && is1Right == false) {
        if (player1XSpeed > 0) {
          player1XSpeed--;
        } else if (player1XSpeed < 0) {
          player1XSpeed++;
        }
      }
    }
    if (can2Jump == true && is2Left == false && is2Right == false) {
      player2XSpeed = 0;
    } else {
      p2X += player2XSpeed;
      if (is2Left == false && is2Right == false) {
        if (player2XSpeed > 0) {
          player2XSpeed--;
        } else if (player2XSpeed < 0) {
          player2XSpeed++;
        }
      }
    }
    p1FallSpeed += gravity;
    p2FallSpeed += gravity;
    p1Y += p1FallSpeed;
    p2Y += p2FallSpeed;
    if (is1Up == true && allowance == true && can1Jump == true) {
      p1FallSpeed = jump;
    }
    if (is2Up == true && allowance == true && can2Jump == true) {
      p2FallSpeed = jump;
    }
    if (is1Left == true && allowance == true && player1XSpeed >= -15) {
      if (can1Jump == true) {
        player1XSpeed--;
      } else {
        player1XSpeed -= 2;
      }
    }
    if (is2Left == true && allowance == true && player2XSpeed >= -15) {
      if (can2Jump == true) {
        player2XSpeed--;
      } else {
        player2XSpeed -= 2;
      }
    }
    if (is1Right == true && allowance == true && player1XSpeed <= 15) {
      if (can1Jump == true) {
        player1XSpeed++;
      } else {
        player1XSpeed += 2;
      }
    }
    if (is2Right == true && allowance == true && player2XSpeed <= 15) {
      if (can2Jump == true) {
        player2XSpeed++;
      } else {
        player2XSpeed += 2;
      }
    }
  }

  //movement
  if (is1Up == true && allowance == true && jumpMode == false) {
    p1Y -= playerSpeed;
  }

  if (is1Down == true && allowance == true && jumpMode == false) {
    p1Y += playerSpeed;
  }

  if (is2Up == true && allowance == true && jumpMode == false) {
    p2Y -= playerSpeed;
  }

  if (is2Down == true && allowance == true && jumpMode == false) {
    p2Y += playerSpeed;
  }

  //wall collision
  if (p1Y <= playerHeight/2) {
    p1Y = playerHeight/2;
  }

  if (p1Y >= height - playerHeight/2) {
    p1Y = height - playerHeight/2;
  }

  if (p2Y <= playerHeight/2) {
    p2Y = playerHeight/2;
  }

  if (p2Y >= height - playerHeight/2) {
    p2Y = height - playerHeight/2;
  }

  if (p1PunchingRight == false && p1PunchingLeft == false) {
    p1StartPunch = millis();
  } else {
    if (millis() - p1StartPunch >= p1PunchDown) {
      p1PunchingRight = false;
      p1PunchingLeft = false;
      p1JustPunched = true;
    }
  }

  if (p1JustPunched == false) {
    p1EndPunch = millis();
  } else {
    if (millis() - p1EndPunch >= p1PunchDown) {
      p1JustPunched = false;
    }
  }

  if (p2JustPunched == false) {
    p2EndPunch = millis();
  } else {
    if (millis() - p2EndPunch >= p2PunchDown) {
      p2JustPunched = false;
    }
  }

  if (p2PunchingRight == false && p2PunchingLeft == false) {
    p2StartPunch = millis();
  } else {
    if (millis() - p2StartPunch >= p2PunchDown) {
      p2PunchingRight = false;
      p2PunchingLeft = false;
      p2JustPunched = true;
    }
  }

  if (p2Left <= p1Right + 55 && p2Right >= p1Right && p2Top <= p1Bottom && p2Bottom >= p1Top && p1PunchingRight == true) {
    p2FallSpeed = -15;
    player2XSpeed = 20;
    p2Health -= 2;
    if (paddle.isPlaying() == false) {
      paddle.play();
    }
  }
  if (p2Left <= p1Left && p2Right >= p1Left - 55 && p2Top <= p1Bottom && p2Bottom >= p1Top && p1PunchingLeft == true) {
    p2FallSpeed = -15;
    player2XSpeed = -20;
    p2Health -= 2;
    if (paddle.isPlaying() == false) {
      paddle.play();
    }
  }
  if (p1Left <= p2Right + 55 && p1Right >= p2Right && p1Top <= p2Bottom && p1Bottom >= p2Top && p2PunchingRight == true) {
    p1FallSpeed = -15;
    player1XSpeed = 20;
    p1Health -= 2;
    if (paddle.isPlaying() == false) {
      paddle.play();
    }
  }
  if (p1Left <= p2Left && p1Right >= p2Left - 55 && p1Top <= p2Bottom && p1Bottom >= p2Top && p2PunchingLeft == true) {
    p1FallSpeed = -15;
    player1XSpeed = -20;
    p1Health -= 2;
    if (paddle.isPlaying() == false) {
      paddle.play();
    }
  }
}

void drawBall(int bx, int by, int ballDiameter, color ballColor) {
  stroke(ballColor);
  fill(ballColor);
  circle(bx, by, ballDiameter);
}

void moveBall() {
  //movement
  if (allowance == true && jumpMode == false) {
    bx += ballXSpeed;
    by += 2 * ballYSpeed / 3;
  }

  //wall collision
  if (by <= ballDiameter/2) {
    wall.play();
    ballYSpeed = -ballYSpeed;
  }

  if (by >= height - ballDiameter/2) {
    wall.play();
    ballYSpeed = -ballYSpeed;
  }

  //edges reset
  if (bx <= 0) {
    bx = width/2;
    by = height/2;
    ballXSpeed = 0;
    ballYSpeed = 0;
    p1Y = height/2;
    p2Y = height/2;
    allowance = false;
    bounds.play();
    p2Score += 1;
  }

  if (bx >= width) {
    bx = width/2;
    by = height/2;
    ballXSpeed = 0;
    ballYSpeed = 0;
    p1Y = height/2;
    p2Y = height/2;
    allowance = false;
    bounds.play();
    p1Score += 1;
  }
}

void ballHitP1() {

  //ball collision
  ballTop = by - ballDiameter/2;
  ballBottom = by + ballDiameter/2;
  ballLeft = bx - ballDiameter/2;
  ballRight = bx + ballDiameter/2;

  //player1 collision
  p1Top = p1Y - playerHeight/2;
  p1Bottom = p1Y + playerHeight/2;
  p1Left = p1X - playerWidth/2;
  p1Right = p1X + playerWidth/2;

  //collision
  if (p1Left <= ballRight && p1Right >= ballLeft && p1Top <= ballBottom && p1Bottom >= ballTop) {
    paddle.play();
    ballXSpeed = -ballXSpeed + difficulty;
    if (ballYSpeed < 0) {
      if (random(2) < 1) {
        ballYSpeed = ballYSpeed - difficulty;
      }
    } else {
      if (random(2) < 1) {
        ballYSpeed = ballYSpeed + difficulty;
      }
    }
  }
}

void ballHitP2() {

  //ball collision
  ballTop = by - ballDiameter/2;
  ballBottom = by + ballDiameter/2;
  ballLeft = bx - ballDiameter/2;
  ballRight = bx + ballDiameter/2;

  //player2 collision
  p2Top = p2Y - playerHeight/2;
  p2Bottom = p2Y + playerHeight/2;
  p2Left = p2X - playerWidth/2;
  p2Right = p2X + playerWidth/2;

  //collision
  if (p2Top <= ballBottom && p2Bottom >= ballTop && p2Left <= ballRight && p2Right >= ballLeft) {
    paddle.play();
    ballXSpeed = -ballXSpeed - difficulty;
    if (ballYSpeed < 0) {
      if (random(2) < 1) {
        ballYSpeed = ballYSpeed - difficulty;
      }
    } else {
      if (random(2) < 1) {
        ballYSpeed = ballYSpeed + difficulty;
      }
    }
  }
}

void drawScore(int score, int scoreX, int scoreY, color c) {
  fill(c);
  stroke(c);
  textSize(45);
  text(score, scoreX, scoreY);
}

void player1WinScreen() {
  if (p1Score >= winScore) {
    ballXSpeed = 0;
    ballYSpeed = 0;
    fill(p1Color);
    textSize(75);
    text("Player 1 Wins!", width/2, height/2 - 75);
    allowance = false;
    fill(255);
  }
}

void player2WinScreen() {
  if (p2Score >= winScore) {
    ballXSpeed = 0;
    ballYSpeed = 0;
    fill(p2Color);
    textSize(75);
    text("Player 2 Wins!", width/2, height/2 - 75);
    allowance = false;
    fill(255);
  }
}

void fireball() {
  ballColor = color(255, 255 - ((abs(ballXSpeed) - 10) * 15), 255 - ((abs(ballXSpeed) - 5) * 15));
}

void particles() {
  fill(ballColor);
  stroke(ballColor);
  if (ballXSpeed == 0 && ballYSpeed == 0) {
  } else {
    square(bx - ballXSpeed - (abs(ballXSpeed) / ballXSpeed) * random(0, 5),
      by - ballYSpeed - (abs(ballYSpeed) / ballYSpeed) * random(0, 3), random(3, 7));
    square(bx - ballXSpeed - (abs(ballXSpeed) / ballXSpeed) * random(5, 10),
      by - ballYSpeed - (abs(ballYSpeed) / ballYSpeed) * random(3, 6), random(2, 6));
    square(bx - ballXSpeed - (abs(ballXSpeed) / ballXSpeed) * random(10, 15),
      by - ballYSpeed - (abs(ballYSpeed) / ballYSpeed) * random(6, 9), random(1, 5));
    square(bx - ballXSpeed - (abs(ballXSpeed) / ballXSpeed) * random(0, 5),
      by - ballYSpeed - (abs(ballYSpeed) / ballYSpeed) * random(0, 3), random(3, 7));
    square(bx - ballXSpeed - (abs(ballXSpeed) / ballXSpeed) * random(5, 10),
      by - ballYSpeed - (abs(ballYSpeed) / ballYSpeed) * random(3, 6), random(2, 6));
    square(bx - ballXSpeed - (abs(ballXSpeed) / ballXSpeed) * random(10, 15),
      by - ballYSpeed - (abs(ballYSpeed) / ballYSpeed) * random(6, 9), random(1, 5));
  }
}
