function r = hdlcoder_board_customization
% Board plugin registration file
% 1. Any registration file with this name on the MATLAB path will be picked up
% 2. Registration file returns a cell array pointing to the location of
%    the board plugins
% 3. Board plugin must be a package folder accessible from the MATLAB path,
%    and contains a board definition file
%
% Modeled on the board registration system shipped with HDL Coder
% (see matlabroot/toolbox/hdlcoder/boards/amd/+XilinxArty).

r = { ...
    'ArtyA7Custom.plugin_board', ...
    };

end
