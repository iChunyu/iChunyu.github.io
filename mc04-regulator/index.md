# 现代控制理论（4）：调节器设计


状态估计器提供了状态的估计值，在分离原理的指导下，利用估计的状态进行状态反馈能够使系统稳定。本文讨论最基本的闭环设计，即调节器设计。

<!--more-->

## 分离原理

状态反馈指出可以利用系统的状态变量的线性组合 $u=-K\mathbf{x}$ 作为被控对象的输入以稳定系统。由于系统的状态通常不易直接测得，需要通过状态估计器进行状态估计。容易想到实际的控制信号是由状态估计值提供，即 $u=-K\hat{\mathbf{x}}$ 。分离原理为这样做的可行性提供了理论依据。

设被控对象的状态空间表述为

{{< math >}}$$
\left\{
\begin{aligned}
\dot{\mathbf{x}} &= A \mathbf{x} + Bu  \\
y &= C \mathbf{x}
\end{aligned}
\right.
$${{< /math >}}

相应构建状态估计器为

{{< math >}}$$\dot{\hat{\mathbf{x}}} = A\hat{\mathbf{x}}+Bu+L\left(y-C\hat{\mathbf{x}}\right)$${{< /math >}}

则状态误差 $\tilde{\mathbf{x}}=\hat{\mathbf{x}}-\mathbf{x}$ 满足

{{< math >}}$$\dot{\tilde{\mathbf{x}}}=\left(A-LC\right)\tilde{\mathbf{x}}$${{< /math >}}

控制律为

{{< math >}}$$u=-K\hat{\mathbf{x}}=-K\left( \tilde{\mathbf{x}} + \mathbf{x} \right)$${{< /math >}}

综上，整个闭环系统的状态空间可表述为：

{{< math >}}$$
\begin{bmatrix}
    \dot{\mathbf{x}} \\
    \dot{\tilde{\mathbf{x}}}
\end{bmatrix} =
\begin{bmatrix}
    {A} - {BK} &  - {BK} \\
    0 & {A} - {LC}
\end{bmatrix}
\begin{bmatrix}
    {\mathbf{x}} \\
    \mathbf{\tilde x}
\end{bmatrix}
$${{< /math >}}

闭环的系统矩阵为上三角矩阵，其特征值为 $A-BK$ 和 $A-LC$ 的特征值。因此得到分离原理：当理想控制器和状态估计器分别稳定时，构成的系统也一定是稳定的。

根据分离原理，进行闭环设计时可以分别对控制器和状态观测器进行设计，然后将控制器所用的状态量替换为状态估计器输出的状态估计值即可。

# 调节器设计示例

设一负弹簧系统的特征角频率为 $\omega_n = 2 \\,\rm{rad/s}$ ，系统输入为加速度，输出为位移。则该系统的状态空间表述为

{{< math >}}$$
\left\{ \begin{aligned}
\mathbf{\dot x} = \begin{bmatrix}
0&1\\ 
{\omega _n^2}&0
\end{bmatrix}{\mathbf{x}} + \begin{bmatrix}
0\\ 
1
\end{bmatrix} u \\ 
y = \begin{bmatrix}
1&0
\end{bmatrix}{\mathbf{x}}
\end{aligned} \right.
$${{< /math >}}

仿真模型如下图所示，紫色区域为被控对象(Plant)，其输入为控制器的输出信号 $u$；黄色区域内为状态估计器，其内嵌一个与被控对象相同的模型，分别接收控制器输出信号 $u$ 和被控对象输出 $y=x_1$ ，通过参数 $L$ 将误差反馈到状态进行状态修正，输出状态的估计值；粉色控制律则基于理想状态反馈设计，由状态估计值和反馈增益 $K$ 计算反馈控制信号 $u$ 。

<div align=center>
    <img src=mc04a.png width=70% />
</div>

为了稳定系统，可将控制器的极点布置在 $-0.5\pm0.866j$，将状态估计器的极点布置在 $-3.5\pm3.571j$ ，可以利用 MATLAB 的 `place` 函数实现，如

``` matlab
% Plant
omgn = 2;
A = [0 1; omgn^2 0];
B = [0 1]';
C = [1 0];

% Control Law
K = place(A,B,[-0.5+0.866j -0.5-0.866j]);

% State Estimator
L = place(A',C',[-3.5+3.571j -3.5-3.571j]);
L = L';
```

参数设计完成后带入仿真，运行后结果如下图所示。由于设计了被控对象初始状态非零，因而初期存在状态误差，该误差收状态估计器调节而收敛。系统的状态和估计受到控制律约束，克服负刚度造成的不稳定影响，最终各状态稳定到零位。对比两图可见，状态估计器的带宽大于控制器的带宽，因而状态误差的收敛比状态的收敛更快。

<div align=center>
    <img src=mc04b.png width=60% />
</div>


## 参考资料

1. G.F. Franklin, J. D. Powell, and A. Emami-Naeini, Feedback Control of Dynamic Systems, 7th ed. 2014.

