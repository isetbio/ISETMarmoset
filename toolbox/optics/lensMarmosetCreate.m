function theLens = lensMarmosetCreate(varargin)
% Create a Lens object with marmoset - based optical density
%
% Syntax:
%   lens = LENSMARMOSETCREATE([varargin]) 
%
% Inputs: 
%           None
%
%
% Optional key/value pairs:
%    wave                 - Vector. Wavelengths. Default [], retrieve from
%                                   absorbance file
%    lensAbsorbanceFile   - Char, Filename containing 'wavelength' and
%                                   'data' fields specifying the lens
%                                   absorbance spectrum
%
% Outputs: 
%           lens - Struct. The created lens structure.
%
% See Also:
%    opticsMarmosetCreate
%
%
% History:
%    08/05/19  NPC  ISETBIO TEAM, 2019
%
% Examples:
%{
    % Default Marmoset lens model
    lens = lensMarmosetCreate();
%}

    %% parse input
    p = inputParser;
    p.addParameter('wave', [], @isnumeric);
    p.addParameter('lensAbsorbanceFile', 'treeshrewLensAbsorbance.mat', @ischar);
    p.parse(varargin{:});
    
    fprintf(2,'Warning. Using tree shrew lens absorbance ...\n');
    lensAbsorbanceFile = p.Results.lensAbsorbanceFile;
    targetWavelenth = p.Results.wave;
    
    % TreeShrew lens absorption. Start with the human lens.
    theLens = Lens();
    
    % Load Marmoset lens unit-density
    load(lensAbsorbanceFile, 'wavelength', 'data');
    
    if (isempty(targetWavelenth))
        targetWavelenth = wavelength;
        unitDensity = data;
    else
        % Interpolate to optics wavelength support
        unitDensity = interp1(wavelength,data,targetWavelenth, 'pchip');
    end
    
    % Update the lens
    set(theLens,'wave', targetWavelenth);
    set(theLens,'unitDensity',unitDensity);
    
    % TreeShrew lens absorption. Start with the human lens.
    theLens = Lens();
end