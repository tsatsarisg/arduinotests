FQBN := arduino:renesas_uno:unor4wifi
PROJECT ?= spaceship-interface
SKETCH := projects/$(PROJECT)
BUILD_DIR := $(CURDIR)/.arduino/build/$(PROJECT)
CLI := ./scripts/arduino
PORT ?=

.PHONY: setup boards projects check-project compile upload monitor

setup:
	$(CLI) core update-index
	$(CLI) core install arduino:renesas_uno
	$(CLI) lib install ArduinoGraphics

boards:
	$(CLI) board list

projects:
	@for sketch in projects/*/*.ino; do \
		[ -f "$$sketch" ] || continue; \
		project=$${sketch#projects/}; \
		project=$${project%%/*}; \
		if [ "$$sketch" = "projects/$$project/$$project.ino" ]; then printf '%s\n' "$$project"; fi; \
	done

check-project:
	@test -f "$(SKETCH)/$(PROJECT).ino" || { echo 'Unknown project: $(PROJECT). Run make projects to list available projects.'; exit 1; }

compile: check-project
	$(CLI) compile --fqbn $(FQBN) --build-path "$(BUILD_DIR)" "$(SKETCH)"

upload: compile
	@test -n "$(PORT)" || { echo 'Set PORT, e.g. make upload PROJECT=$(PROJECT) PORT=/dev/cu.usbmodem123'; exit 1; }
	$(CLI) upload --fqbn $(FQBN) --port "$(PORT)" --input-dir "$(BUILD_DIR)" "$(SKETCH)"

monitor:
	@test -n "$(PORT)" || { echo 'Set PORT, e.g. make monitor PORT=/dev/cu.usbmodem123'; exit 1; }
	$(CLI) monitor --port "$(PORT)" --config baudrate=115200
