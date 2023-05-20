---
title: "MATLAB 自定义默认绘图样式"
date: 2023-05-20T18:54:52+08:00
tags: ["MATLAB"]
categories: ["MATLAB"]
draft: false
---

为了让 MATLAB 绘制的曲线好看，通常需要使用各种参数设置绘图样式，这会使得绘图代码重复且冗长。本文将介绍如何自定义 MATLAB 的默认绘图样式以简化绘图命令。

<!--more-->

## 基本思路

MATLAB 绘图相关的默认选项由 `groot`（Graphics root object）的属性决定，使用 `get` 命令可以查看相应参数的默认值。例如，`plot` 的默认线宽可以使用以下代码查看：

```matlab
get(groot,'defaultLineLineWidth')
```

因此，自定义绘图样式的思路非常简单：只需要使用 `set` 命令重新设置 `groot` 的属性值即可。例如：

```matlab
set(groot,'defaultLineLineWidth',2)
```

如此做，在关闭 MATLAB 之前，除非在绘图时显式地指定线宽，所有 `plot` 的线宽都将设置为 2。


## 自定义样式

为了查看 `groot` 的所有默认属性，可以使用如下命令：

```matlab
get(groot,'factory')
```

这些属性通常都是可以顾名思义的，为了修改其默认值，只需要结合 `set` 命令，并将属性开头的 `factory` 改为 `default` 即可，例如：

```matlab
% factoryFigureColor = [0.9400, 0.9400, 0.9400]     % 默认图片背景为灰色
set(groot,'defaultFigureColor',[1,1,1])             % 设置图片背景为白色
```

根据个人喜好和常用的设置，可以编写一个脚本或者函数对默认值进行设置。特别地，可以将自定义的绘图样式写在特定的 `startup.m` 脚本文件中从而达到 MATLAB 启动时自动配置的目的。可行的示例如下：

```
% 创建 startup.m 文件
edit(fullfile(userpath,'startup.m'))

% setup.m 内容示例
set(groot,'defaultFigureColor',[1,1,1])         % 背景颜色
set(groot,'defaultLineLineWidth',2)             % 绘图线宽
set(groot,'defaultAxesFontSize',20)             % 坐标字号
set(groot,'defaultAxesXGrid','on')              % 横轴网格
set(groot,'defaultAxesYGrid','on')              % 纵轴网格
```

简要介绍几个与 `plot` 相关的参数：

- `defaultFigureColor`：绘图区的背景颜色，建议设置为白色以避免直接截图时出现灰色边框；
- `defaultFigureWindowStyle`：绘图窗口样式，可选项有 `'normal'`、`'modal'` 和 `'docked'`；
- `defaultAxesFontName`：坐标区字体；
- `defaultAxesXGrid`：横轴网格；
- `defaultAxesYGrid`：纵轴网格；
- `defaultAxesZGrid`：竖轴网格；
- `defaultAxesColorOrder`：曲线的颜色顺序，十六进制的字符串向量或 {{< math >}}$N \times 3${{< /math >}} 数值矩阵。如果是数值矩阵，每行的三个元素分别对应颜色的归一化 RGB 值。绘图时将按照该颜色顺序渲染曲线；
- `defaultAxesFontSize`：坐标区字号；
- `defaultLineLineWidth`：线宽；
- `defaultTextFontSize`：绘图区文本字号；
- `defaultAxesTickLabelInterpreter`：坐标区标注的解释器，可选项有 `'tex'`、`'latex'` 和 `'none'`；
- `defaultTextInterpreter`：文本解释器；
- `defaultLegendInterpreter`：图例解释器。


## 封装函数

对于不同的操作系统和屏幕分辨率，相同设置下的绘图效果可能存在差异。例如相同线宽和字号的设置下，高分辨率屏幕显示的曲线偏细、字体偏小。为了解决这个问题，可以将绘图样式封装为函数，并将这些可变的样式作为函数的输入参数。例如：将线宽和字号留作设置的接口，自定义的函数形如：

```matlab
function InitPlot(linwidth,fontsize)
    set(groot,'defaultLineLineWidth',linewidth)     % 绘图线宽
    set(groot,'defaultAxesFontSize',fontsize)       % 坐标字号
    % 其他设置
    % ...
end
```

如此做，对于不同的平台，`startup.m` 中使用不同的参数调用该函数即可：

```matlab
InitPlot(2,20)  % Windows
InitPlot(3,25)  % Linux
```

在某些特殊的情况下，我们希望将自定义的样式恢复为默认样式，这可以将参数值设置为 `‘remove’` 来恢复，例如：

