----------------------------------------------------------------------------------
-- fft8_pkg.vhd
-- Package defining types and parallel combinational 8-point FFT logic
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package fft8_pkg is

    -- Complex number record definition (32-bit tracking full bit-growth)
    type cplx_t is record
        re : signed(31 downto 0);
        im : signed(31 downto 0);
    end record;
    
    type cplx_arr_t is array (0 to 7) of cplx_t;
    type real_in_t is array (0 to 7) of signed(15 downto 0);

    function fft8_comb (x : real_in_t) return cplx_arr_t;

end package fft8_pkg;

package body fft8_pkg is

    function fft8_comb (x : real_in_t) return cplx_arr_t is
        type stage_arr_t is array (0 to 7) of cplx_t;
        variable s0, s1, s2 : stage_arr_t;
        variable y          : cplx_arr_t;
        
        -- Q15 Fixed-point twiddle factor representation: 0.70710678 * 32768 = 23170
        constant W8_1_C : signed(31 downto 0) := to_signed(23170, 32);
        
        -- Intermediate variables for fractional product multiplication
        variable prod_re, prod_im : signed(63 downto 0);
        variable w_s2_5, w_s2_6, w_s2_7 : cplx_t;
    begin
        
        -- ==========================================
        -- STAGE 0: Bit-Reversal & Width Alignment
        -- ==========================================
        s0(0).re := resize(x(0), 32); s0(0).im := (others => '0');
        s0(1).re := resize(x(4), 32); s0(1).im := (others => '0');
        s0(2).re := resize(x(2), 32); s0(2).im := (others => '0');
        s0(3).re := resize(x(6), 32); s0(3).im := (others => '0');
        s0(4).re := resize(x(1), 32); s0(4).im := (others => '0');
        s0(5).re := resize(x(5), 32); s0(5).im := (others => '0');
        s0(6).re := resize(x(3), 32); s0(6).im := (others => '0');
        s0(7).re := resize(x(7), 32); s0(7).im := (others => '0');

        -- ==========================================
        -- STAGE 1: 2-Point Butterflies (Twiddle = 1)
        -- ==========================================
        s1(0).re := s0(0).re + s0(1).re; s1(0).im := s0(0).im + s0(1).im;
        s1(1).re := s0(0).re - s0(1).re; s1(1).im := s0(0).im - s0(1).im;
        s1(2).re := s0(2).re + s0(3).re; s1(2).im := s0(2).im + s0(3).im;
        s1(3).re := s0(2).re - s0(3).re; s1(3).im := s0(2).im - s0(3).im;
        s1(4).re := s0(4).re + s0(5).re; s1(4).im := s0(4).im + s0(5).im;
        s1(5).re := s0(4).re - s0(5).re; s1(5).im := s0(4).im - s0(5).im;
        s1(6).re := s0(6).re + s0(7).re; s1(6).im := s0(6).im + s0(7).im;
        s1(7).re := s0(6).re - s0(7).re; s1(7).im := s0(6).im - s0(7).im;

        -- ==========================================
        -- STAGE 2: 4-Point Butterflies (Twiddles = 1, -j)
        -- ==========================================
        -- Group 1
        s2(0).re := s1(0).re + s1(2).re; s2(0).im := s1(0).im + s1(2).im;
        s2(2).re := s1(0).re - s1(2).re; s2(2).im := s1(0).im - s1(2).im;
        -- Twiddle W_4^1 = -j  =>  -j * (re + j*im) = im - j*re
        s2(1).re := s1(1).re + s1(3).im; s2(1).im := s1(1).im - s1(3).re;
        s2(3).re := s1(1).re - s1(3).im; s2(3).im := s1(1).im + s1(3).re;

        -- Group 2
        s2(4).re := s1(4).re + s1(6).re; s2(4).im := s1(4).im + s1(6).im;
        s2(6).re := s1(4).re - s1(6).re; s2(6).im := s1(4).im - s1(6).im;
        s2(5).re := s1(5).re + s1(7).im; s2(5).im := s1(5).im - s1(7).re;
        s2(7).re := s1(5).re - s1(7).im; s2(7).im := s1(5).im + s1(7).re;

        -- ==========================================
        -- STAGE 3: 8-Point Butterflies (Complex Twiddles)
        -- ==========================================
        -- k = 1: W_8^1 = C - jC  => (C - jC)*(re + j*im) = (C*re + C*im) + j(C*im - C*re)
        prod_re := (s2(5).re * W8_1_C) + (s2(5).im * W8_1_C);
        prod_im := (s2(5).im * W8_1_C) - (s2(5).re * W8_1_C);
        w_s2_5.re := resize(shift_right(prod_re, 15), 32); -- Remove Q15 scaling
        w_s2_5.im := resize(shift_right(prod_im, 15), 32);

        -- k = 2: W_8^2 = -j  => -j * (re + j*im) = im - j*re
        w_s2_6.re := s2(6).im;
        w_s2_6.im := -s2(6).re;

        -- k = 3: W_8^3 = -C - jC => (-C - jC)*(re + j*im) = (C*im - C*re) + j(-C*im - C*re)
        prod_re := (s2(7).im * W8_1_C) - (s2(7).re * W8_1_C);
        prod_im := (-s2(7).im * W8_1_C) - (s2(7).re * W8_1_C);
        w_s2_7.re := resize(shift_right(prod_re, 15), 32);
        w_s2_7.im := resize(shift_right(prod_im, 15), 32);

        -- Final Structural Recombination Assignments
        y(0).re := s2(0).re + s2(4).re;   y(0).im := s2(0).im + s2(4).im;
        y(4).re := s2(0).re - s2(4).re;   y(4).im := s2(0).im - s2(4).im;

        y(1).re := s2(1).re + w_s2_5.re;  y(1).im := s2(1).im + w_s2_5.im;
        y(5).re := s2(1).re - w_s2_5.re;  y(5).im := s2(1).im - w_s2_5.im;

        y(2).re := s2(2).re + w_s2_6.re;  y(2).im := s2(2).im + w_s2_6.im;
        y(6).re := s2(2).re - w_s2_6.re;  y(6).im := s2(2).im - w_s2_6.im;

        y(3).re := s2(3).re + w_s2_7.re;  y(3).im := s2(3).im + w_s2_7.im;
        y(7).re := s2(3).re - w_s2_7.re;  y(7).im := s2(3).im - w_s2_7.im;

        return y;
    end function;

end package body fft8_pkg;