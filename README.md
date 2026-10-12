# Arduino UNO R4 WiFi experiments

My collection of projects and small tests while working through the Arduino
UNO R4 WiFi starter kit. Each experiment has its own sketch, circuit diagram,
and notes. Shared commands handle compiling and uploading.

## Projects

| Project | What it does | Status |
| --- | --- | --- |
| [Spaceship Interface](projects/spaceship-interface/README.md) | Green ready light; holding the button alternates two red LEDs. | Implemented; hardware check pending. |
| [LED matrix message](projects/blink/README.md) | Scrolls **GOOD NIGHT** across the built-in matrix. | Implemented; compile checked. |

### Spaceship Interface — proposed circuit

```mermaid
flowchart LR
    D3["UNO D3"] ---|"anode (+)"| GREEN["Green LED"]
    GREEN ---|"cathode (-)"| R3["1 kΩ"]
    R3 --- GND["UNO GND"]

    D4["UNO D4"] ---|"anode (+)"| RED1["Red LED 1"]
    RED1 ---|"cathode (-)"| R4["1 kΩ"]
    R4 --- GND

    D5["UNO D5"] ---|"anode (+)"| RED2["Red LED 2"]
    RED2 ---|"cathode (-)"| R5["1 kΩ"]
    R5 --- GND

    V5["UNO 5V"] --- BUTTON["Normally open pushbutton"]
    BUTTON --- SIGNAL(("Junction"))
    D2["UNO D2: INPUT"] --- SIGNAL
    SIGNAL --- PULLDOWN["10 kΩ pull-down"]
    PULLDOWN --- GND

    classDef green fill:#dcfce7,stroke:#15803d,color:#14532d
    classDef red fill:#fee2e2,stroke:#b91c1c,color:#7f1d1d
    class GREEN green
    class RED1,RED2 red
```

[Components, pin connections, and project status →](projects/spaceship-interface/README.md)

### LED matrix message — connections

```mermaid
flowchart LR
    COMPUTER["Computer"] ---|"USB data cable: power + upload"| BOARD["Arduino UNO R4 WiFi"]
    BOARD ---|"built-in connection"| MATRIX["12 × 8 LED matrix"]
```

[Project notes and upload instructions →](projects/blink/README.md)

## Getting started

You need an **Arduino UNO R4 WiFi**, a USB data cable, and either
[Arduino CLI](https://docs.arduino.cc/arduino-cli/getting-started/) with `make`,
or the [Arduino IDE](https://docs.arduino.cc/software/ide/).
The shell wrapper and Makefile are intended for macOS/Linux.

From the repository root, install the board core and libraries:

```sh
make setup
make boards
```

`make setup` requires internet access. Copy your board's port from
`make boards`, then compile and upload:

```sh
make compile PROJECT=spaceship-interface
make upload PROJECT=spaceship-interface PORT=/dev/cu.usbmodem123
```

Replace the example port with your own (on Linux, it may look like
`/dev/ttyACM0`). Uploading replaces the sketch currently on the board.
The Spaceship Interface sketch lights the green LED while the button is
released and alternates the red LEDs while it is held.

To run the matrix test:

```sh
make compile PROJECT=blink
make upload PROJECT=blink PORT=/dev/cu.usbmodem123
```

You can also open a project's `.ino` file in Arduino IDE, install the
**Arduino UNO R4 Boards** package, select **Arduino UNO R4 WiFi**, and choose
your port. For the matrix test, also install **ArduinoGraphics** through
Library Manager.

## Commands

| Command | Purpose |
| --- | --- |
| `make projects` | List available projects. |
| `make compile PROJECT=<name>` | Compile one project for UNO R4 WiFi. |
| `make upload PROJECT=<name> PORT=<port>` | Compile and upload one project. |
| `make boards` | List connected boards and ports. |
| `make monitor PORT=<port>` | Open the serial monitor at 115200 baud. |

Omitting `PROJECT` selects `spaceship-interface`. When using the serial
monitor, match its baud rate with `Serial.begin(115200)` in your sketch.

## Repository layout

```text
projects/
  spaceship-interface/
    spaceship-interface.ino
    README.md
  blink/
    blink.ino
    README.md
scripts/arduino                 # Arduino CLI wrapper
Makefile                       # Shared project commands
```

To add a project:

1. Create `projects/my-test/my-test.ino` with `setup()` and `loop()` functions.
   The main sketch filename must match its folder name.
2. Add a project `README.md` with components, wiring, behavior, and observations.
3. Write wiring diagrams in fenced `mermaid` blocks inside the README.
   For optional circuit photos, use an `images/` folder and relative links.
4. Run `make compile PROJECT=my-test`, then upload with the same project name.
5. Add the project to the table above. No Makefile changes are needed.

## Local files

`scripts/arduino` keeps downloaded board packages, libraries, caches, and
builds in the ignored `.arduino/` directory. Each project builds separately
in `.arduino/build/<project>/`. Use this wrapper instead of `arduino-cli`
for additional CLI commands in this repository.

The ignore rules also exclude generated firmware, editor settings, `.env`
files, and `arduino_secrets.h`. For future Wi-Fi projects, keep credentials
in an ignored `arduino_secrets.h` beside the sketch and commit an
`arduino_secrets.example.h` with placeholders for others to copy.

The wiring diagrams are Mermaid text embedded directly in the READMEs.
[GitHub renders these blocks as diagrams](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams#creating-mermaid-diagrams).
Edit the text to change a connection or component label. The diagrams show
logical connections; use the pin tables for wiring and component polarity.

## References

- [Arduino UNO R4 WiFi documentation](https://docs.arduino.cc/hardware/uno-r4-wifi/)
- [UNO R4 WiFi datasheet](https://docs.arduino.cc/resources/datasheets/ABX00087-datasheet.pdf)
- [Built-in LED matrix guide](https://docs.arduino.cc/tutorials/uno-r4-wifi/led-matrix/)
