#include <CapSense.h>

int knob1RawValue = 0;
int knob2RawValue = 0;
int knob3RawValue = 0;
int knob4RawValue = 0;

int button1RawValue = 0;
int button2RawValue = 0;

int rotaryStatus;
int dialImpulse;
int dialCount = 0;

int knob1Value = 0;
int knob2Value = 0;
int knob3Value = 0;
int knob4Value = 0;

int pk1v = 0;

int button1Value = 0;
int button2Value = 0;

int rotaryStatusValue;
int dialImpulseValue;

int newPitch = 0;
String inString = "";
byte master;

int knob1Pin = A0;
int knob2Pin = A1;
int knob3Pin = A2;
int knob4Pin = A3;

int button1Pin = 35;
int button2Pin = 36;

int vua = 27;
int vub = 26;
int vuc = 25;
int vud = 28;
int vue = 29;
int vuf = 30;
int vug = 31;
int vuh = 32;
int vui = 33;
int vuj = 34;
int vuk = 35;

CapSense   pitchAntenna = CapSense(4,6);
//CapSense   volumeAntenna = CapSense(4,5);

static const byte ASCII[][5] =
{
 {0x00, 0x00, 0x00, 0x00, 0x00} // 20  
,{0x00, 0x00, 0x5f, 0x00, 0x00} // 21 !
,{0x00, 0x07, 0x00, 0x07, 0x00} // 22 "
,{0x14, 0x7f, 0x14, 0x7f, 0x14} // 23 #
,{0x24, 0x2a, 0x7f, 0x2a, 0x12} // 24 $
,{0x23, 0x13, 0x08, 0x64, 0x62} // 25 %
,{0x36, 0x49, 0x55, 0x22, 0x50} // 26 &
,{0x00, 0x05, 0x03, 0x00, 0x00} // 27 '
,{0x00, 0x1c, 0x22, 0x41, 0x00} // 28 (
,{0x00, 0x41, 0x22, 0x1c, 0x00} // 29 )
,{0x14, 0x08, 0x3e, 0x08, 0x14} // 2a *
,{0x08, 0x08, 0x3e, 0x08, 0x08} // 2b +
,{0x00, 0x50, 0x30, 0x00, 0x00} // 2c ,
,{0x08, 0x08, 0x08, 0x08, 0x08} // 2d -
,{0x00, 0x60, 0x60, 0x00, 0x00} // 2e .
,{0x20, 0x10, 0x08, 0x04, 0x02} // 2f /
,{0x3e, 0x51, 0x49, 0x45, 0x3e} // 30 0
,{0x00, 0x42, 0x7f, 0x40, 0x00} // 31 1
,{0x42, 0x61, 0x51, 0x49, 0x46} // 32 2
,{0x21, 0x41, 0x45, 0x4b, 0x31} // 33 3
,{0x18, 0x14, 0x12, 0x7f, 0x10} // 34 4
,{0x27, 0x45, 0x45, 0x45, 0x39} // 35 5
,{0x3c, 0x4a, 0x49, 0x49, 0x30} // 36 6
,{0x01, 0x71, 0x09, 0x05, 0x03} // 37 7
,{0x36, 0x49, 0x49, 0x49, 0x36} // 38 8
,{0x06, 0x49, 0x49, 0x29, 0x1e} // 39 9
,{0x00, 0x36, 0x36, 0x00, 0x00} // 3a :
,{0x00, 0x56, 0x36, 0x00, 0x00} // 3b ;
,{0x08, 0x14, 0x22, 0x41, 0x00} // 3c <
,{0x14, 0x14, 0x14, 0x14, 0x14} // 3d =
,{0x00, 0x41, 0x22, 0x14, 0x08} // 3e >
,{0x02, 0x01, 0x51, 0x09, 0x06} // 3f ?
,{0x32, 0x49, 0x79, 0x41, 0x3e} // 40 @
,{0x7e, 0x11, 0x11, 0x11, 0x7e} // 41 A
,{0x7f, 0x49, 0x49, 0x49, 0x36} // 42 B
,{0x3e, 0x41, 0x41, 0x41, 0x22} // 43 C
,{0x7f, 0x41, 0x41, 0x22, 0x1c} // 44 D
,{0x7f, 0x49, 0x49, 0x49, 0x41} // 45 E
,{0x7f, 0x09, 0x09, 0x09, 0x01} // 46 F
,{0x3e, 0x41, 0x49, 0x49, 0x7a} // 47 G
,{0x7f, 0x08, 0x08, 0x08, 0x7f} // 48 H
,{0x00, 0x41, 0x7f, 0x41, 0x00} // 49 I
,{0x20, 0x40, 0x41, 0x3f, 0x01} // 4a J
,{0x7f, 0x08, 0x14, 0x22, 0x41} // 4b K
,{0x7f, 0x40, 0x40, 0x40, 0x40} // 4c L
,{0x7f, 0x02, 0x0c, 0x02, 0x7f} // 4d M
,{0x7f, 0x04, 0x08, 0x10, 0x7f} // 4e N
,{0x3e, 0x41, 0x41, 0x41, 0x3e} // 4f O
,{0x7f, 0x09, 0x09, 0x09, 0x06} // 50 P
,{0x3e, 0x41, 0x51, 0x21, 0x5e} // 51 Q
,{0x7f, 0x09, 0x19, 0x29, 0x46} // 52 R
,{0x46, 0x49, 0x49, 0x49, 0x31} // 53 S
,{0x01, 0x01, 0x7f, 0x01, 0x01} // 54 T
,{0x3f, 0x40, 0x40, 0x40, 0x3f} // 55 U
,{0x1f, 0x20, 0x40, 0x20, 0x1f} // 56 V
,{0x3f, 0x40, 0x38, 0x40, 0x3f} // 57 W
,{0x63, 0x14, 0x08, 0x14, 0x63} // 58 X
,{0x07, 0x08, 0x70, 0x08, 0x07} // 59 Y
,{0x61, 0x51, 0x49, 0x45, 0x43} // 5a Z
,{0x00, 0x7f, 0x41, 0x41, 0x00} // 5b [
,{0x02, 0x04, 0x08, 0x10, 0x20} // 5c ¥
,{0x00, 0x41, 0x41, 0x7f, 0x00} // 5d ]
,{0x04, 0x02, 0x01, 0x02, 0x04} // 5e ^
,{0x40, 0x40, 0x40, 0x40, 0x40} // 5f _
,{0x00, 0x01, 0x02, 0x04, 0x00} // 60 `
,{0x20, 0x54, 0x54, 0x54, 0x78} // 61 a
,{0x7f, 0x48, 0x44, 0x44, 0x38} // 62 b
,{0x38, 0x44, 0x44, 0x44, 0x20} // 63 c
,{0x38, 0x44, 0x44, 0x48, 0x7f} // 64 d
,{0x38, 0x54, 0x54, 0x54, 0x18} // 65 e
,{0x08, 0x7e, 0x09, 0x01, 0x02} // 66 f
,{0x0c, 0x52, 0x52, 0x52, 0x3e} // 67 g
,{0x7f, 0x08, 0x04, 0x04, 0x78} // 68 h
,{0x00, 0x44, 0x7d, 0x40, 0x00} // 69 i
,{0x20, 0x40, 0x44, 0x3d, 0x00} // 6a j 
,{0x7f, 0x10, 0x28, 0x44, 0x00} // 6b k
,{0x00, 0x41, 0x7f, 0x40, 0x00} // 6c l
,{0x7c, 0x04, 0x18, 0x04, 0x78} // 6d m
,{0x7c, 0x08, 0x04, 0x04, 0x78} // 6e n
,{0x38, 0x44, 0x44, 0x44, 0x38} // 6f o
,{0x7c, 0x14, 0x14, 0x14, 0x08} // 70 p
,{0x08, 0x14, 0x14, 0x18, 0x7c} // 71 q
,{0x7c, 0x08, 0x04, 0x04, 0x08} // 72 r
,{0x48, 0x54, 0x54, 0x54, 0x20} // 73 s
,{0x04, 0x3f, 0x44, 0x40, 0x20} // 74 t
,{0x3c, 0x40, 0x40, 0x20, 0x7c} // 75 u
,{0x1c, 0x20, 0x40, 0x20, 0x1c} // 76 v
,{0x3c, 0x40, 0x30, 0x40, 0x3c} // 77 w
,{0x44, 0x28, 0x10, 0x28, 0x44} // 78 x
,{0x0c, 0x50, 0x50, 0x50, 0x3c} // 79 y
,{0x44, 0x64, 0x54, 0x4c, 0x44} // 7a z
,{0x00, 0x08, 0x36, 0x41, 0x00} // 7b {
,{0x00, 0x00, 0x7f, 0x00, 0x00} // 7c |
,{0x00, 0x41, 0x36, 0x08, 0x00} // 7d }
,{0x10, 0x08, 0x08, 0x10, 0x08} // 7e ←
,{0x78, 0x46, 0x41, 0x46, 0x78} // 7f →
};

