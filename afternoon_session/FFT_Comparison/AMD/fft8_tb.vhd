----------------------------------------------------------------------------------
-- fft8_tb.vhd
-- Self-checking testbench for the parallel 8-point FFT module
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use work.fft8_pkg.all;

entity fft8_tb is
end fft8_tb;

architecture sim of fft8_tb is
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal valid_in  : std_logic := '0';
    signal x         : real_in_t := (others => (others => '0'));
    signal valid_out : std_logic;
    signal y         : cplx_arr_t;

    constant TOL : integer := 2;
    type int8_t is array (0 to 7) of integer;
    constant EXP_RE : int8_t := (0, 0, 4000, 0, 0, 0, 4000, 0);
    constant EXP_IM : int8_t := (0, 0,    0, 0, 0, 0,    0, 0);
begin

    -- 100 MHz clock generation
    clk <= not clk after 5 ns;

    -- Device Under Test (DUT)
    uut : entity work.fft8
        port map (
            clk       => clk, 
            rst       => rst, 
            valid_in  => valid_in,
            x         => x, 
            valid_out => valid_out, 
            y         => y
        );

    stim : process
        variable L          : line;
        variable re_i, im_i : integer;
        variable errors     : integer := 0;
    begin
        -- System Startup Reset Window
        wait for 20 ns;
        rst <= '0';
        wait until rising_edge(clk);

        -- Load parallel input frame: 1000 * [1, 0, -1, 0, 1, 0, -1, 0]
        x(0) <= to_signed( 1000, 16);
        x(1) <= to_signed(    0, 16);
        x(2) <= to_signed(-1000, 16);
        x(3) <= to_signed(    0, 16);
        x(4) <= to_signed( 1000, 16);
        x(5) <= to_signed(    0, 16);
        x(6) <= to_signed(-1000, 16);
        x(7) <= to_signed(    0, 16);
        
        valid_in <= '1';
        wait until rising_edge(clk);
        valid_in <= '0';

        -- Wait for registered data confirmation flag
        wait until valid_out = '1';
        wait for 1 ns; -- Tiny offset past clock edge for print formatting cleanly

        write(L, string'("=== Parallel 8-point FFT Result Extraction ===")); writeline(output, L);
        write(L, string'("Bin      Real        Imag     (Expected Re, Im)")); writeline(output, L);
        
        for k in 0 to 7 loop
            re_i := to_integer(y(k).re);
            im_i := to_integer(y(k).im);
            
            write(L, k);                  write(L, string'("    "));
            write(L, re_i);               write(L, string'("       "));
            write(L, im_i);               write(L, string'("      ("));
            write(L, EXP_RE(k));          write(L, string'(", "));
            write(L, EXP_IM(k));          write(L, string'(")"));
            writeline(output, L);
            
            -- Absolute Tolerance Discrepancy Verification Check
            if abs(re_i - EXP_RE(k)) > TOL or abs(im_i - EXP_IM(k)) > TOL then
                errors := errors + 1;
                write(L, string'("   ^ MISMATCH at frequency bin ")); write(L, k); writeline(output, L);
            end if;
        end loop;

        -- Test summary status announcement
        if errors = 0 then
            write(L, string'("SUCCESS: Spectrum perfectly matches reference (Peaks at Bin 2 & 6).")); writeline(output, L);
        else
            write(L, string'("FAILURE: Execution terminated with ")); write(L, errors); write(L, string'(" mismatched bin entries.")); writeline(output, L);
        end if;

        assert errors = 0 report "FFT Math Verification Failed" severity failure;
        
        std.env.stop;
        wait;
    end process;

end sim;