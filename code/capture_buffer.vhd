-- capture_buffer.vhd
--
-- Buffer de captura, acessível via Avalon-MM slave, para ser lido pelo PC
-- através do "JTAG to Avalon Master Bridge" + System Console (Tcl).
-- Não depende do Nios II EDS nem do JTAG UART -- usa apenas IPs que já
-- vêm na instalação base do Quartus.
--
-- Mapa de endereços (av_address tem BUFFER_ADDR_BITS+1 bits):
--   bit mais significativo de av_address = '0'  -> registrador de CONTROLE/STATUS
--     escrita: bit0 = '1' inicia uma nova captura (reseta ponteiro, limpa "done")
--     leitura: bit0 = capturing (1 = capturando agora)
--              bit1 = done      (1 = buffer cheio, pronto para leitura)
--   bit mais significativo de av_address = '1'  -> acesso à MEMÓRIA
--     os bits restantes de av_address indexam a posição (0 a BUFFER_SIZE-1)
--     cada palavra lida contém 1 byte capturado do TRNG no byte menos
--     significativo (os outros 24 bits vêm como '0')
--
-- Funcionamento:
--   1) O host escreve 1 no registrador de controle -> começa a capturar
--   2) A cada pulso em data_valid (1 byte pronto vindo do shift register
--      externo), o byte é gravado na próxima posição livre da memória
--   3) Quando o buffer enche, "done" sobe e a captura para sozinha
--   4) O host lê "done", e se estiver em 1, faz a leitura em burst de toda
--      a memória (endereços 1 a BUFFER_SIZE) via System Console
--   5) O host escreve 1 de novo no controle para iniciar a próxima captura

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity capture_buffer is
	generic(
		BUFFER_ADDR_BITS : integer := 13);  -- 2^13 = 8192 bytes de buffer
	port(
		clk       : in  std_logic;
		reset     : in  std_logic;

		-- Entrada de dados vinda do shift register do TRNG
		data_in    : in  std_logic_vector(7 downto 0);
		data_valid : in  std_logic;  -- pulso de 1 ciclo: "1 byte pronto"

		-- Interface Avalon-MM slave (acessada pelo JTAG to Avalon Master Bridge)
		av_chipselect  : in  std_logic;
		av_address     : in  std_logic_vector(BUFFER_ADDR_BITS downto 0);
		av_read_n      : in  std_logic;
		av_write_n     : in  std_logic;
		av_writedata   : in  std_logic_vector(31 downto 0);
		av_readdata    : out std_logic_vector(31 downto 0);
		av_waitrequest : out std_logic
	);
end entity;

architecture rtl of capture_buffer is

	constant BUFFER_SIZE : integer := 2**BUFFER_ADDR_BITS;

	type mem_t is array (0 to BUFFER_SIZE-1) of std_logic_vector(7 downto 0);
	signal mem : mem_t := (others => (others => '0'));

	signal writePtr  : unsigned(BUFFER_ADDR_BITS-1 downto 0) := (others => '0');
	signal capturing : std_logic := '0';
	signal done      : std_logic := '0';

	signal isMemAccess : std_logic;
	signal memIndex    : unsigned(BUFFER_ADDR_BITS-1 downto 0);

begin

	-- Sem wait states: leitura/escrita resolvidas no mesmo ciclo
	av_waitrequest <= '0';

	isMemAccess <= av_address(BUFFER_ADDR_BITS);
	memIndex    <= unsigned(av_address(BUFFER_ADDR_BITS-1 downto 0));

	------------------------------------------------------------------
	-- Captura dos bytes do TRNG na memória
	------------------------------------------------------------------
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				capturing <= '0';
				done      <= '0';
				writePtr  <= (others => '0');
			else

				-- Início de nova captura, disparado pelo host via Avalon
				if av_chipselect = '1' and av_write_n = '0' and isMemAccess = '0' then
					if av_writedata(0) = '1' then
						capturing <= '1';
						done      <= '0';
						writePtr  <= (others => '0');
					end if;
				end if;

				-- Grava byte a byte enquanto estiver capturando
				if capturing = '1' and data_valid = '1' then
					mem(to_integer(writePtr)) <= data_in;
					if writePtr = BUFFER_SIZE-1 then
						capturing <= '0';
						done      <= '1';
					else
						writePtr <= writePtr + 1;
					end if;
				end if;

			end if;
		end if;
	end process;

	------------------------------------------------------------------
	-- Leitura Avalon-MM (combinacional, latência 0)
	------------------------------------------------------------------
	process(av_chipselect, av_read_n, isMemAccess, memIndex, mem, capturing, done)
	begin
		av_readdata <= (others => '0');
		if av_chipselect = '1' and av_read_n = '0' then
			if isMemAccess = '1' then
				av_readdata <= (31 downto 8 => '0') & mem(to_integer(memIndex));
			else
				av_readdata <= (31 downto 2 => '0') & done & capturing;
			end if;
		end if;
	end process;

end architecture rtl;