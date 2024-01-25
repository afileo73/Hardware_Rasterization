library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;

entity LoadVector is
	generic (
        G_NUMFACES : integer;
        G_VECTADDRWIDTH : integer;
        G_FACEADDRWIDTH : integer
    );
    port(
		clk, clr, go, gonext : in std_logic;
        dataFace : in std_logic_vector(7 downto 0);
        ready, readynext : out std_logic;
        load : out std_logic_vector(8 downto 0);
        addrVect : out std_logic_vector(G_VECTADDRWIDTH-1 downto 0);
        addrFace : out std_logic_vector(G_FACEADDRWIDTH-1 downto 0)
	);
end LoadVector;
architecture Behavioral of LoadVector is 
	component LoadVectorFSM is
        generic(
            G_NUMFACES : integer
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
    end component;

    component CountRegister is
        generic( N : integer);
        port(
            clk, clr, ld, inc : in std_logic;
            d : in std_logic_vector(N-1 downto 0);
            q : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal incVectReg, ldVectReg, incFaceReg, ldFaceReg : std_logic;
    signal dataFacem3 : std_logic_vector (15 downto 0);
begin
    MultFaceData: process(dataFace)
    begin
        dataFacem3 <= (dataFace - 1) * "00000011"; -- Multiply by three to properly index the start of each vector since each vector takes up three spaces in memory
    end process;
    
    FSM: LoadVectorFSM
    generic map(
        G_NUMFACES => G_NUMFACES
    )
    port map(
        clk => clk,
        clr => clr,
        go => go,
        gonext => gonext,
        incVectReg => incVectReg,
        ldVectReg => ldVectReg,
        incFaceReg => incFaceReg,
        ldFaceReg => ldFaceReg,
        load => load,
        ready => ready,
        readynext => readynext
    );

    VectAddrReg: CountRegister
    generic map(N => G_VECTADDRWIDTH)
    port map(
        d => dataFacem3(G_VECTADDRWIDTH-1 downto 0),
        q => addrVect,
        ld => ldVectReg,
        inc => incVectReg,
        clk => clk,
        clr => clr
    );

    FaceAddrReg: CountRegister
    generic map(N => G_FACEADDRWIDTH)
    port map(
        d => (others => '0'),
        q => addrFace,
        ld => ldFaceReg,
        inc => incFaceReg,
        clk => clk,
        clr => clr
    );

end Behavioral;