% Generate a test scene
%
% Syntax:
%   generateTestScene
%
% Description:
%    Generate and visualize a test scene on a given presentation display. 
%    Shows how to alter the LUT to get quantization effects. 
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

function generateTestScene

    % Scene size in degrees
    fieldOfViewDegs = 1.5;
    
    % Scene pixels
    pixelsNum = 512;
    
    % Generate the stimulus RGB values (primaries)
    stimulusRGBPrimaries = generateStimulusRGBPrimariesModulation(pixelsNum);
    
    % Generate the presentation display
    presentationDisplay = createCustomDisplay();
    
    % Compute the stimulus settings for a simulated LUT length
    simulatedLUTlength = 4;   % only 4-bit to see the effect of quantization
    stimulusRGBSettings = round(ieLUTLinear(stimulusRGBPrimaries,displayGet(presentationDisplay,'inverse gamma',2^simulatedLUTlength)));
    
    % Generate scene from stimulus settings for presentation display
    theScene = sceneFromFile(stimulusRGBSettings,'rgb',[],presentationDisplay);
    
    % Set the desired stimulus angular size
    theScene = sceneSet(theScene, 'h fov', fieldOfViewDegs);
     
    % Visualize aspects of the generated scene
    renderSceneRGB(theScene);
end

function renderSceneRGB(theScene)
    % retrieve RGB rendition of the scene
    theStimImage = sceneGet(theScene, 'rgb image');
    
    % retrieve spatial support in meters
    spatialSupportMeters = sceneGet(theScene, 'spatial support');
    xAxisMeters = squeeze(spatialSupportMeters(1,:,1));
    yAxisMeters = squeeze(spatialSupportMeters(:,1,2));
    
    % retrieve pixel angular size
    angRes = sceneGet(theScene, 'angular resolution');
    pixelsNum = sceneGet(theScene, 'rows');
    xAxisDegs = (1:pixelsNum)*angRes(1); xAxisDegs = xAxisDegs - mean(xAxisDegs);
    yAxisDegs = (1:pixelsNum)*angRes(2); yAxisDegs = yAxisDegs - mean(yAxisDegs);
    
    % Plot the scene RGB
    figure();
    subplot(1,2,1);
    imagesc(xAxisMeters, yAxisMeters, theStimImage);
    xlabel('space (meters on display)');
    axis 'image';
    subplot(1,2,2);
    imagesc(xAxisDegs, yAxisDegs, theStimImage);
    axis 'image';
    xlabel('space (visual degrees)');
end

function stimulusRGB = generateStimulusRGBPrimariesModulation(pixelsNum)
    % Generate a rampling stimulus
    stimulusRGB = zeros(pixelsNum,pixelsNum,3);
    for k = 1:pixelsNum
        modulation = (k-1)/pixelsNum;
        stimulusRGB(:,k,:) = modulation;
    end
end


