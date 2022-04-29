---
title: "MATLAB 解析输入参数"
date: 2022-04-29
tags: ["MATLAB","参数解析"]
categories: ["MATLAB"]
draft: false
---

为了扩展自定义函数的功能，通常会将函数重载。在 MATLAB 中，这可以通过关键字 `nargin` 配合条件语句来完成。然而，当可选参数较多时，解析输入参数的条件语句会特别冗长，且这种方法难以解析键值对参数。为此，MATLAB 内置了 `inputParser` 类专门用于参数解析。本文对该其用法进简要介绍。

<!--more-->

## 条件语句的限制

我们在之前介绍 [MATLAB 编写函数]({{< ref "../MATLAB-function/index.md" >}}) 时提到过关键字 `nargin` 可以用来判断函数输入参数的数量，据此可以编写条件语句实现重载，其基本格式为：

``` matlab
function varargout = fun(varargin)
    % 解析输入变量
    switch nargin
        case 0
            <导入输入变量默认值>
        case 1
            <变量1> = varargin{1};
            <其他变量取默认值>
        otherwise
            error('无效输入')
    end

    % 函数主体
    % ...
end
```

输入较少时，这种方法是十分便捷的。但如果函数提供了多个可选项，这种写法会带来不便：（1）编写程序时，`switch` 语句会特别冗长，以适应不同输入参数情况下解析；（2）只使用参数数目进行判断，参数通常是位置敏感的。例如，使用时想对第三个参数进行修改，必须输入第二个参数（除非第二个参数和第三个参数具有不同的数据类型，在编写 `switch` 时可以进一步进行数据类型判断）；（3）这种方法不容易实现形如 `'Name',Value` 这种键值对输入；（4）当自定义函数嵌套其他函数时，难以将多余的键值对参数传递给其他函数。因此，当自定义函数提供多个可选输入时，应当使用更好的参数解析方法。MATLAB 提供了 `inputParser` 类专门用于解析输入参数。

## 输入解析器简介

我们从下面一个（局部的）例子开始说起：

``` matlab
% 声明输入解析器并进行设置
p = inputParser;
p.FunctionName = 'myFunc';
p.KeepUnmatched = true;

% 定义参数
p.addRequired('data');
p.addOptional('fs',1);
p.addParameter('window',@hann);

% 解析参数
p.parse(varargin{:})
data = p.Results.data;
fs = p.Results.fs;
window = p.Results.window;
passOpts = p.Unmatched;
```

### 声明与设置

首先我们声明一个输入解析器 `p = inputParser`，如果不打分号将会在命令行输出其属性，其中可以进行设置的为

- `FunctionName`：默认为空。通常设置为 `inputParser` 所在函数的名字，这样可以在出错是给出是在哪个函数发生的；
- `CaseSensitive`：默认为 `false`，即大小写不敏感。这样在输入键值对参数是，键的大小写不会影响解析；
- `KeepUnmatched`：默认为 `false`，即不保留未配对的参数。如此做，函数输入未定义的参数时会给出错误；当设置其为 `true` 时，未配对的参数会汇总到 `Unmatched` 属性中，可以用于传递给其他函数；
- `PartialMatching`：默认为 `true`。如此做，键值对的键如果只有部分匹配的参数，将认为正确匹配。例如上例中定义了 `’window‘` 参数，实际使用时只输入 `’w'` 依然能够正确匹配；
- `StructExpand`：默认为 `true`。如此做，当输入结构体时，会按照键值对的方式展开进行匹配。

### 添加参数

声明输入解析器并设置完成后，开始添加参数：

`addRequired` 用于添加必要参数，应当放在其他参数设置之前。当函数有多个必要参数时，可以多次使用该函数定义参数。需要注意的是，必要参数是位置敏感的，定义的顺序与调用函数时的输入顺序一致。例如，使用以下代码声明了函数 `myFunc` 的两个必要参数

``` matlab
% 局部代码
p.addRequired('p1');
p.addRequired('p2');
```

在使用 `myFunc(1)` 时，因为缺少必要参数 `p2` 会出错；使用 `myFunc(1,2)` 时，会按照参数顺序和定义顺序，将 $1$、$2$ 分别赋值给 `p1`、`p2`。

`addOptional` 用于添加可选参数，且该参数是位置敏感的，相应的位置与定义的顺序一致。由于该参数是可选的，定义时需要给出默认值。例如下面的局部代码：

``` matlab
% 局部代码
p.addRequired('p1');
p.addOptional('p2',2);
p.addOptional('p3',3);
```

此时，如果只调用 `myFunc(1,-1)`，则会将 $1$ 赋值给必要参数 `p1`；$-1$ 赋值给可选参数 `p2`；而由于没有第三个输入，可选参数 `p3` 将保持默认值 $3$。

由于参数对位置敏感，这种方法无法只输入 `p1` 和 `p3`，与前面讨论的 `nargin` 加条件语句的限制一致。为此，可以使用位置不敏感的键值参数。

`addParameter` 用于添加键值对参数，其对位置不敏感，特别适合输入参数较多的情况。同样由于该参数是可选的，定义时需要给出默认值。我们将上面的可选输入改为键值参数，有

``` matlab
% 局部代码
p.addRequired('p1');
p.addParameter('p2',2);
p.addParameter('p3',3);
```

这样，如果只想输入 `p1` 和 `p3`，只要形如 `myFunc(1,'p3',2)` 调用即可。

## 参数有效性验证

添加参数时，可以同时对参数的有效性进行验证，这只需要在定义参数时额外给出验证函数的函数句柄即可，例如

``` matlab
% 局部代码
p.addRequired('p1',@(x)isnumeric(x));
```

需要说明的是，用于验证参数有效性的函数必须只接收一个输入，且输出必须是逻辑变量 `true` 或 `false`。我们可以根据需求自定义验证函数，也可以使用 MATLAB 内置的函数，详细可以查看 [状态检测](https://ww2.mathworks.cn/help/matlab/ref/is.html)，这些函数基本上都可以顾名思义，因此这里不再展开。

最后介绍两个非常好用的内置函数：`validateattributes` 用于验证参数的类型和属性；`validatestring` 用于在给定范围内匹配字符。

`validateattributes(A,classes,attributes)` 用于验证给定参数 `A` 是否在允许的 `class` 类型中，且其属性（例如矩阵的维度）是否满足 `attributes` 中的某个约束。

`matchedStr = validatestring(str,validStrings)` 将字符串 `str` 与选项 `validStrings` 进行对比，当匹配某个选项时将该选项输出。特别地，该函数可以设置忽略大小写，且可以局部匹配，可以避免使用时输入不准确导致程序无法运行。
