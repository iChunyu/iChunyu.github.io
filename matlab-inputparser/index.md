# MATLAB 解析输入参数


为了扩展自定义函数的功能，通常会将函数重载。在 MATLAB 中，这可以通过判断输入参数的数量配合条件语句来完成。然而，当可选参数较多时，解析输入参数的条件语句会特别冗长，且这种方法难以解析键值对参数。为此，MATLAB 内置了专用于参数解析的类，本文对该其用法进简要介绍。

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
- `KeepUnmatched`：默认为 `false`，即不保留未配对的参数。如此做，函数输入未定义的参数时会给出错误；当设置其为 `true` 时，未配对的参数会以结构体的形式汇总到 `Unmatched` 属性中，可以用于传递给其他函数；
- `PartialMatching`：默认为 `true`。如此做，键值对的键如果只有部分匹配的参数，将认为正确匹配。例如上例中定义了 `'window'` 参数，实际使用时只输入 `'w'` 依然能够正确匹配；
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

### 解析输入

设置好 `inputParser` 之后，只需要使用 `p.parse(varargin{:})` 对输入进行解析即可。解析的结果将以结构体的形式汇总在 `p.Results` 中。

这里应当注意的是，`parse` 函数接受逗号分隔的列表输入，而关键字 `varargin` 是 `cell` 数组，应当使用花括号加 `:` 的形式进行转换。

如前所述，`inputParser` 默认接受结构体输入，而未配对成功的参数将会以结构体的形式存放在 `p.Unmatched` 中，因此可以将其传递给子函数。例如我自编用于画功率谱的 [`iLPSD`]({{< ref "../../signal/lpsd/index.md" >}}) 函数，内部调用了 `loglog` 画图，为了将绘图选项传递给该函数，我用到了下面的方法：

``` matlab
% 外部调用 iLPSD
iLPSD(data,fs,'LineWidth',2)

% iLPSD 内部的 inputParser 没有定义 'LineWidth' 参数，将其传递给 loglog
loglog(f,sqrt(pxx),p.Unmatched)
```

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

## 自定义输入提示

可变输入 `varargin` 和 `inputParser` 结合使用可以使函数的扩展更加灵活，但是在使用时默认不会有各个形参的提示。当函数的功能变的更加复杂时，有时候不得不查看帮助文档才能知道有哪些可选的参数配置。为此，可以配合使用一个特殊的 [`functionSignatures.json`](https://www.mathworks.com/help/matlab/matlab_prog/customize-code-suggestions-and-completions.html) 文件来自定义函数的输入提示。

提示文件的编写非常简单，我们直接从一个例子入手：

```json
{
    "iLPSD":
    {
        "inputs":
        [
            {"name": "data", "kind": "required", "type": "numeric"},
            {"name": "fs", "kind": "required", "type": ["numeric", "scalar"]},
            {"name": "Jdes", "kind": "namevalue", "type": ["numeric", "scalar"]},
            {"name": "Kdes", "kind": "namevalue", "type": ["numeric", "scalar"]},
            {"name": "xi", "kind": "namevalue", "type": ["numeric", "scalar"]},
            {"name": "window", "kind": "namevalue", "type": "function_handle"},
            {"name": "parallel", "kind": "namevalue", "type": ["logical", "scalar"]},
            {"name": "type", "kind": "namevalue", "type": "choices={'PSD', 'RMS', 'Amp'}"}
        ]
    }
}
```

该文件的第一级字段（本例中的 `"iLPSD"`）为函数的名字；第二级字段可以是 `"inputs"`、`"outputs"`、`"platforms"`，通常情况下我们只考虑对函数的输入进行提示和补全，因此绝大多数场景只需要定义 `"inputs"` 字段即可。

在 `"inputs"` 字段下，将由多个字典构成列表来对输入进行解释，其中可以包括：

- `"name"`：当前形参的名字，一般情况会与源码中的变量名保持一致；
- `"kind"`：当前形参的类型，通常是 `"required"`、`"ordered"` 或 `"namevalue"` 的一种，分别与 `inputParser` 中的 `addRequired`、`addOptional` 和 `addParameter` 对应；
- `"type"`：当前形参的数据类型。需要说明的是，这里的类型说明只是在输入阶段给予可能的更好的提示，并不真正对函数输入的形参进行有效性检查；如果没有特比的必要，该字段可以省略；
- `"repeating"`：当前形参是否可以重复，默认为 `false`。当调用函数并且按 `<Tab>` 键提供补全提示且选择了某个参数后，下一次是否重复提示该参数。一般的参数只需要配置一次，因此可以省略；
- `"purpose"`：对当前形参的进一步说明，会在键入函数时产生额外的提示，可选。

如此编写 `functionSignatures.json` 文件后，将其放在函数源码相同的文件夹内，通过 MATLAB 命令行输入 `validateFunctionSignaturesJSON` 验证该文件的有效性，而后在编辑器键入自定义函数时就可以出现形参的提示了。如果函数有多种重载，只需进行多次定义即可。

特别地，该方法适用于类和包的代码补全，对于类函数，第一级字段的格式为 `"类名.函数名"`，其他的规则相同。如果类和包采用独立的文件夹管理，`functionSignatures.json` 应当与 `@class` 和 `+package` 放在同一路径下。

