function defaultParams = opticsMarmosetDefaultParams()
% Generate the default parameter values for the marmoset eye
%
% Syntax:
%   opticsParams = OPTICSMARMOSETDEFAULTPARAMS(varargin)
%
% Description: return default optical params for the marmoset
% 
% From Table 1 of "Visual optics and retinal cone topography in the common
% marmoset)", by Troilo, Howland and Judge, Vis. Res, 33 (10), pp.1301-1310, 1993
%   - anteriorFocalLengthMM = 7.51;
%   - total power: 133.19 D
%
%
% History:
%    08/05/19  NPC  ISETBIO TEAM, 2018

defaultParams = struct(...
    'opticsType', 'gaussian psf', ...
    'inFocusPSFsigmaMicrons', 3.5, ...      % arbitrary for now
    'focalLengthMM', 7.51, ...
    'pupilDiameterMM', 3.0 ...              % arbitrary for now
    );

end