% Test callback functions of legend

% XiaoCY 2024-06-03

%%
clear;clc
set(groot, 'defaultLegendItemHitFcn', @my_legend_callback)

x = linspace(0, 2*pi, 500)';
phi = linspace(0, pi, 5);
y = sin(x + phi);

figure
plot(x,y)
legend
xlabel('x')
ylabel('y')

% Now, try to click legend icon with left/mid bottom

%% callback function
function my_legend_callback(hSrc,eventData)
    % default case
    if strcmp(eventData.SelectionType, 'open') && strcmp(eventData.Region, 'label')
        startLabelEditing(hSrc, eventData.Peer);
    end

    % single click to hide/show the selected object
    if strcmp(eventData.SelectionType, 'normal') && strcmp(eventData.Region, 'icon')
        if strcmp(eventData.Peer.Visible, 'on')
            eventData.Peer.Visible = 'off';
        else
            eventData.Peer.Visible = 'on';
        end
    end

    % mid click to show only the selected object or show all
    if strcmp(eventData.SelectionType, 'extend') && strcmp(eventData.Region, 'icon')
        % get all graphic objects displayed in legend
        % results may contain 'group' object create by 'bode', ignore their children
        go = findobj(eventData.Peer.Parent, '-property', 'DisplayName');
        K = length(go);
        idx = true(K,1);
        for k = 1:K
            if isprop(go(k), 'Children')
                if isprop(go(k).Children, 'Visible')
                    idx(go == go(k).Children) = false;
                end
            end
        end
        go = go(idx);
        go_visible = [go.Visible];
        if sum(go_visible) == 1 && isequal(go(go_visible), eventData.Peer)
            for k = 1:length(go)
                go(k).Visible = 'on';
            end
        else
            for k = 1:length(go)
                go(k).Visible = 'off';
            end
            eventData.Peer.Visible = 'on';
        end
    end
end
