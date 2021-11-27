# MATLAB 符号计算


理工科研究经常会涉及到各种公式推导，其中又难免涉及变量多、形式复杂的公式。这时可以使用 MATLAB 的符号计算工具包辅助完成。本文对此工具包进行简要介绍。

<!--more-->


## 定义符号变量

在进行符号计算之前，需要提前定义符号变量，这可以通过函数 `sym` 和 `syms` 来完成。其中 `syms` 常用来批量定义符号变量，例如下面的第一行代码就同时定义了 $x$ 、 $y$ 、$z$ 三个符号变量，各符号变量之间用空格分开。

``` matlab
syms x y z
```

利用 `syms` 所定义的符号变量，其变量名与符号相同。若想为符号另外指定变量名，可采用 `sym` 的方式，如：

``` matlab
w0 = sym('omega_0');
rs1 = sym('r_i_s');
rs2 = sym('r_i__i_s');
Vprms = sym('V_p_rms');
```

在声明符号名时（单引号里边的字符串），下划线可以看作特殊的分隔符。单个下划线后面的字符表示下标，这与LaTeX相似，并且可以多次采用单下划线对下标进行分割，这会在最后导出LaTeX代码时自动插入逗号。类似地，若想为符号名加上标，可以连用两个下划线，其后的字符表示上标。例如上面所定义的四个符号变量分别代表以下符号：

| 符号变量 | 符号名               |
|----------|----------------------|
| w0       | $\omega _{0}$        |
| rs1      | $r_{i,s}$            |
| rs2      | $r_{i,s}^{i}$        |
| Vprms    | $V_{p,\mathrm{rms}}$ |

使用下划线为符号指定下标和上标时，上标或下标的声明顺序无关紧要，即无所谓先用连续下划线指定上标还是先用单下划线指定下标，甚至上下标交叉指定都不影响符号名。但分割指定多个上下标时，符号名下标的顺序与变量名声明时的顺序一致。例如上面 $r_{i,s}^{i}$ 的定义，下标先指定的是 $i$ ，因此符号名的下标中 $i$ 在前。这一点对一些表示相对关系的符号中至关重要。

除此之外， `sym` 还可以指定符号变量的维度，MATLAB会自动补充索引，如下：

``` matlab
r = sym('r',[1 3]);         % r = [ r1, r2, r3 ]
```

一般情况下，MATLAB会自动地将符号名末尾的数字标识为下标，但也可以在定义变量名时候可以特殊地用 `%d` 显式指定索引出现的位置，如

``` matlab
r1 = sym('r_%d',[1 3]);     % 行向量，索引指定为下标
r2 = sym('r__%d',[1 3]);    % 行向量，索引指定为上标
A = sym('A_%d__%d',[3 3]);  % 矩阵，行列索引分别为下标和上标
```

定义完符号变量后，我们还可以使用 `assume` 命令对变量进行约束，例如我们可以对符号变量 `x` 进行如下设置


| 约束条件                           | 命令                                  |
|------------------------------------|---------------------------------------|
| 实数                               | assume(x,'real')                      |
| 有理数                             | assume(x,'rational')                  |
| 正数                               | assume(x,'positive')                  |
| 正整数                             | assume(x,{'positive','integer'})      |
| 小于 -1 或大于 1                   | assume(x\<-1 \| x>1)                  |
| 2\~10 之间的整数                   | assume(in(x,'integer') & x>2 & x\<10) |
| 不是整数                           | assume(\~in(z,'integer'))             |
| 不为零                             | assume(x \~= 0)                       |
| 偶数                               | assume(x/2,'integer')                 |
| 奇数                               | assume((x-1)/2,'integer')             |
| 大于 0 且小于 $2\pi$               | assume(x>0 & x\<2\*pi)                |
| $\pi$ 的整数倍                     | assume(x/pi,'integer')                |


## 符号计算示例

我们以计算微分方程为例展示符号计算的一般步骤。假设待求解的微分方程为弹簧-质量-阻尼系统动力学方程：

{{< math >}}$$\ddot x + 2 \xi \omega_0 \dot x + \omega_0^2 = sin(\omega t)$${{< /math >}}

设初始位移为 $x_0$ ，初速度为 $v_0$ ，求解位移响应 $x(t)$ 。

我们可以采用以下代码：

``` matlab
% 定义符号变量
syms x(t) xi x0 v0 t
ain = sym('a_in','real');   % 定义变量的同时引入约束
w = sym('omega','real');
w0 = sym('omega_0','real');

% 引入阻尼比约束
assume(x0,'real')
assume(v0,'real')
assume(xi<1 & xi>0)

% 构造微分方程
dx = diff(x);               % 需要单独定义一阶导数才能引入初速度约束
d2x = diff(x,2);
eq = d2x + 2*xi*w0*dx + w0^2*x == ain;
disp(eq)

% 求解微分方程
S = dsolve(eq,[x(0)==0, dx(0)==v0]);
S = simplify(S)
```

最后解得

{{< math >}}$$
\frac{a_{\mathrm{in}}}{{\omega _{0}}^2}-\frac{a_{\mathrm{in}}\,{\mathrm{e}}^{-\omega _{0}\,t\,\xi }\,\cos\left(\omega _{0}\,t\,\sqrt{1-\xi ^2}\right)}{{\omega _{0}}^2}-\frac{{\mathrm{e}}^{-\omega _{0}\,t\,\xi }\,\sin\left(\omega _{0}\,t\,\sqrt{1-\xi ^2}\right)\,\left(a_{\mathrm{in}}\,\xi -\omega _{0}\,v_{0}\right)}{{\omega _{0}}^2\,\sqrt{1-\xi }\,\sqrt{\xi +1}}
$${{< /math >}}

## 输出计算结果

如果采用 MATLAB 的实时脚本运行上面的代码，MATLAB 将会自动将公式转化为 $\\LaTeX$ 公式，如下图所示：

<div align=center>
    <img src=symbolic.png width=80% />
</div>

更一般地，我们更希望将计算结果转化为 $\\LaTeX$ 代码，通过 MathType 或 $\\LaTeX$ 整合到文档中，这时可以使用 `latex` ，如：

``` matlab
>> latex(S)

ans =

    '\frac{a_{\mathrm{in}}}{{\omega _{0}}^2}-\frac{a_{\mathrm{in}}\,{\mathrm{e}}^{-\omega _{0}\,t\,\xi }\,\cos\left(\omega _{0}\,t\,\sqrt{1-\xi ^2}\right)}{{\omega _{0}}^2}-\frac{{\mathrm{e}}^{-\omega _{0}\,t\,\xi }\,\sin\left(\omega _{0}\,t\,\sqrt{1-\xi ^2}\right)\,\left(a_{\mathrm{in}}\,\xi -\omega _{0}\,v_{0}\right)}{{\omega _{0}}^2\,\sqrt{1-\xi }\,\sqrt{\xi +1}}'
```

如果大家仔细观察MATLAB转换的LaTeX代码，会发现它对希腊字母进行了识别和转换，对字符串下标也进行了识别并利用 `\mathrm{}` 将其转化为正体。如果再仔细一些，自然对数的底 $\mathrm{e}$ 也是正体。可见MATLAB对这种细节的处理非常到位。

生成的代码较长时，可以使用 `clipboard` 命令将结果直接复制到系统剪切板中：

``` matlab
texCode = latex(S);
clipboard('copy',texCode)
```

