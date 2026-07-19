----------------------------------------------------------------------------------
-- fft8.vhd
-- Clocked wrapper around the parallel combinational 8-point FFT function
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fft8_pkg.all;

entity fft8 is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        valid_in  : in  STD_LOGIC;
        x         : in  real_in_t;      -- 8 real samples, signed(15:0)
        valid_out : out STD_LOGIC;
        y         : out cplx_arr_t      -- 8 complex bins, signed(31:0)
    );
end fft8;

architecture Behavioral of fft8 is
    signal y_r : cplx_arr_t;
    signal v_r : STD_LOGIC := '0';
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                v_r <= '0';
            else
                v_r <= valid_in;
                if valid_in = '1' then
                    y_r <= fft8_comb(x);
                end if;
            end if;
        end if;
    end process;

    y         <= y_r;
    valid_out <= v_r;

end Behavioral;