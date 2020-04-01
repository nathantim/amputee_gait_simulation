% ---------------------------
% Initialize Animation Figure
% ---------------------------

function animInit(namestr)

    % -----------------
    % Initialize Figure
    % -----------------

    % check whether figure exists already
    figExists = size(findobj('Tag',namestr),1) ~= 0;

    % if not, initialize figure
    if ~figExists
        % define figure element
        figure( ...
             'Tag',                          namestr, ...
             'Name',                         namestr, ...
             'NumberTitle',                    'off', ...
             'BackingStore',                   'off', ...
             'MenuBar',                       'default', ...
             'Color',                        [1 1 1], ...
             'Position',         [20  20  1920   1080], ...
             'Renderer',                    'OpenGL');

        % define axes element
        axes('Position', [0 0 1 1], 'FontSize', 8);
    end 

    % ----------------------------------
    % Reset Figure to Simulation Default
    % ----------------------------------

    % reset axes to default properties
    cla reset;

    % change some properties
    set(gca, 'SortMethod',   'depth', ...
           'Color',     [1 1 1], ...
           'XColor',    [0 0 0], ...
           'YColor',    [0 0 0]);

    axis image;

    hold on;

end
