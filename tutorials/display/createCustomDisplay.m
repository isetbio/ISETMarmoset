% Generate a custom display
%
% Syntax:
%   theDisplay = createCustomDisplay()
%
% Description:
%    Generate a customized presentation display. The customized aspects are
%    the SPDs and the LUT. Plots the original and modified SPDs and gamma LUTs.
%
% Inputs:
%    None.
%
% Outputs:
%    theDisplay - the generated display
%
% Optional key/value pairs:
%    None.
%

% History
%    08/05/18  NPC  Wrote it.

function theDisplay = createCustomDisplay()

    % Load the default 18-bit display
    theDisplay = displayCreate('CRT_18bitLUT');
    
    % Plot the default SPDs
    plotSPDS(theDisplay);
    
    % Set custom SPDs (here just a gain factor of 10)
    defaultSPDs = displayGet(theDisplay,'spd');
    customSPDs = defaultSPDs * 10;
    theDisplay = displaySet(theDisplay,'spd',customSPDs);
        
    % Plot the modified SPDs
    plotSPDS(theDisplay);
    
    % Plot the default Gamma
    plotGamma(theDisplay);
    
    % Modify the gamma (here truncate the low end)
    defaultGamma = displayGet(theDisplay, 'gamma');
    customGamma = defaultGamma;
    idx = 1:50000;
    customGamma(idx,:) = 0;
    theDisplay = displaySet(theDisplay,'gTable',customGamma);
    plotGamma(theDisplay);
    
    % Set the viewing distance
    viewingDistanceMeters = 0.74;
    theDisplay = displaySet(theDisplay,'viewingdistance', viewingDistanceMeters);
end

function plotGamma(theDisplay)
    gammaLUT = displayGet(theDisplay, 'gamma');
    
    figure()
    subplot(1,3,1)
    plot(1:size(gammaLUT,1), gammaLUT(:,1), 'r-'); 
    subplot(1,3,2)
    plot(1:size(gammaLUT,1), gammaLUT(:,2), 'g-'); 
    subplot(1,3,3)
    plot(1:size(gammaLUT,1), gammaLUT(:,3), 'b-'); 
end

    

function plotSPDS(theDisplay)
    % Retrieve the spectral support and the SPDs
    spectralSupport = displayGet(theDisplay,'wave');
    SPDs = displayGet(theDisplay,'spd');
     
    % Plot them
    figure()
    plot(spectralSupport, SPDs(:,1), 'r-'); hold on;
    plot(spectralSupport, SPDs(:,2), 'g-');
    plot(spectralSupport, SPDs(:,3), 'b-');
    drawnow;
end
