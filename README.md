# CO2 Cold Gas Thruster — Design, CFD & Physical Test
<img width="1238" height="546" alt="final" src="https://github.com/user-attachments/assets/dad99a53-f466-491f-ac30-d97b121991d1" />

A converging-diverging nozzle designed from first principles for a SodaStream CO2 cylinder, validated in Ansys Fluent, and physically tested. The goal was to run the same system through three levels of analysis and understand where each one breaks down.

---

## Results

| Method | Thrust |
|---|---|
| MATLAB isentropic (ideal) | 1.23 N |
| Ansys Fluent (viscous) | 1.19 N |
| Physical test | 0.75 N |
 
The CFD-to-MATLAB gap is viscous losses — boundary layer growth and non-uniform exit velocity profile. The hardware-to-CFD gap is regulator droop (6 bar set point, 5.5 bar delivered under flow demand), resin printed surface roughness, and CO2 deviating from ideal gas behaviour at ~155 K exit temperature.

---

| Parameter | Value |
|---|---|
| Propellant | CO2 |
| Inlet pressure (design) | 6 bar |
| Inlet pressure (measured) | 5.5 bar |
| Throat diameter | 1.5 mm |
| Exit Mach number | 1.84 |
| Diverging half angle | 5° |
| Converging half angle | 30° |
| Exit temperature | ~155 K |
| Mass flow rate | ~3 g/s |
| Burn duration (425g cylinder) | ~141 s |

---

## Analytical Model (MATLAB)

<img width="1290" height="941" alt="Sim1_Analysis" src="https://github.com/user-attachments/assets/df531967-a491-463a-bb29-e978864a96ad" />

- Mach number distribution along the nozzle centreline from the isentropic solver. The throat sits at x = 0, subsonic flow on the left, supersonic on the right. Solved using fzero on both branches of the area-Mach relation.
- Thrust as a function of inlet pressure from 1 to 6 bar. Shows how performance degrades as the cylinder depletes. The design point sits at the top left of the curve.

---

## CFD (Ansys Fluent)

<img width="1238" height="546" alt="final" src="https://github.com/user-attachments/assets/e009bd9c-b178-4e0f-8e59-d686ca6b61d0" />

<img width="1222" height="532" alt="mach number cd nozzle" src="https://github.com/user-attachments/assets/a62adff5-e87f-40ad-a85b-e926d0008ea7" />

<img width="1238" height="546" alt="Temp" src="https://github.com/user-attachments/assets/83ccfca4-20dc-46af-8c54-403d73bb1d39" />

2D axisymmetric simulation in Ansys Fluent 2025 R2. k-omega SST turbulence model, CO2 ideal gas, pressure inlet at 6 bar stagnation, pressure outlet at 101,325 Pa. Exit Mach number consistent with analytical prediction at 1.84.

The boundary layer is visible along the diverging wall. CFD exit velocity came in at 388 m/s versus the theoretical 396 m/s — the 8 m/s difference accounts for the 0.04 N gap between MATLAB and Fluent predictions.

---

## Physical testing

https://github.com/user-attachments/assets/d54a0f28-d8d5-481c-8475-6a8e69996e40

Tested at 5.5 bar measured inlet pressure (set point 6 bar, drooped under ~3 g/s flow demand). Thrust measured at 0.75 N. Visible CO2 frost formed on the nozzle body during firing consistent with the predicted 155 K exit temperature.

---

## Hardware
 
- SodaStream 425g CO2 cylinder
- KegLand deluxe SodaStream adapter
- KegLand MK4 dual gauge regulator 
- PETG printed nozzle 


## Notes
 
Basically, the MATLAB model gave me the absolute best-case scenario. The real world is never that perfect. I didn't run all three methods expecting the thrust numbers to match perfectly; I just wanted to see exactly how much performance I was losing at each step and figure out which physical mechanisms (like friction) were causing it.

Setup for the Ansys Fluent 2025 R2 simulation was pretty standard: 2D axisymmetric, k-omega SST, and ideal gas CO2.

## Author

Ansh Rawat
Adrian Jalgha
