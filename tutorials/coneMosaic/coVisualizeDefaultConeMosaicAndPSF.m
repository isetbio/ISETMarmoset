% Co-visualize the marmoset PSF and the cone mosaic
%
% Syntax:
%    coVisualizeDefaultConeMosaicAndPSF()
%
% Description:
%    Co-visualize the point spread function (PSF) and cone mosaic of the
%    marmoset
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

function coVisualizeDefaultConeMosaicAndPSF()

    % Generate the default marmoset optics
    theOI = oiMarmosetCreate();

    % Generate a 1x1 deg marmoset cone mosaic with default params
    theConeMosaic = coneMosaicMarmosetCreate(...
        theOI.optics.micronsPerDegree, ...
        'fovDegs', [1 1]);

    % Display some info
    theConeMosaic.displayInfo();
    
    % Co-visualize the default treeshrew PSF and cone mosaic
    hFig = figure(); clf;
    set(hFig, 'Position', [10 10 1150 400]);
    ax = subplot(1,3,1);
    theConeMosaic.visualizeGrid(...
        'axesHandle', ax, ...
        'backgroundColor', [1 1 1], ...
        'scaleBarLengthMicrons', 50);
    xTickMicrons = -100:20:100;
    set(ax, 'XTick', xTickMicrons*1e-6, 'XTickLabel', sprintf('%2.0f\n',xTickMicrons), ...
            'YTick', xTickMicrons*1e-6, 'YTickLabel', sprintf('%2.0f\n',xTickMicrons), ...
            'FontSize', 16);
    xlabel('\it space (microns)');
    ylabel('\it space (microns)');
    
    ax = subplot(1,3,2);
    theConeMosaic.visualizeGrid(...
        'axesHandle', ax, ...
        'backgroundColor', [1 1 1], ...
        'ticksInVisualDegs', true);
    set(ax, 'FontSize', 16);
    xlabel('\it space (degs)');
    ylabel('\it space (degs)');
    
    ax = subplot(1,3,3);
    % Spectral slide of the PSF to visualize
    visualizedWavelength = 550;
    % Max spatial support for PSF
    visualizedSpatialSupportArcMin = 5;
    visualizePSF(theOI, visualizedWavelength, ...
        visualizedSpatialSupportArcMin, ...
        'withSuperimposedMosaic', theConeMosaic, ...
        'axesHandle', ax);
    set(ax, 'FontSize', 16);

end