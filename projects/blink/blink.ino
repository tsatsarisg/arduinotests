// ArduinoGraphics must be included before Arduino_LED_Matrix.
#include <ArduinoGraphics.h>
#include <Arduino_LED_Matrix.h>

ArduinoLEDMatrix matrix;

void setup() {
  matrix.begin();
}

void loop() {
  matrix.beginDraw();
  matrix.stroke(0xFFFFFFFF);
  matrix.textScrollSpeed(100);  // Milliseconds per step; higher is slower.
  matrix.textFont(Font_5x7);
  matrix.beginText(0, 1, 0xFFFFFF);
  matrix.println("    GOOD NIGHT    ");
  matrix.endText(SCROLL_LEFT);
  matrix.endDraw();

  // Pause briefly before repeating the message.
  delay(1000);
}
