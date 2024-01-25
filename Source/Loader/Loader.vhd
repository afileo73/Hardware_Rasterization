-- Copyright 2023 Alex Fillmore
-- afillmore@oakland.edu
library ieee;
use ieee.std_logic_1164.all;

entity loader is
    generic (
        G_NUMFACES : integer;
        G_VECTADDRWIDTH : integer;
        G_FACEADDRWIDTH : integer;
        G_VERTEXSIZE : integer := 12
    );
    port(
        clk         : in std_logic;
        clr         : in std_logic;
        go          : in std_logic;
        gonext      : in std_logic;
        ready       : out std_logic;
        readynext   : out std_logic;
        x0          : out std_logic_vector(9 downto 0);
        x1          : out std_logic_vector(9 downto 0);
        x2          : out std_logic_vector(9 downto 0);
        y0          : out std_logic_vector(9 downto 0);
        y1          : out std_logic_vector(9 downto 0);
        y2          : out std_logic_vector(9 downto 0);
        z0          : out std_logic_vector(9 downto 0);
        z1          : out std_logic_vector(9 downto 0);
        z2          : out std_logic_vector(9 downto 0)
    );
end loader;

architecture behavioral of loader is

    signal loadregs : std_logic_vector(8 downto 0);
    signal dataface : std_logic_vector(7 downto 0);
    signal datavect : std_logic_vector(9 downto 0);
    signal addrvect : std_logic_vector(G_VECTADDRWIDTH-1 downto 0);
    signal addrface : std_logic_vector(G_FACEADDRWIDTH-1 downto 0);
    signal vertex_data : std_logic_vector(G_VERTEXSIZE*9-1 downto 0);

begin

    LoadVectorComp: entity work.LoadVector
    generic map(
        G_NUMFACES => G_NUMFACES,
        G_VECTADDRWIDTH => G_VECTADDRWIDTH,
        G_FACEADDRWIDTH =>G_FACEADDRWIDTH
    )
    port map(
        clk => clk,
        clr => clr,
        go => go,
        gonext => gonext,
        dataface => dataface,
        ready => ready,
        readynext => readynext,
        load => loadregs,
        addrvect => addrvect,
        addrface => addrface
    );

    face: entity work.FaceROM
    port map(
        addra => addrface,
        douta => dataface,
        clka  => clk
    );

    vect: entity work.VectorROM
    port map(
        addra => addrvect,
        douta => datavect,
        clka => clk
    );

    gen_reg: for i in 0 to 8 generate
        nreg_inst: entity work.NReg
        generic map (
          N => G_VERTEXSIZE
        )
        port map (
          load => loadregs(0),
          clk  => clk,
          clr  => clr,
          d    => datavect,
          q    => vertex_data((i+1)*G_VERTEXSIZE-1 downto i*G_VERTEXSIZE)
        );
    end generate gen_reg;

    x0 <= vertex_data((0+1)*G_VERTEXSIZE-1 downto 0*G_VERTEXSIZE);
    y0 <= vertex_data((1+1)*G_VERTEXSIZE-1 downto 1*G_VERTEXSIZE);
    z0 <= vertex_data((2+1)*G_VERTEXSIZE-1 downto 2*G_VERTEXSIZE);
    x1 <= vertex_data((3+1)*G_VERTEXSIZE-1 downto 3*G_VERTEXSIZE);
    y1 <= vertex_data((4+1)*G_VERTEXSIZE-1 downto 4*G_VERTEXSIZE);
    z1 <= vertex_data((5+1)*G_VERTEXSIZE-1 downto 5*G_VERTEXSIZE);
    x2 <= vertex_data((6+1)*G_VERTEXSIZE-1 downto 6*G_VERTEXSIZE);
    y2 <= vertex_data((7+1)*G_VERTEXSIZE-1 downto 7*G_VERTEXSIZE);
    z2 <= vertex_data((8+1)*G_VERTEXSIZE-1 downto 8*G_VERTEXSIZE);


end behavioral;
