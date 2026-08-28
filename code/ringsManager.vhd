library ieee;
use ieee.std_logic_misc.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ringsManager is
	generic(
		NRINGS : integer := 114);
	port(
		clk    : in std_logic;
		output : out std_logic);
end entity;

architecture behaviour of ringsManager is
	
	signal ringsOut : std_logic_vector (NRINGS-1 downto 0);
	
	
	begin
		
		genRings: for i in 0 to NRINGS-1 generate
			oscRing: entity work.oscilatorRing generic map(NNOTS => 13 + 2*i) port map(output => ringsOut(i));
		end generate genRings;
		
		process(clk)
		begin
			if rising_edge(clk) then
				output <= xor_reduce(ringsOut);
			end if;
		end process;
		
end architecture behaviour;