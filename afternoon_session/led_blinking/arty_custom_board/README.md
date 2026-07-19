# Custom HDL Coder board registration for the Digilent Arty A7-35T

This folder registers the Arty A7-35T as a **custom board + reference design**
with HDL Coder, following the same plugin system MathWorks uses for its own
boards (see `matlabroot\toolbox\hdlcoder\boards\amd\+XilinxArty`, which this
example is modeled on).

With the board registered, the **IP Core Generation** workflow can target the
Arty directly: the board appears in the *Target platform* dropdown of HDL
Workflow Advisor task 1.1, DUT ports are mapped to named board interfaces in
the **Set Target Interface** task (no hand-written XDC), and the workflow runs
all the way through **Build FPGA Bitstream** and **Program Target Device** —
including JTAG programming, which the Generic ASIC/FPGA workflow cannot do.

## Files

```
hdlcoder_board_customization.m            board plugin registration (must be on the MATLAB path)
+ArtyA7Custom\
    plugin_board.m                        hdlcoder.Board: device xc7a35ti-csg324 -1L + I/O interfaces
    hdlcoder_ref_design_customization.m   reference design registration for this board
    +vivado_no_axi\
        plugin_rd.m                       hdlcoder.ReferenceDesign (no processor, no AXI)
        system_top.tcl                    Vivado block design: clk_wiz (DUT clock) + proc_sys_reset
        arty_clock_constraints.xdc        board clock (E3, 100 MHz) and reset (BTN0/D9) pins
```

Board interfaces defined in `plugin_board.m` (pins from the Digilent Arty A7
master XDC, all LVCMOS33):

| InterfaceID          | Dir | Width | Pins                                  | Board parts            |
|----------------------|-----|-------|---------------------------------------|------------------------|
| LEDs General Purpose | OUT | 8     | H5, J5, T9, T10, F6, J4, J2, H6       | LD4..LD7 + RGB green   |
| Push Buttons         | IN  | 3     | C9, B9, B8                            | BTN1..BTN3             |
| Slide Switches       | IN  | 4     | A8, C11, C10, A10                     | SW0..SW3               |

BTN0 (pin D9) is deliberately **not** in the Push Buttons interface: the
reference design uses it as the external system reset (`proc_sys_reset`).

## Usage (GUI)

1. `addpath('C:\demo\hdl_coder_led_blinking\arty_custom_board')`
   (add to `startup.m` to make it permanent)
2. Open the HDL Workflow Advisor on `flash_led/flash_led_top`.
3. Task 1.1: Target workflow = `IP Core Generation`,
   Target platform = `Digilent Arty A7-35T (custom)`.
4. Task 1.2: Reference design = `Default system (no AXI)`.
5. Task 1.3 **Set Target Interface**: map `led` to
   `LEDs General Purpose [0:7]`.
6. Run the remaining tasks in order — the final task
   **Program Target Device** downloads the bitstream over JTAG.

## Usage (command line)

```matlab
addpath('C:\demo\hdl_coder_led_blinking\arty_custom_board');
hdlsetuptoolpath('ToolName','Xilinx Vivado', ...
    'ToolPath','C:\Xilinx\Vivado\2024.1\bin\vivado.bat');

hdlset_param('flash_led','Workflow','IP Core Generation');
hdlset_param('flash_led','TargetPlatform','Digilent Arty A7-35T (custom)');
hdlset_param('flash_led','ReferenceDesign','Default system (no AXI)');
hdlset_param('flash_led','ProjectFolder','hdl_prj_ipcore');
hdlset_param('flash_led','TargetFrequency',100);
hdlset_param('flash_led/flash_led_top/led', ...
    'IOInterface','LEDs General Purpose','IOInterfaceMapping','[0:7]');

hWC = hdlcoder.WorkflowConfig('SynthesisTool','Xilinx Vivado', ...
    'TargetWorkflow','IP Core Generation');
hWC.ProjectFolder = 'hdl_prj_ipcore';
hWC.RunTaskGenerateSoftwareInterface = false;  % no embedded processor
hWC.RunTaskProgramTargetDevice = true;         % JTAG programming
hdlcoder.runWorkflow('flash_led/flash_led_top', hWC);
```

## Notes

- The *Target Frequency* (task 1.2 / `TargetFrequency`) reconfigures the
  reference design's Clocking Wizard, so the DUT clock really runs at the
  requested rate. The lab design assumes 100 MHz (`MAX_COUNT = 5000000`
  gives a 20 Hz shift rate).
- The reference design reset (`peripheral_aresetn`) is active-low; HDL Coder
  adapts the generated IP core's reset polarity automatically. Pressing BTN0
  resets the whole system, including the clock wizard.
- Out-of-context synthesis is not an issue in this workflow: the IP Core
  Generation build creates a full block-design project with I/O buffers and
  produces a board-ready bitstream directly.
- The one-time Vivado build artifacts are written to `hdl_prj_ipcore\`.
