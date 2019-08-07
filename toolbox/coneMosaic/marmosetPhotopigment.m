function thePhotopigment = marmosetPhotopigment() 

    useHumanData = true;
    if (useHumanData)
        thePhotopigment = photoPigment();
        return;
    end
    
    % Load the marmoset cone absorbance spectra
    load('treeshrewConeAbsorbanceSpectra.mat', 'wavelength', 'data');
    fprintf(2, 'Warning. Loading treeshrew cone absorbances');

    % Max values of optical densities
    peakOpticalDensitiesLS = max(data,[],1);

    normalizedAbsorbanceSpectra = zeros(numel(wavelength),3);
    % L-cone normalized absorbance spectra
    normalizedAbsorbanceSpectra(:,1) = data(:,1)/peakOpticalDensitiesLS(1);
    % S-cone normalized absorbance spectra
    normalizedAbsorbanceSpectra(:,3) = data(:,2)/peakOpticalDensitiesLS(2);


    % Generate treeshrew-specific cone photopigments
    thePhotopigment = photoPigment(...
        'wave', wavelength, ...
        'absorbance', normalizedAbsorbanceSpectra, ...
        'opticalDensity', [peakOpticalDensitiesLS(1) 0 peakOpticalDensitiesLS(2)], ...
        'peakEfficiency', 0.5*[1 1 1]);


end