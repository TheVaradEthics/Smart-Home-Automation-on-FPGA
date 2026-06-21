
## 🏠 Smart Home Automation Controller on FPGA

## 📌 Overview
This project implements a parameterizable home-automation controller on an FPGA that manages lighting (PWM dimming), fans (PWM speed), sockets (relays), sensors (PIR, LDR), scene presets, and safety alarms. It is designed with deterministic, low-latency control suitable for smart homes and building automation. 

This repository serves as a proof-of-concept VLSI design, providing both hardware logic (RTL) and complete virtual simulation environments.

## 🎯 Problem Statement
Modern smart homes often rely on cloud-based hubs, introducing latency, dependency on active internet connections, and subscription costs. This project provides a hardware-level, offline execution environment that safely blends local sensor telemetry with manual overrides using real-time, deterministic finite state machines.

## 🧠 VLSI Concepts Demonstrated
* **RTL Design:** Verilog module creation and top-level integration.
* **Sequential & Combinational Logic:** Debouncers, clock-enable generators, and sensor input conditioning.
* **Finite State Machines (FSM):** Priority-based Moore FSM for mode switching and hardware routing.
* **Verification:** Testbench creation, simulation modeling, and waveform analysis.
* **Synthesis:** Translating RTL into FPGA constraints and generating bitstreams.

## 🏗️ System Architecture & Logic
The controller executes a strict priority-based logic system to ensure safety and predictability:

**Priority Routing:** `ALARM > MANUAL Override > SENSOR AUTO > SCHEDULE`

* **Alarm Mode:** If overcurrent is detected, immediately force all relays to `0` (off) and force emergency lights to maximum PWM brightness (`255`).
* **Manual Mode:** User button inputs override automatic sensor states.
* **Auto Mode:** If the PIR detects motion *and* the LDR detects low light, activate lights to preset scene levels. Idle timeouts revert the system to energy-saving states.

## 📂 Folder Structure
```text
Smart-Home-Automation-FPGA/
│
├── rtl/                # Verilog source files (FSM, PWM, Debounce, Scenes)
├── tb/                 # Testbench files for behavioral simulation
├── constraints/        # XDC files for FPGA pin mapping (Nexys A7)
├── simulation/         # Compiled simulation executables
├── waveforms/          # VCD waveform dumps for GTKWave
├── scripts/            # Yosys synthesis scripts
└── README.md           # Project documentation

```

## 🛠️ Tools Required

To run this project locally, you will need the following open-source tools:

* **Icarus Verilog (`iverilog`)**: For compiling the RTL and testbench.
* **GTKWave**: For viewing the simulation waveforms.
* **Yosys**: For logic synthesis and generating utilization reports.

## 🚀 How to Run the Simulation

1. Clone the repository and navigate to the root directory.
2. Compile the design using Icarus Verilog:
```bash
iverilog -o simulation/home_sim.vvp rtl/*.v tb/home_tb.v

```


3. Execute the simulation:
```bash
vvp simulation/home_sim.vvp

```


4. Move the generated waveform to the designated folder:
```bash
mv home.vcd waveforms/

```


5. Open the waveform in GTKWave to inspect the control logic:
```bash
gtkwave waveforms/home.vcd

```


## 🔮 Future Improvements

* Integration of a zero-cross AC dimming module with triac drivers.
* I²C master and SPI ADC for clean analog sensor inputs.
* Formal verification (using SymbiYosys) to mathematically prove the safety interlocks.

