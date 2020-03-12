---
layout: page
title: "10T Based 0.34V Supply Low Energy 16x4 SRAM"
date: 2014-08-20 09:11
comments: true
sharing: true
footer: true
#categories:
#- Completed Projects
tags:
- Completed Projects
- VLSI
- SRAM
---

This was a 3-person group project in our VLSI course. This page contains sections and images taken from the final project report to provide a quick summary of the project. 

### Summary

The design presented is a 64 bit (16x4) synchronous SRAM with a heavy focus on low energy operations.  Specifically, the optimization metric which drives the design is the energy-cubed-delay product (E3D). The main approach in reducing energy is by utilizing a 10 transistor memory bitcell instead of the traditional 6T bitcell in order to reduce leakage current. The 10T bitcell also isolates the read port from the cross-coupled inverters. This prevents accidental writing during a read operation, thus enhancing read static noise margins. Another major effort in reducing energy is to use minimum-sized transistors as much as possible to lower overall capacitances, thus reducing energy cost.

The optimal voltage and clock period was determined by attempting to run the circuit at different voltages. At each voltage point, the clock period was reduced until the simulation would no longer work for the test vectors. The provided us with the optimal energy and delay for that voltage. The total simulation time and the measured energy were then used to calculate the E3D metric. The best E3D metric was found at 0.34 V.

<!-- Images -->
{% imgcap center http://i.imgur.com/zEztHIN.png?1 Block Diagram %}
<p>
{% imgcap center http://i.imgur.com/srV8IAD.png?1 Final Top Level %}
<p>
{% imgcap center http://i.imgur.com/NyO0FP6.png?1 10T Bitcell %}
<p>
{% imgcap center http://i.imgur.com/nKWJ2N6.png?1 TSPC Neg. Edge Flip-Flop %}
<p>
{% imgcap center http://i.imgur.com/HEvRb8e.png?2 Bitline Conditioning %}
<p>
{% imgcap center http://i.imgur.com/vzaFHJ5.png?1 Row Decoder %}
<p>
{% imgcap center http://i.imgur.com/8cwNLd2.png?1 Column Decoder %}
<p>

### Result Statistics
	Max Clock Frequency: 	166.67 MHz (6ns clock period)
	Supply Voltage: 		0.34 V
	Total Energy:			0.363 pJ
	Transistors:			976
	Area:					387.43 µm2
	Transistors/Area:		2.52 transistors per µm2
	Design Time (Estimate):	140 hours


### Project Completion: 12/2013