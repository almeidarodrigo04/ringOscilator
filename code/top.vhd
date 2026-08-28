-- top.vhd
--
-- Top level. Instancia o sistema "jtag_bridge_system" gerado pelo
-- Platform Designer (JTAG to Avalon Master Bridge + capture_buffer),
-- com os nomes de porta EXATOS conferidos em
-- jtag_bridge_system/synthesis/jtag_bridge_system_inst.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port(
		clk : in  std_logic  -- clock físico da placa (50 MHz na DE0-CV)
	);
end entity;

architecture rtl of top is

	signal reset : std_logic := '0';

	-- Sinal de entropia gerado pelo ringsManager
	signal trngBit : std_logic;

	-- Shift register que acumula 8 bits do TRNG em 1 byte
	signal shiftReg  : std_logic_vector(7 downto 0) := (others => '0');
	signal bitCount  : unsigned(2 downto 0) := (others => '0');
	signal byteValid : std_logic := '0';

	component jtag_bridge_system is
		port(
			clk_clk                                 : in std_logic;
			reset_reset_n                           : in std_logic;
			capture_buffer_0_conduit_end_data_in    : in std_logic_vector(7 downto 0);
			capture_buffer_0_conduit_end_data_valid : in std_logic
		);
	end component;

begin

	------------------------------------------------------------------
	-- Fonte de entropia (já existente)
	------------------------------------------------------------------
	rings_inst: entity work.ringsManager
		port map(
			clk    => clk,
			output => trngBit);

	------------------------------------------------------------------
	-- Acumula 8 bits do TRNG em 1 byte
	------------------------------------------------------------------
	process(clk)
	begin
		if rising_edge(clk) then
			byteValid <= '0';  -- pulso de 1 ciclo, default

			shiftReg <= shiftReg(6 downto 0) & trngBit;
			if bitCount = 7 then
				bitCount  <= (others => '0');
				byteValid <= '1';
			else
				bitCount <= bitCount + 1;
			end if;
		end if;
	end process;

	------------------------------------------------------------------
	-- Sistema gerado pelo Platform Designer
	------------------------------------------------------------------
	bridge_sys_inst: component jtag_bridge_system
		port map(
			clk_clk                                 => clk,
			reset_reset_n                           => not reset,  -- reset do sistema é ativo baixo
			capture_buffer_0_conduit_end_data_in    => shiftReg,
			capture_buffer_0_conduit_end_data_valid => byteValid);

end architecture rtl;