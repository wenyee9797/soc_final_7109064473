############################
# Tetris             #
############################

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN T22 [get_ports {score[7]}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {score[6]}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {score[5]}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {score[4]}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {score[3]}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {score[2]}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {score[1]}];  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {score[0]}];  # "LD7"

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y21  [get_ports {color_out[0]}];  # "VGA-B1"
set_property PACKAGE_PIN Y20  [get_ports {color_out[1]}];  # "VGA-B2"
set_property PACKAGE_PIN AB20 [get_ports {color_out[2]}];  # "VGA-B3"
set_property PACKAGE_PIN AB19 [get_ports {color_out[3]}];  # "VGA-B4"

set_property PACKAGE_PIN AB22 [get_ports {color_out[4]}];  # "VGA-G1"
set_property PACKAGE_PIN AA22 [get_ports {color_out[5]}];  # "VGA-G2"
set_property PACKAGE_PIN AB21 [get_ports {color_out[6]}];  # "VGA-G3"
set_property PACKAGE_PIN AA21 [get_ports {color_out[7]}];  # "VGA-G4"

set_property PACKAGE_PIN V20  [get_ports {color_out[8]}];  # "VGA-R1"
set_property PACKAGE_PIN U20  [get_ports {color_out[9]}];  # "VGA-R2"
set_property PACKAGE_PIN V19  [get_ports {color_out[10]}];  # "VGA-R3"
set_property PACKAGE_PIN V18  [get_ports {color_out[11]}];  # "VGA-R4"

set_property PACKAGE_PIN AA19 [get_ports {hsync}];  # "VGA-HS"
set_property PACKAGE_PIN Y19  [get_ports {vsync}];  # "VGA-VS"

set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]]

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN P16 [get_ports {rst}];  # "BTNM"
set_property PACKAGE_PIN R16 [get_ports {up}];  # "BTND"
set_property PACKAGE_PIN N15 [get_ports {right}];  # "BTNL"
set_property PACKAGE_PIN R18 [get_ports {left}];  # "BTNR"
set_property PACKAGE_PIN T18 [get_ports {down}];  # "BTNU"

set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y9 [get_ports {clk}];  # "CLK"

set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
