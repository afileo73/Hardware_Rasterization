library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Loader is
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
end Loader;

architecture Behavioral of Loader is

    component LoadVector is
        generic (
            numfaces : integer;
            VectAddrWidth : integer;
            FaceAddrWidth : integer
        );
        port(
            clk, clr, go, gonext : in std_logic;
            dataFace : in std_logic_vector(7 downto 0);
            ready, readynext : out std_logic;
            load : out std_logic_vector(8 downto 0);
            addrVect : out std_logic_vector(VectAddrWidth-1 downto 0);
            addrFace : out std_logic_vector(FaceAddrWidth-1 downto 0)
        );
    end component;

    component VectorRAM
        port(
            addra : in std_logic_vector(4 downto 0);
            douta : out std_logic_vector(9 downto 0);
            clka : in std_logic
        );
    end component;

    component FaceROM
        port(
            addra : in std_logic_vector(5 downto 0);
            douta : out std_logic_vector(7 downto 0);
            clka : in std_logic
        );
    end component;

    component NReg is
        generic(N:integer := 8);
        port(
            load : in STD_LOGIC;
            clk : in STD_LOGIC;
            clr : in STD_LOGIC;
            d : in STD_LOGIC_VECTOR(N-1 downto 0);
            q : out STD_LOGIC_VECTOR(N-1 downto 0)
            );
   end component;

    signal loadRegs : std_logic_vector(8 downto 0);
    signal dataFace : std_logic_vector(7 downto 0);
    signal dataVect : std_logic_vector(9 downto 0);
    signal addrVect : std_logic_vector(VectAddrWidth-1 downto 0);
    signal addrFace : std_logic_vector(FaceAddrWidth-1 downto 0);

begin

    LoadVectorComp: LoadVector
    generic map(
        numfaces => numfaces, VectAddrWidth => VectAddrWidth, FaceAddrWidth => FaceAddrWidth
    )
    port map(
        clk => clk, clr => clr, go => go, gonext => gonext, dataFace => dataFace, ready => ready, readynext => readynext, load => loadRegs, addrVect => addrVect, addrFace => addrFace
    );
    
    face: FaceROM
    port map(
        addra => addrFace,
        douta => dataFace,
        clka  => clk
    );

    vect: VectorRAM
    port map(
        addra => addrVect,
        douta => dataVect,
        clka => clk
    );

    x0Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(0), d => dataVect, q => x0
    );
    
    y0Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(1), d => dataVect, q => y0
    );

    z0Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(2), d => dataVect, q => z0
    );

    x1Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(3), d => dataVect, q => x1
    );
    
    y1Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(4), d => dataVect, q => y1
    );

    z1Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(5), d => dataVect, q => z1
    );

    x2Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(6), d => dataVect, q => x2
    );
    
    y2Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(7), d => dataVect, q => y2
    );

    z2Reg: NReg
    generic map(
        N => 10
    )
    port map(
        clk => clk, clr => clr, load => loadRegs(8), d => dataVect, q => z2
    );

end Behavioral;