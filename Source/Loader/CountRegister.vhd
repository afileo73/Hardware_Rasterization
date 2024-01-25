library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity CountRegister is
    generic( N : integer);
	port(
		clk, clr, ld, inc : in std_logic;
		d : in std_logic_vector(N-1 downto 0);
		q : out std_logic_vector(N-1 downto 0)
	);
end CountRegister;
architecture CountRegister of CountRegister is 
	signal temp : std_logic_vector(N-1 downto 0);
begin
	process(clk,clr)
	begin
		if clr = '1' then
			temp <= (others => '0');
		elsif clk'event and clk = '1' then
			if ld = '1' then
				temp <= d;
			elsif inc = '1' then
				temp <= temp + 1;
			end if;
		end if;
	end process;
	
	q <= temp;
end CountRegister;