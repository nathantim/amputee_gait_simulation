% --------------
% Create Walkway
% --------------

function createWalkwayObject(WayCol, rCP, width)
    %set nPlates <= 0 to load walkway from file. Else, Walkway will be flat and of length specified in meters
    if nargin ==2
        width = 1;
    end

    ground = load('groundHeight.mat');
    zPts = ground.groundZ; % - rCP/2;
    xPts = ground.groundX;
    numPts = length(zPts);

    % initialize vertex and face matrices
    floorVertices = nan(2*numPts,3); %Vertices
    floorFaces = nan(numPts-1,4); %Faces
    sideVertices = nan(2*numPts,3); %SideVertices
    sideFaces = nan(numPts-1,4);     %SideFaces

    % loop through plates
    for pIdx = 1:numPts
        % add ground vertices
        floorVertices((2*pIdx-1):(2*pIdx),:) = [xPts(pIdx), -width/2, zPts(pIdx); ...
                                     xPts(pIdx),  width/2, zPts(pIdx)];

        %add side walls
        sideVertices((2*pIdx-1):(2*pIdx),:) = [xPts(pIdx), -width/2, zPts(pIdx);   ...
                                               xPts(pIdx), -width/2, -20];  

        % add faces
        lastVertex = 2*pIdx;
        if pIdx~=1
            floorFaces(pIdx-1,:) = [lastVertex-3, lastVertex-2, lastVertex, lastVertex-1];
            sideFaces(pIdx-1,:)  = [lastVertex-3 lastVertex-2 lastVertex lastVertex-1];
        end

        
    end

    % create walkway patch
    patch('Vertices', floorVertices, 'Faces', floorFaces, 'FaceColor', WayCol, ...
        'EdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
    %{
    patch('Vertices', sideVertices, 'Faces', sideFaces, 'FaceColor', WayCol, ...
        'EdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
    %}
end 
