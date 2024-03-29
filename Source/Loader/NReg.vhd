library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity NReg is
	 generic(N:integer := 8);
	 port(
		 load : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 d : in STD_LOGIC_VECTOR(N-1 downto 0);
		 q : out STD_LOGIC_VECTOR(N-1 downto 0)
	     );
end NReg;

architecture NReg of NReg is

begin

	process(clk, clr)
	begin
		if clr = '1' then
			q <= (others => '0');
		elsif rising_edge(clk) then
			if load = '1' then
				q <= d;
			end if;
		end if;
	end process;

end NReg;

