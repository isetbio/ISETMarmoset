function oi = oiMarmosetCreate(varargin)
% Create an optical image structure specific to the Marmoset
%
% Syntax:
%   oi = OIMARMOSETCREATE(oiType, [varargin]) 
%
% See Also:
%    opticsMarmosetCreate
%
% History:
%    08/05/19  NPC  ISETBIO TEAM, 2018
%
% Examples:
%{
    % Default TreeShrew model
    oi = oiMarmosetCreate();
%}
%{
    % Custom marmoset optics where we specify the sigma of the PSF
    oi = oiMarmosetCreate(...
        'inFocusPSFsigmaMicrons', 40 ... % 40 microns
    );
%}

    oi.type = 'opticalimage';
    oi = oiSet(oi, 'optics', opticsMarmosetCreate(varargin{:}));
    oi = oiSet(oi, 'name', 'treeshrew');
    
    oi = oiSet(oi, 'bit depth', 32);
    oi = oiSet(oi, 'diffuser method', 'skip');
    oi = oiSet(oi, 'consistency', 1);
    
    % TreeShrew lens absorption.
    theMarmosetLens = lensMarmosetCreate('wave', oiGet(oi, 'optics wave'));
    
    % Update the oi.lens
    oi = oiSet(oi, 'lens', theMarmosetLens);
    
    % Set the same lens in the optics structure too
    oi.optics.lens = theMarmosetLens;
end

