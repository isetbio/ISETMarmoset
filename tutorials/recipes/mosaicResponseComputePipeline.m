function mosaicResponseComputePipeline()

    % Generate the presentation display
    presentationDisplay = createCustomDisplay();
    
    % Generate the stimulus and background scene
    stimSizeDegs = 1.0;
    mosaicSizeDegs = 0.5;
    pixelsNum = 128;
    [stimulusRGBPrimaries, backgroundRGBPrimaries] = rgbPrimariesForSquareStimulus(pixelsNum);
    stimulusScene = generateStimulusScene(stimSizeDegs, stimulusRGBPrimaries, presentationDisplay);
    backgroundScene = generateStimulusScene(stimSizeDegs, backgroundRGBPrimaries, presentationDisplay);
    
    % Generate marmoset optics
    theOI = oiMarmosetCreate();
    
    % Generate marmoset cone mosaic
    theConeMosaic = coneMosaicMarmosetCreate(...
        theOI.optics.micronsPerDegree, ...
        'fovDegs', mosaicSizeDegs*[1 1], ...
        'resamplingFactor', 5);
    
    % Indices of L/M/S cones
    lConeIndices = find(theConeMosaic.coneTypesHexGrid == 2);
    mConeIndices = find(theConeMosaic.coneTypesHexGrid == 3);
    sConeIndices = find(theConeMosaic.coneTypesHexGrid == 4);
        
    % Compute retinal images of stimulus and background
    backgroundOI = oiCompute(theOI, backgroundScene);
    stimulusOI = oiCompute(theOI, stimulusScene);
    
    % Crop oi to remove added border
    bx = 0.5*(oiGet(backgroundOI, 'cols') - sceneGet(backgroundScene, 'cols'));
    by = 0.5*(oiGet(backgroundOI, 'rows') - sceneGet(backgroundScene, 'rows'));
    rect = [bx by pixelsNum pixelsNum];
    backgroundOI = oiCrop(backgroundOI,rect);
    stimulusOI = oiCrop(stimulusOI, rect);
    
    % Compute stimulus temporal modulation function
    stimulusSamplingIntervalSeconds = 50/1000;
    stimulusDurationSeconds = 200/1000;
    stimulusTimeAxisSeconds = -0.1:stimulusSamplingIntervalSeconds:0.3; 
    stimONbins = stimulusTimeAxisSeconds>=0 & stimulusTimeAxisSeconds <= stimulusDurationSeconds-stimulusSamplingIntervalSeconds;
    stimulusTemporalModulation = zeros(1, numel(stimulusTimeAxisSeconds));
    stimulusTemporalModulation(stimONbins) = 1;
    
    % Compute optical image sequence
    theOIsequence = oiSequence(backgroundOI, stimulusOI, stimulusTimeAxisSeconds, stimulusTemporalModulation, 'composition', 'blend');
    %theOIsequence.visualize('montage'); 
    
    
    % Generate fixational eye movements for 8 trials and for the time duration of the stimulus
    nTrials = 1;
    eyeMovementsNum = ...
            theOIsequence.maxEyeMovementsNumGivenIntegrationTime(theConeMosaic.integrationTime);
    theEMPaths = theConeMosaic.emGenSequence(eyeMovementsNum, 'nTrials', nTrials);
    
    % Response time axis
    responseTimeAxis = (1:eyeMovementsNum)*theConeMosaic.integrationTime + theOIsequence.timeAxis(1);
    [~,idx] = min(abs(responseTimeAxis));
    theEMPaths = bsxfun(@minus, theEMPaths, theEMPaths(:,idx,:));
    
    % Preallocate memory for the responses
    absorptionsCountSequence = zeros(nTrials, length(theConeMosaic.coneTypesHexGrid), eyeMovementsNum);
    photoCurrentSequence = absorptionsCountSequence;
    
    % Compute responses
    for iTrial = 1:nTrials
        [absorptionsCountSequence(iTrial,:,:), photoCurrentSequence(iTrial,:,:)] = ...
                theConeMosaic.computeForOISequence(theOIsequence, ...
                'emPaths', theEMPaths(iTrial,:,:), ...
                'currentFlag', true);
    end
    
    
    
    
    % Response visualization range
    absorptionsRange = [0 max(absorptionsCountSequence(:))];
    photoCurrentRange = prctile(photoCurrentSequence(:), [5 95]);
    emRange = max(abs(theEMPaths(:)))*[-1 1];
    
    
    visualizedTrial = 1;
    visualizedAbsorptions = squeeze(absorptionsCountSequence(visualizedTrial,:,:));
    visualizedPhotocurrents = squeeze(photoCurrentSequence(visualizedTrial,:,:));
    visualizedEMPath = squeeze(theEMPaths(visualizedTrial,:,:));
    
    hFig = figure(1); clf;
    videoOBJ = VideoWriter('responseVideo', 'MPEG-4'); % H264 format
    videoOBJ.FrameRate = 30;
    videoOBJ.Quality = 100;
    videoOBJ.open();
        
    for tBin = 1:numel(responseTimeAxis)
        
        subplot(3,2,1);
        plot(visualizedEMPath(1:tBin,1), -visualizedEMPath(1:tBin,2), 'k-'); hold on;
        plot(visualizedEMPath(tBin,1), -visualizedEMPath(tBin,2), 'rs'); hold off;
        set(gca, 'XLim', emRange, 'YLim', emRange);
        title(sprintf('%2.0f ms', responseTimeAxis(tBin)*1000));
        axis 'square';
        
        axHandle = subplot(3,2,3);
        theConeMosaic.renderActivationMap(axHandle, visualizedAbsorptions(:,tBin), ...
            'mapType', 'modulated disks', 'signalRange', absorptionsRange);
        
        axHandle = subplot(3,2,5);
        theConeMosaic.renderActivationMap(axHandle, visualizedPhotocurrents(:,tBin), ...
            'mapType', 'modulated disks', 'signalRange', photoCurrentRange);
        
        subplot(3,2,4);
        
        plot(responseTimeAxis(1:tBin)*1000, visualizedAbsorptions(lConeIndices, 1:tBin), 'r-'); hold on
        plot(responseTimeAxis(1:tBin)*1000, visualizedAbsorptions(mConeIndices, 1:tBin), 'g-');
        plot(responseTimeAxis(1:tBin)*1000, visualizedAbsorptions(sConeIndices, 1:tBin), 'b-');
        hold off
        
        set(gca, 'XLim', [responseTimeAxis(1) responseTimeAxis(end)]*1000, 'YLim', [min(visualizedAbsorptions(:)) max(visualizedAbsorptions(:))]);
        set(gca, 'FontSize', 16);
        xlabel('time (ms)');
        ylabel('isomerizations');
        
        subplot(3,2,6);
        plot(responseTimeAxis(1:tBin)*1000, visualizedPhotocurrents(lConeIndices, 1:tBin), 'r-'); hold on
        plot(responseTimeAxis(1:tBin)*1000, visualizedPhotocurrents(mConeIndices, 1:tBin), 'g-');
        plot(responseTimeAxis(1:tBin)*1000, visualizedPhotocurrents(sConeIndices, 1:tBin), 'b-');
        hold off
        set(gca, 'XLim', [responseTimeAxis(1) responseTimeAxis(end)]*1000, 'YLim', [min(visualizedPhotocurrents(:)) max(visualizedPhotocurrents(:))]);
        set(gca, 'FontSize', 16);
        xlabel('time (ms)');
        ylabel('pCurrent');
        
        drawnow;
        % Add video frame
        videoOBJ.writeVideo(getframe(hFig));
    end
    
    % Close video stream
    videoOBJ.close();
        
end

% SUPPORTING FUNCTIONS
% Compute the test stimulus scene 
function stimulusScene = generateStimulusScene(stimSizeDegs, stimulusRGBPrimaries, presentationDisplay)
    
    LUTbits = 12;
    stimulusRGBSettings = round(ieLUTLinear(stimulusRGBPrimaries,displayGet(presentationDisplay,'inverse gamma',2^LUTbits)));
    stimulusScene = sceneFromFile(stimulusRGBSettings,'rgb',[],presentationDisplay);
    stimulusScene = sceneSet(stimulusScene, 'h fov', stimSizeDegs);
end

function [stimulusRGB, backgroundRGB] = rgbPrimariesForSquareStimulus(pixelsNum)
    % Generate an RGBprimaries matrix for a square stimulus
    stimulusRGB = zeros(pixelsNum,pixelsNum,3)+0.5;
    backgroundRGB = stimulusRGB;
    rectWidth = pixelsNum/4;
    ii = round(pixelsNum/2) + [-round(rectWidth/2):round(rectWidth/2)];
    stimulusRGB(ii,ii,:) = 1.0;
end

