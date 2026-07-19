function hRD = plugin_rd()
% Reference design definition: minimal "no AXI" system for a standalone
% Artix-7 FPGA. A Clocking Wizard generates the DUT clock from the 100 MHz
% board oscillator and a Processor System Reset block generates the
% synchronized reset from push button BTN0.
%
% Modeled on the reference design shipped with HDL Coder:
%   matlabroot/toolbox/hdlcoder/boards/amd/+XilinxArty/+vivado_no_axi_2020_2
% with the Ethernet PHY clock output removed.

% Construct reference design object
hRD = hdlcoder.ReferenceDesign('SynthesisTool', 'Xilinx Vivado');

hRD.ReferenceDesignName = 'Default system (no AXI)';
hRD.BoardName = 'Digilent Arty A7-35T (custom)';

% Tool information
hRD.SupportedToolVersion = {'2023.1','2024.1'};

%% Add custom design files
% add custom Vivado design (block design Tcl)
hRD.addCustomVivadoDesign( ...
    'CustomBlockDesignTcl', 'system_top.tcl');

hRD.CustomFiles = {};

% custom constraint files: board clock and reset pins
hRD.CustomConstraints = {'arty_clock_constraints.xdc'};

%% Add interfaces
% clock and reset supplied to the generated IP core
hRD.addClockInterface( ...
    'ClockConnection',      'system_0/clk_out1', ...
    'ResetConnection',      'system_0/peripheral_aresetn', ...
    'DefaultFrequencyMHz',  100, ...
    'MinFrequencyMHz',      10, ...
    'MaxFrequencyMHz',      200, ...
    'ClockModuleInstance',  'system_0/clk_wiz_0');

hRD.HasProcessingSystem = false;

end
