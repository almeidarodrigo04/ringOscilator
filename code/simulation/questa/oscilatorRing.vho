-- Copyright (C) 2025  Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Altera and sold by Altera or its authorized distributors.  Please
-- refer to the Altera Software License Subscription Agreements 
-- on the Quartus Prime software download page.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 25.1std.0 Build 1129 10/21/2025 SC Lite Edition"

-- DATE "08/27/2026 11:18:05"

-- 
-- Device: Altera 5CEBA4F23C7 Package FBGA484
-- 

-- 
-- This VHDL file should be used for Questa Altera FPGA (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	ringsManager IS
    PORT (
	clk : IN std_logic;
	output : OUT std_logic
	);
END ringsManager;

-- Design Ports Information
-- output	=>  Location: PIN_P18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_P17,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF ringsManager IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_output : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \WideXor0~combout\ : std_logic;
SIGNAL \output~reg0_q\ : std_logic;
SIGNAL \genRings:2:oscRing|step\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \genRings:0:oscRing|step\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \genRings:1:oscRing|step\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \genRings:2:oscRing|ALT_INV_step\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \genRings:1:oscRing|ALT_INV_step\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \genRings:0:oscRing|ALT_INV_step\ : std_logic_vector(2 DOWNTO 0);

BEGIN

ww_clk <= clk;
output <= ww_output;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\genRings:2:oscRing|ALT_INV_step\(0) <= NOT \genRings:2:oscRing|step\(0);
\genRings:1:oscRing|ALT_INV_step\(0) <= NOT \genRings:1:oscRing|step\(0);
\genRings:0:oscRing|ALT_INV_step\(0) <= NOT \genRings:0:oscRing|step\(0);
\genRings:2:oscRing|ALT_INV_step\(1) <= NOT \genRings:2:oscRing|step\(1);
\genRings:1:oscRing|ALT_INV_step\(1) <= NOT \genRings:1:oscRing|step\(1);
\genRings:0:oscRing|ALT_INV_step\(1) <= NOT \genRings:0:oscRing|step\(1);
\genRings:2:oscRing|ALT_INV_step\(2) <= NOT \genRings:2:oscRing|step\(2);
\genRings:1:oscRing|ALT_INV_step\(2) <= NOT \genRings:1:oscRing|step\(2);
\genRings:0:oscRing|ALT_INV_step\(2) <= NOT \genRings:0:oscRing|step\(2);

-- Location: IOOBUF_X54_Y17_N56
\output~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \output~reg0_q\,
	devoe => ww_devoe,
	o => ww_output);

-- Location: IOIBUF_X54_Y17_N21
\clk~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: LABCELL_X53_Y17_N33
\genRings:1:oscRing|step[0]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:1:oscRing|step\(0) = LCELL(( !\genRings:1:oscRing|step\(2) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:1:oscRing|ALT_INV_step\(2),
	combout => \genRings:1:oscRing|step\(0));

-- Location: LABCELL_X53_Y17_N15
\genRings:1:oscRing|step[1]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:1:oscRing|step\(1) = LCELL(( !\genRings:1:oscRing|step\(0) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:1:oscRing|ALT_INV_step\(0),
	combout => \genRings:1:oscRing|step\(1));

-- Location: LABCELL_X53_Y17_N12
\genRings:1:oscRing|step[2]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:1:oscRing|step\(2) = LCELL(( !\genRings:1:oscRing|step\(1) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:1:oscRing|ALT_INV_step\(1),
	combout => \genRings:1:oscRing|step\(2));

-- Location: LABCELL_X53_Y17_N27
\genRings:2:oscRing|step[0]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:2:oscRing|step\(0) = LCELL(( !\genRings:2:oscRing|step\(2) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:2:oscRing|ALT_INV_step\(2),
	combout => \genRings:2:oscRing|step\(0));

-- Location: LABCELL_X53_Y17_N51
\genRings:2:oscRing|step[1]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:2:oscRing|step\(1) = LCELL(( !\genRings:2:oscRing|step\(0) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:2:oscRing|ALT_INV_step\(0),
	combout => \genRings:2:oscRing|step\(1));

-- Location: LABCELL_X53_Y17_N48
\genRings:2:oscRing|step[2]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:2:oscRing|step\(2) = LCELL(( !\genRings:2:oscRing|step\(1) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:2:oscRing|ALT_INV_step\(1),
	combout => \genRings:2:oscRing|step\(2));

-- Location: LABCELL_X53_Y17_N24
\genRings:0:oscRing|step[0]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:0:oscRing|step\(0) = LCELL(( !\genRings:0:oscRing|step\(2) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:0:oscRing|ALT_INV_step\(2),
	combout => \genRings:0:oscRing|step\(0));

-- Location: LABCELL_X53_Y17_N9
\genRings:0:oscRing|step[1]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:0:oscRing|step\(1) = LCELL(( !\genRings:0:oscRing|step\(0) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:0:oscRing|ALT_INV_step\(0),
	combout => \genRings:0:oscRing|step\(1));

-- Location: LABCELL_X53_Y17_N6
\genRings:0:oscRing|step[2]\ : cyclonev_lcell_comb
-- Equation(s):
-- \genRings:0:oscRing|step\(2) = LCELL(( !\genRings:0:oscRing|step\(1) ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \genRings:0:oscRing|ALT_INV_step\(1),
	combout => \genRings:0:oscRing|step\(2));

-- Location: LABCELL_X53_Y17_N30
WideXor0 : cyclonev_lcell_comb
-- Equation(s):
-- \WideXor0~combout\ = ( \genRings:0:oscRing|step\(2) & ( !\genRings:1:oscRing|step\(2) $ (\genRings:2:oscRing|step\(2)) ) ) # ( !\genRings:0:oscRing|step\(2) & ( !\genRings:1:oscRing|step\(2) $ (!\genRings:2:oscRing|step\(2)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011110000111100001111000011110011000011110000111100001111000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \genRings:1:oscRing|ALT_INV_step\(2),
	datac => \genRings:2:oscRing|ALT_INV_step\(2),
	dataf => \genRings:0:oscRing|ALT_INV_step\(2),
	combout => \WideXor0~combout\);

-- Location: FF_X53_Y17_N31
\output~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \WideXor0~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \output~reg0_q\);

-- Location: LABCELL_X6_Y37_N0
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


