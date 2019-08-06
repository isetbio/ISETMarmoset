% Visualize aspects of the default marmoset optics
%
% Syntax:
%   visualizeDefaultOptics()
%
% Description:
%    Visualize the point spread function (PSF) and optical transfer
%    function (OTF) at a single wavelength.
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
%    08/05/19  NPC  Wrote it.

function visualizeDefaultOptics()

    % Generate the default marmoset optics
    theOI = oiMarmosetCreate();
    
    % Visualize the PSF and the OTF
    % Spectral slide to visualize
    visualizedWavelength = 550;
    % Max spatial support for PSF
    visualizedSpatialSupportArcMin = 5;
    % Max spatial frequency support for OTF
    visualizedSpatialSfrequencyCPD = 60.0;
    
    visualizeOptics(theOI, visualizedWavelength, ...
        visualizedSpatialSupportArcMin, ...
        visualizedSpatialSfrequencyCPD);
end