```matlab
set(groot,'defaultAxesFontSize','remove')           % 恢复默认字号
```

为了便于切换样式，我们可以将自定义的样式储存在 `cell` 数组中，每一行的两个参数分别为属性名称和自定义的属性值，通过 `for` 循环来批量设置和恢复，局部代码如下：

```matlab
mystyle = {
    'defaultFigureColor'   , 'w'
    'defaultAxesFontName'  , 'Serif'
    'defaultAxesXGrid'     , 'on'
    'defaultAxesYGrid'     , 'on'
    'defaultAxesZGrid'     , 'on'
};

% --------------------------------
% 设置自定义样式
for k = 1:size(myStyle,1)
    set(groot,myStyle{k,1},myStyle{k,2})
end

% --------------------------------
% 恢复出厂设置
for k = 1:size(myStyle,1)
    set(groot,myStyle{k,1},'remove')
end
```

最后分享一下我自用的绘图设置函数：

```matlab
% Inilitialize plotting settings
% InitPlot(linewidth,fontsize,windowstyle,interpreter)
% InitPlot('remove') to restore factory settings

% XiaoCY 2022-02-22

%%
function InitPlot(varargin)
    p = inputParser;
    p.addOptional('linewidth',2);
    p.addOptional('fontsize',20);
    p.addOptional('windowstyle','docked',@(s)ischar(s)||isstring(s));
    if ispc % Windows
        interpreter = 'tex';
    else
        interpreter = 'latex';
    end
    p.addOptional('interpreter',interpreter,@(s)ischar(s)||isstring(s));

    if nargin == 1 && ( ischar(varargin{1}) || isstring(varargin{1}) )
        if strcmpi(varargin{1},'remove')
            useMyStyle = false;
            p.parse;
        end
    else
        useMyStyle = true;
        p.parse(varargin{:});
    end

    linewidth = p.Results.linewidth;
    fontsize = p.Results.fontsize;
    windowstyle = p.Results.windowstyle;
    interpreter = p.Results.interpreter;

    colorVec = [
        0.1765    0.5216    0.9412  % blue
        0.9569    0.2627    0.2353  % red
        0.0392    0.6588    0.3451  % green
        1.0000    0.7373    0.1961  % yellow
        0.9843    0.4471    0.6000  % pink
        0.4980    0.4980    0.4980  % gray
        0.7373    0.7412    0.1333  % olive
        0.0902    0.7451    0.8118  % cyan
        ];

    % Run get(groot,'factory') to see what you can change.
    myStyle = {
        % figure
        'defaultFigureColor'                   , 'w'
        'defaultAxesFontName'                  , 'Serif'
        'defaultAxesXGrid'                     , 'on'
        'defaultAxesYGrid'                     , 'on'
        'defaultAxesZGrid'                     , 'on'
        'defaultConstantLineAlpha'             , 1
        'defaultAxesColorOrder'                , colorVec
        'defaultFigureWindowStyle'             , windowstyle
        'defaultAxesFontSize'                  , fontsize
        'defaultTextFontSize'                  , fontsize
        'defaultConstantLineFontSize'          , fontsize
        'defaultLineLineWidth'                 , linewidth
        'defaultConstantLineLineWidth'         , linewidth
        'defaultAnimatedlineLineWidth'         , linewidth
        'defaultStairLineWidth'                , linewidth
        'defaultStemLineWidth'                 , linewidth
        'defaultContourLineWidth'              , linewidth
        'defaultFunctionlineLineWidth'         , linewidth
        'defaultImplicitfunctionlineLineWidth' , linewidth
        'defaultErrorbarLineWidth'             , linewidth
        'defaultScatterLineWidth'              , linewidth
        'defaultAxesTickLabelInterpreter'      , interpreter
        'defaultConstantlineInterpreter'       , interpreter
        'defaultTextInterpreter'               , interpreter
        'defaultLegendInterpreter'             , interpreter
        'defaultColorbarTickLabelInterpreter'  , interpreter
        'defaultGraphplotInterpreter'          , interpreter
        'defaultPolaraxesTickLabelInterpreter' , interpreter
        'defaultTextarrowshapeInterpreter'     , interpreter
        'defaultTextboxshapeInterpreter'       , interpreter
        };

    if useMyStyle
        for k = 1:size(myStyle,1)
            set(groot,myStyle{k,1},myStyle{k,2})
        end
    else
        for k = 1:size(myStyle,1)
            set(groot,myStyle{k,1},'remove')
        end
    end
end
```
