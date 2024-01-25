library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity LoadVectorFSM is
	generic(
		numfaces : integer
	);
	port(
		clk,clr,go,gonext : in STD_LOGIC;
		incVectReg : out std_logic;
		ldVectReg  : out std_logic;
		incFaceReg : out std_logic;
		ldFaceReg  : out std_logic;
		load	   : out std_logic_vector(8 downto 0);
		ready, readynext  : out std_logic
	);
end LoadVectorFSM;
architecture LoadVectorFSM of LoadVectorFSM is 
	type state_type is (start, updateVecAddr, waitDataValid, storeVecValue, incK, testK, incVecAddr, incJ, testJ, incI, testI, waitNext, done);
	signal present_state, next_state: state_type;
	shared variable i, j, k : integer :=0;
begin

sreg: process(clk, clr)
begin
  if clr = '1' then
		present_state <= start;
  elsif clk'event and clk = '1' then
    	present_state <= next_state;
  end if;
end process;

state_transitions: process(present_state, go, gonext)
begin
   case present_state is
	    when start =>
	  	if go = '1' then
	    		next_state <= updateVecAddr;
	  	else
	    		next_state <= start;
	  	end if;
		when updateVecAddr =>
			next_state <= waitDataValid;
        when waitDataValid =>
            next_state <= storeVecValue;     
		when storeVecValue =>
			next_state <= incK;
		when incK =>
			next_state <= testK;
		when testK =>
			if k < 3 then
				next_state <= incVecAddr;
			else
				next_state <= incJ;
			end if;
		when incVecAddr =>
			next_state <= waitDataValid;
		when incJ =>
			next_state <= testJ;
		when testJ =>
			if j < 3 then
				next_state <= updateVecAddr;
			else
				next_state <= incI;
			end if;
		when incI =>
			next_state <= testI;
		when testI =>
			if i < numfaces then
				next_state <= waitNext;
			else
				next_state <= done;
			end if;
		when waitNext =>
			if gonext = '1' then
				next_state <= updateVecAddr;
			else
				next_state <= waitNext;
			end if;
		when done =>
			if go = '1' then
				next_state <= done;
			else
				next_state <= start;
			end if;
		when others =>
			null;
	end case;
end process;

state_conditions: process(present_state)
begin
    --defaults:
    incVectReg <= '0';
    ldVectReg  <= '0';
    incFaceReg <= '0';
    ldFaceReg  <= '0';
    ready      <= '0';
    readynext  <= '0';
    load	   <= (others => '0');
    --end defaults
	case present_state is
		when start =>
			i := 0;
			j := 0;
			k := 0;
			ldFaceReg <= '1';
			ready <= '1';
		when updateVecAddr =>
			 ldVectReg <= '1';
		when storeVecValue =>
			load((3*j)+k) <= '1';
		when incK =>
			k := k + 1;
		when testK =>
			null;
		when incVecAddr =>
			incVectReg <= '1';
		when incJ =>
			j := j + 1;
			incFaceReg <= '1';
			k := 0;
		when testJ =>
			null;
		when incI =>
			i := i + 1;
			j := 0;
		when testI =>
			null;
		when waitNext =>
			readynext <= '1';
		when done =>
			null;
		when others =>
			null;
	end case;
end process;
end LoadVectorFSM;