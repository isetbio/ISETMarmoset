function theConeMosaic = coneMosaicMarmosetCreate(micronsPerDegree,varargin)
% Create a coneMosaic object for the Marmoset retina
%
% Syntax:
%   theConeMosaic = CONEMOSAICMARMOSETCREATE(varargin)
%

% History:
%    08/05/19  NPC  ISETBIO TEAM, 2019

p = inputParser;
p.addParameter('fovDegs', [2 2], @isnumeric);
p.addParameter('spatialDensity', [0 0.6 0.3 0.1], @isnumeric);
p.addParameter('customLambda', 2.5, @isnumeric);
p.addParameter('customInnerSegmentDiameter', 2.4, @isnumeric);
p.addParameter('integrationTimeSeconds', 5/1000, @isnumeric);
p.addParameter('sConeMinDistanceFactor', 1, @isnumeric);
p.addParameter('resamplingFactor', 8, @isnumeric);
% Parse input
p.parse(varargin{:});

spatialDensity = p.Results.spatialDensity;
fovDegs = p.Results.fovDegs;
customLambda = p.Results.customLambda;
customInnerSegmentDiameter = p.Results.customInnerSegmentDiameter;
integrationTimeSeconds = p.Results.integrationTimeSeconds;
sConeMinDistanceFactor = p.Results.sConeMinDistanceFactor;
resamplingFactor = p.Results.resamplingFactor;

% Scale fovDegs: this is a hack because of the way the setSizeToFOV()
% is called in @coneMosaic, which assumes a 17mm focal length
fovDegs = fovDegs/((300/micronsPerDegree)^2);

if (spatialDensity(1) ~= 0)
    error('The first element in spatialDensity vector must be 0.');
end

thePhotopigment = marmosetPhotopigment();

theConeMosaic = coneMosaicHex(resamplingFactor, ...
    'fovDegs', fovDegs, ...
    'micronsPerDegree',micronsPerDegree, ...
    'integrationTime', integrationTimeSeconds, ...
    'pigment', thePhotopigment ,...
    'macular', marmosetMacularPigment(), ...
    'customLambda', customLambda, ...
    'customInnerSegmentDiameter', customInnerSegmentDiameter, ...
    'spatialDensity', spatialDensity, ...
    'sConeMinDistanceFactor', sConeMinDistanceFactor, ...
    'sConeFreeRadiusMicrons', 0 ...
    );
end

function theMacularPigment = marmosetMacularPigment()
% Human macular pigment Generate marmoset-specific macular pigment
theMacularPigment = Macular();

% or custom macular pigment
% [wave, spectralAbsorbance] = loadMarmosetMacularAbsorbance()
% theMacularPigment = Macular(...
%   'wave', wave, ...
%   'density', max(spectralAbsorbance), ...
%   'unitDensity', spectralAbsorbance);

end

