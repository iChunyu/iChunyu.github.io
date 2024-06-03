---
title: "MATLAB 自定义交互式图例"
date: 2024-06-03T23:33:22+08:00
tags: ["MATLAB"]
categories: ["MATLAB"]
draft: false
---

在进行数据分析时，有时我们会将一系列相关的曲线画到一起进行对比，对于数据存在部分重叠的情况，我们希望临时地将某些曲线隐藏。为了在 MATLAB 中实现这个功能，可以使用 `legend` 的回调函数。本文将简要讨论这种交互式功能的实现。

<!--more-->


## 图例的回调函数简介

回调函数是一类由事件触发的函数，图例的回调函数能够让我们在与图例进行交互时进行一些额外的动作。例如，默认情况下，双击图例的文字部分将触发交互式编辑器，可以对文字内容进行修改。

为了自定义回调函数，首先需要知道该函数的基本格式。我们可以在命令行中运行以下命令查看默认的回调函数以作参考：

```matlab
get(groot, 'factoryLegendItemHitFcn')       % 默认回调函数为 defaultItemHitCallback
edit('defaultItemHitCallback.m')            % 打开默认的回调函数
```

该回调函数接受两个输入参数，参考 MATLAB 帮助文档中 [图例的外观和行为](https://mirrors.tuna.tsinghua.edu.cn) 可知：

- 第一个参数 `hSrc` 为被点击的图例对应的函数句柄。换句话说，如果点击的图例对应第三条曲线，则 `hSrc` 就是第三条曲线的函数句柄；
- 第二个参数 `eventData` 是关于事件数据的结构体，其包含如下字段：
    - `Peer`：被点击的图例对应的函数句柄，与第一个参数 `hSrc` 相同；
    - `Region`：点击的位置，可以是 `'icon'`（曲线形式的图标）或 `'label'`（曲线的名字）；
    - `SelectionType`：点击方式，可以是 `'normal'`（左键单击）、`'extend'`（中键单击）、`'open'`（左键双击）等。需要注意的是，双击时，第一次点击会先触发 `'normal'` 事件，这就意味着交互式功能尽量不要简单地通过单击和双击进行区分，否则会产生意想不到的效果；
    - `Source`：被点击的 `legend` 对象；
    - `EventName`：事件名称，固定为 `'ItemHit'`。

因此，图例的回调函数应当具有如下的基本模板：

```matlab
function my_legend_callback(hSrc, eventData)
    % code here
end
```

下面将讨论交互式功能的具体实现。


## 交互功能设计

关于图例的交互，首先我们希望保留默认的编辑功能：左键双击图例文字时可以触发交互式编辑器，因而回调函数中应当保留原始代码：

```matlab
% default case
if strcmp(eventData.SelectionType, 'open') && strcmp(eventData.Region, 'label')
    startLabelEditing(hSrc, eventData.Peer);
end
```

此外，希望左键单击图例中的曲线时，如果对应的曲线是可见的，则将其隐藏；反之则将其显示。为此可以读取选中曲线的 `Visible` 属性，并将其置反即可：

```matlab
% single click to hide/show the selected object
if strcmp(eventData.SelectionType, 'normal') && strcmp(eventData.Region, 'icon')
    if strcmp(eventData.Peer.Visible, 'on')
        eventData.Peer.Visible = 'off';
    else
        eventData.Peer.Visible = 'on';
    end
end
```

当曲线比较多，需要批量操作时，可以考虑：中键单击图例中的曲线时，如果有其他曲线可见，则隐藏其他曲线，只保留被选中的曲线；如果只有被选中的曲线可见，则将全部曲线可见。

这个功能稍微有些复杂，因为我们还要找到图例中其他图形元素的句柄。考虑到能够显示在图例中的对象（除了 `Line`，还有 `Patch` 等）都有 `'DisplayName'` 这一参数，因此可以使用 `findobj` 并配合 `'-property'` 参数查找具有指定参数的句柄。因而这个功能可以由下面的代码实现：

```matlab
% mid click to show only the selected object or show all
if strcmp(eventData.SelectionType, 'extend') && strcmp(eventData.Region, 'icon')
    % get all graphic objects displayed in legend
    go = findobj(eventData.Peer.Parent, '-property', 'DisplayName');
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
```

将上面的代码整合到回调函数模板中，就构成了满足我们需求的回调函数。将其另存为 `my_legend_callback.m`，绘图之后在创建图例时使用额外的键值对参数 `legend(_, 'ItemHitFcn', @my_legend_callback)` 指明回调函数，则可以实现图例的交互式操作。


## 小技巧

刚开始接触回调函数时，我们可能并不清楚要求的回调函数具有几个输入参数，也不知道各个输出参数是什么。除了查看帮助文档外，我们可以构建一个临时的回调函数，利用 `assignin` 将输入参数强行输出到工作空间：

```matlab
function test_callback(varargin)
    fprintf('Num of variables: %d\n', nargin);
    for k = 1:nargin
        assignin('base', ['var', num2str(k)], varargin{k})
    end
end
```

当触发该回调函数时，命令行将会输出参数的数量，并按顺序将各个输入参数导出为 `var1`、`var2` 等变量。如此做，我们可以非常清楚地了解各个输入参数的形式，并且通过命令行逐步地调试所需的功能。然而需要特别注意的是，`assignin` 函数会覆盖工作空间的同名变量，因而在函数内部使用 `assignin` 通常是不推荐的。

另外，如果希望将这种交互式功能保存为默认的行为，可以参考 [MATLAB 自定义默认绘图样式]({{< ref "../initplot/index.md" >}})，使用 `set(groot, 'defaultLegendItemHitFcn', @my_legend_callback)` 将自定义的回调函数设为默认值。


最后分享一个完整的示例供大家测试：

```matlab
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
        go = findobj(eventData.Peer.Parent, '-property', 'DisplayName');
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
```
