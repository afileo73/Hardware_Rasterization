library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all; 

library vunit_lib;
context vunit_lib.vunit_context;

entity Loader_tb is
    generic (runner_cfg : string);
end Loader_tb;

architecture Behavioral of Loader_tb is

    component Loader is
        generic (
            numfaces : integer;
            VectAddrWidth : integer;
            FaceAddrWidth : integer
        );
        port(
            clk, clr, go, gonext : in std_logic;
            ready, readynext : out std_logic;
            x0, x1, x2, y0, y1, y2, z0, z1, z2 : out std_logic_vector(9 downto 0)
        );
    end component;

    --generics
    signal numfaces        : integer := 12;
    signal VectAddrWidth   : integer := 5;
    signal FaceAddrWidth   : integer := 6;

    --inputs
    signal clk, clr : std_logic := '1';
    signal go, gonext : std_logic := '0';

    --outputs
    signal x0, x1, x2, y0, y1, y2, z0, z1, z2 : std_logic_vector(9 downto 0);
    signal ready, readynext : std_logic;

    --testbench
    signal logging : std_logic := '0';
    constant clock_period : time := 10 ns;

begin

    uut: Loader
    generic map(
        numfaces => numfaces, VectAddrWidth => VectAddrWidth, FaceAddrWidth => FaceAddrWidth
    )
    port map(
        clk => clk, clr => clr, go => go, gonext => gonext, x0 => x0, x1 => x1, x2 => x2, y0 => y0, y1 => y1, y2 => y2, z0 => z0, z1 => z1, z2 => z2, ready => ready, readynext => readynext
    );

    clock_process: process
    begin
        clk <= '1';
        wait for clock_period/2;
        clk <= '0';
        wait for clock_period/2;
    end process;

    stim_proc: process
    begin
        test_runner_setup(runner, runner_cfg);
        wait for clock_period;
        clr <= '0';
        go <= '1';
        wait for clock_period * 2;
        go <= '0';
        for i in 1 to numfaces loop
            wait until (readynext = '1');
            gonext <= '0';
            logging <= '1';
            info("Face " & integer'image(i) & ": "
            & "(" & integer'image(conv_integer(x0)) & ", " & integer'image(conv_integer(y0)) & ", " & integer'image(conv_integer(z0)) & ") "
            & "(" & integer'image(conv_integer(x1)) & ", " & integer'image(conv_integer(y1)) & ", " & integer'image(conv_integer(z1)) & ") "
            & "(" & integer'image(conv_integer(x2)) & ", " & integer'image(conv_integer(y2)) & ", " & integer'image(conv_integer(z2)) & ") ");
            report "Face " & integer'image(i) & ": "
            & "(" & integer'image(conv_integer(x0)) & ", " & integer'image(conv_integer(y0)) & ", " & integer'image(conv_integer(z0)) & ") "
            & "(" & integer'image(conv_integer(x1)) & ", " & integer'image(conv_integer(y1)) & ", " & integer'image(conv_integer(z1)) & ") "
            & "(" & integer'image(conv_integer(x2)) & ", " & integer'image(conv_integer(y2)) & ", " & integer'image(conv_integer(z2)) & ") " severity NOTE;
            wait for clock_period;
            logging <= '0';
            gonext <= '1';
            wait for clock_period * 2;
            gonext <= '0';
            check(1 = 1);
        end loop;
        test_runner_cleanup(runner); -- Simulation ends here
        --Hold Indefinetly
        wait;
    end process;

end Behavioral;