#define PIN_SCE   22 //Pin 3 on LCD
#define PIN_RESET 23 //Pin 4 on LCD
#define PIN_DC    24 //Pin 5 on LCD
#define PIN_SDIN  25 //Pin 6 on LCD
#define PIN_SCLK  26 //Pin 7 on LCD

#define LCD_C     LOW
#define LCD_D     HIGH

#define LCD_X     84
#define LCD_Y     48
#define LCD_CMD   0

void LcdCharacter(char character)
{
  LcdWrite(LCD_D, 0x00);
  for (int index = 0; index < 5; index++)
  {
    LcdWrite(LCD_D, ASCII[character - 0x20][index]);
  }
  LcdWrite(LCD_D, 0x00);
}

void LcdClear(void)
{
  for (int index = 0; index < LCD_X * LCD_Y / 8; index++)
  {
    LcdWrite(LCD_D, 0x00);
  }
}

void LcdInitialise(void)
{
  pinMode(PIN_SCE,   OUTPUT);
  pinMode(PIN_RESET, OUTPUT);
  pinMode(PIN_DC,    OUTPUT);
  pinMode(PIN_SDIN,  OUTPUT);
  pinMode(PIN_SCLK,  OUTPUT);

  digitalWrite(PIN_RESET, LOW);
 // delay(1);
  digitalWrite(PIN_RESET, HIGH);

  LcdWrite( LCD_CMD, 0x21 );  // LCD Extended Commands.
  LcdWrite( LCD_CMD, 0xBf );  // Set LCD Vop (Contrast). //B1
  LcdWrite( LCD_CMD, 0x04 );  // Set Temp coefficent. //0x04
  LcdWrite( LCD_CMD, 0x14 );  // LCD bias mode 1:48. //0x13
  LcdWrite( LCD_CMD, 0x0C );  // LCD in normal mode. 0x0d for inverse
  LcdWrite(LCD_C, 0x20);
  LcdWrite(LCD_C, 0x0C);
}

