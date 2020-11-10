% --------------
% Create Walkway
% --------------

function zPlates = createWalkwayObject(WayCol, rCP, width)
    %set nPlates <= 0 to load walkway from file. Else, Walkway will be flat and of length specified in meters
    if nargin ==2
        width = 1;
    end

    zPlates = load('groundHeight.mat');
    zPlates = zPlates.groundy - rCP/2;
    nPlates = length(zPlates);

    % initialize vertex and face matrices
    VM = []; %Vertices
    FM = []; %Faces
    sideVertices = []; %SideVertices
    sideFaces = []; %SideFaces
    PlateLength = 1; %[m]

    % loop through plates
    for pIdx = 1:nPlates
        % add four plate vertices
        VM = [                                     VM; ...
              (pIdx-1)*PlateLength -width/2 zPlates(pIdx); ...
              (pIdx-1)*PlateLength  width/2 zPlates(pIdx); ...
                  pIdx*PlateLength -width/2 zPlates(pIdx); ...
                  pIdx*PlateLength  width/2 zPlates(pIdx)];

        % add two faces (vertical from previous plate to new plate
        % and horizontal for the new plate)
        LastVertex = 4*pIdx;

        if pIdx==1
            FM = [LastVertex-3 LastVertex-2 LastVertex LastVertex-1];
        else
            FM = [                                                 FM; ...
                  LastVertex-5 LastVertex-4 LastVertex-2 LastVertex-3; ...
                  LastVertex-3 LastVertex-2 LastVertex   LastVertex-1];
        end

    end

    [xd, zd] = stairs(0:(nPlates-1),zPlates);
    xd(end+1) = 100;
    zd(end+1) = zd(end);
    yd = -width/2*ones(size(xd));
    for i = 1:nPlates
       sideVertices = [                   sideVertices; ...
                        xd(2*i-1), -width/2, zd(2*i-1); ...
                        xd(2*i),   -width/2, zd(2*i);   ...
                        xd(2*i-1), -width/2, -20;       ...
                        xd(2*i),   -width/2, -20];      ...
        
        LastVertex = 4*i;
        sideFaces = [                                         sideFaces; ...
                     LastVertex-3 LastVertex-2 LastVertex LastVertex-1];
    end

    % create walkway patch
    patch('Vertices', VM, 'Faces', FM, 'FaceColor', WayCol, ...
        'EdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
    patch('Vertices', sideVertices, 'Faces', sideFaces, 'FaceColor', WayCol, ...
        'EdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
end 
