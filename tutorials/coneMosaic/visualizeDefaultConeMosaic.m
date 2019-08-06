% Visualize the default marmoset cone mosaic
%
% Syntax:
%   visualizeDefaultConeMosaic()
%
% Description:
%    Visualize the default marmoset cone mosaic 
%
% Inputs:
%    None.
%
% Outputs:
%    None.
%
% Optional key/value pairs:
%    None.
%

% History
%    08/05/18  NPC  Wrote it.

function visualizeDefaultConeMosaic()

    % Generate the default marmoset optics
    theOI = oiMarmosetCreate();

    % Generate a 1x1 deg marmoset cone mosaic with default params
    theConeMosaic = coneMosaicMarmosetCreate(...
        theOI.optics.micronsPerDegree, ...
        'fovDegs', [1 1]);

    % Display some info
    theConeMosaic.displayInfo();
    
    figure();
    ax = subplot('Position', [0.07 0.15 0.9 0.8]);
    theConeMosaic.visualizeGrid(...
        'axesHandle', ax, ...
        'backgroundColor', [1 1 1], ...
        'ticksInVisualDegs', true);

end