void LcdString(char *characters)
{
  while (*characters)
  {
    LcdCharacter(*characters++);
  }
}

void LcdWrite(byte dc, byte data)
{
  digitalWrite(PIN_DC, dc);
  digitalWrite(PIN_SCE, LOW);
  shiftOut(PIN_SDIN, PIN_SCLK, MSBFIRST, data);
  digitalWrite(PIN_SCE, HIGH);
}

// gotoXY routine to position cursor 
// x - range: 0 to 84
// y - range: 0 to 5

void gotoXY(int x, int y)
{
  LcdWrite( 0, 0x80 | x);  // Column.
  LcdWrite( 0, 0x40 | y);  // Row.  

}

void knob1() {
  knob1RawValue = round(analogRead(knob1Pin)/8);
  if(knob1RawValue > knob1Value+1 || knob1RawValue < knob1Value) { 
  knob1Value = knob1RawValue;
  Serial.print(knob1RawValue);
  analogWrite(12, 255-(round(knob1RawValue*2)));
  gotoXY(0,1);
  char k1tv[5];
  itoa (127-knob1RawValue, k1tv, 10);
  LcdString(" Knob1: ");
  LcdString(k1tv);
  LcdString("   ");
  }
  else
  {
  Serial.print(128);
  }
}

void knob2() {
  knob2RawValue = round(analogRead(knob2Pin)/8);
  if(knob2RawValue > knob2Value || knob2RawValue < knob2Value) { 
  knob2Value = knob2RawValue;
  Serial.print(knob2RawValue);
  analogWrite(11, 255-(round(knob2RawValue*2)));
  }
  else
  {
  Serial.print(128);
  }
}

