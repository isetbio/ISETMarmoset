function visualizeDefaultOptics()

    % Generate the default marmoset optics
    theOI = oiMarmosetCreate();
    
    visualizedSpatialSupportArcMin = 20;
    visualizedSpatialSfrequencyCPD = 16.0;
    visualizeOptics(theOI, 550, ...
        visualizedSpatialSupportArcMin, ...
        visualizedSpatialSfrequencyCPD);

end
