library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity oscilatorRing is
	generic(
		NNOTS : integer := 3);
	port(
		output: out std_logic);
end entity;

architecture behaviour of oscilatorRing is
	signal step: std_logic_vector (NNOTS-1 downto 0);
	
	--Puramente evitando que o quartus otimize tudo para 1 NOT
	attribute syn_keep : boolean;
   attribute syn_keep of step : signal is true;
	
	begin
	
		step(0) <= not step(NNOTS-1);
		lnots: for i in 1 to NNOTS-1 generate
			step(i) <= not step(i-1);
		end generate lnots;
		output <= step(NNOTS-1);
		
end architecture behaviour;