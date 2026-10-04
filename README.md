# 4-Floor FPGA Elevator Controller

A **4-floor elevator control system implemented in VHDL for FPGA**, using a finite state machine (FSM) to manage floor requests, elevator movement, door operation, and emergency conditions.

## Features

* 4-floor elevator control
* Finite State Machine based operation
* Floor request storage and management
* Automatic upward/downward movement
* Door-open timing
* Door button control
* Emergency-stop handling
* Physical alarm output
* Floor indication LEDs
* Seven-segment floor display
* Seven-segment FSM state display
* Quartus and ModelSim simulation support

## System Architecture

The design is divided into independent VHDL modules:

```text
SEC
├── FSM_Controller
├── Request_Register
├── FloorCounter
├── Door_Timer
├── OutputController
├── SevenSegDecoder
└── StateSegDecoder
```

The **FSM Controller** acts as the main control unit. It processes floor requests and system inputs and determines whether the elevator should remain idle, move up/down, operate the doors, or enter emergency mode.

### FSM States

| State        | Description             |
| ------------ | ----------------------- |
| `IDLE`       | Waiting for a request   |
| `UP`         | Moving upward           |
| `DOWN`       | Moving downward         |
| `DOOR_OPEN`  | Doors are open          |
| `DOOR_CLOSE` | Door-closing transition |
| `EMERGENCY`  | Emergency condition     |

## Request Handling

Four floor buttons generate requests that are stored in a 4-bit request register:

```text
Request[3] → Floor 3
Request[2] → Floor 2
Request[1] → Floor 1
Request[0] → Floor 0
```

Requests remain pending until the elevator reaches the requested floor, after which the corresponding request is cleared.

## Displays and Indicators

The system provides visual feedback through LEDs and seven-segment displays.

* **Floor display:** Shows the current floor (`0–3`)
* **State display:** Indicates the current FSM state
* **Floor LEDs:** Indicate the elevator's current floor
* **Door LED:** Indicates when the doors are open
* **Alarm:** Activated during emergency operation

## Hardware & Software

* **HDL:** VHDL
* **FPGA:** Cyclone IV E `EP4CE115F29C7`
* **Software:** Intel/Altera Quartus II 13.1
* **Simulation:** ModelSim-Altera

## Project Files

| File                   | Description               |
| ---------------------- | ------------------------- |
| `SEC.vhd`              | Top-level module          |
| `FSM_Controller.vhd`   | Elevator FSM              |
| `Request_Register.vhd` | Floor request storage     |
| `FloorCounter.vhd`     | Current floor tracking    |
| `Door_Timer.vhd`       | Door timing               |
| `OutputController.vhd` | LEDs and alarm control    |
| `SevenSegDecoder.vhd`  | Floor display decoder     |
| `StateSegDecoder.vhd`  | FSM state display decoder |
| `SEC.qpf`              | Quartus project           |
| `SEC.qsf`              | FPGA/pin configuration    |
| `Waveform.vwf`         | Simulation waveform       |

## Operation

The basic operating sequence is:

```text
Floor Request
     ↓
Request Register
     ↓
FSM Determines Direction
     ↓
Elevator Moves
     ↓
Requested Floor Reached
     ↓
Doors Open
     ↓
Door Timer
     ↓
Doors Close
     ↓
Next Request / IDLE
```

An emergency input can interrupt normal operation and place the controller into the `EMERGENCY` state.

## Simulation

The repository includes Quartus waveform files and ModelSim simulation files under:

```text
simulation/qsim/
```

These can be used to verify FSM transitions, floor movement, request handling, door timing, and emergency behavior.

## Purpose

This project demonstrates the implementation of a real-world sequential control system using **VHDL, FSM design, synchronous counters, registers, timing logic, and FPGA peripherals**.