void knob3() {
  knob3RawValue = round(analogRead(knob3Pin)/8);
  if(knob3RawValue > knob3Value || knob3RawValue < knob3Value) { 
  knob3Value = knob3RawValue;
  Serial.print(knob3RawValue);
  analogWrite(10, round(knob3RawValue*2));
  }
  else
  {
  Serial.print(128);
  }
}

void knob4() {
  knob4RawValue = round(analogRead(knob4Pin)/8);
  if(knob4RawValue > knob4Value || knob4RawValue < knob4Value) { 
  knob4Value = knob4RawValue;
  Serial.print(knob4RawValue);
  analogWrite(9, round(knob4RawValue*2));
  }
  else
  {
  Serial.print(128);
  }
}

void rotaryDialStatus() {
  rotaryStatus = digitalRead(3);
  Serial.print(rotaryStatus);
}

void rotaryDialImpulse() {
  dialImpulse = digitalRead(2);
  Serial.println(dialImpulse);
}

void button1() {
  button1RawValue = digitalRead(button1Pin);
  if(button1RawValue > button1Value || button1RawValue < button1Value) { 
  button1Value = button1RawValue;
  Serial.print(button1RawValue);
  }
  else
  {
  Serial.print(128);
  }
}

void button2() {
  button2RawValue = digitalRead(button2Pin);
  if(button1RawValue > button2Value || button2RawValue < button2Value) { 
  button2Value = button2RawValue;
  Serial.print(button2RawValue);
  }
  else
  {
  Serial.print(128);
  }
}

void on(int pin) {
  digitalWrite(pin, HIGH);
}

void off(int pin) {
  digitalWrite(pin, LOW);
}

void setup()   
{
 Serial.begin(115200);
 LcdInitialise();
 pinMode(13, OUTPUT);
 pinMode(12, OUTPUT);
 pitchAntenna.set_CS_AutocaL_Millis(0xFFFFFFFF);
}

void loop()                     
{
  int master = Serial.read();
  if(master == 'A') {
  on(vua);
  //on(vub);
  //on(vuc);
  on(vud);
  on(vue);
  on(vuf);
  on(vug);
  on(vuh);
  on(vui);
  on(vuj);
  on(vuk);
  }
  else if(master == 'B') {
  analogWrite(8, 25);
  analogWrite(9, 225);
  }
  else if(master == 'C') {
  analogWrite(8, 50);
  analogWrite(9, 200);
  }
  else if(master == 'D') {
  analogWrite(8, 75);
  analogWrite(9, 175);
  }
  else if(master == 'E') {
  analogWrite(8, 100);
  analogWrite(9, 150);
  }
  else if(master == 'F') {
  analogWrite(8, 125);
  analogWrite(9, 125);
  }
  else if(master == 'G') {
  analogWrite(8, 150);
  analogWrite(9, 100);
  }
  else if(master == 'H') {
  analogWrite(8, 175);
  analogWrite(9, 75);
  }
  else if(master == 'I') {
  analogWrite(8, 200);
  analogWrite(9, 50);
  }
  else if(master == 'J') {
  analogWrite(8, 225);
  analogWrite(9, 25);
  }
  else if(master == 'K') {
  analogWrite(8, 255);
  analogWrite(9, 0);
  }
  long pitch =  pitchAntenna.capSense(30);
  //long level =  levelAntenna.capSense(30);
  int level = 0;
  //int pitch = 0;
  char pitchChar[5];
  itoa (round((pitch + newPitch) / 2), pitchChar, 10);
  if(pitch > 50) {
  gotoXY(0,3);
  LcdString(" Pitch: ");
  LcdString(pitchChar);
  LcdString("    ");
  Serial.print(pitch);
  analogWrite(13, pitch/2);
  }
  else {
  Serial.print(128);
  analogWrite(13, 255);
  }
  Serial.print(",");
  Serial.print(level);
  Serial.print(",");
  knob1();
  Serial.print(",");
  knob2();
  Serial.print(",");
  knob3();
  Serial.print(",");
  knob4();
  Serial.print(",");
  rotaryDialStatus();
  Serial.print(",");
  rotaryDialImpulse();
  //Serial.print(",");
  //knob5();
  //Serial.print(",");
  //knob6();
  newPitch = pitch;
}
