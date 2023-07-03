---
title: "模型嵌入控制（2）：被控对象建模"
date: 2023-07-03T13:43:36+08:00
tags: ["EMC","模型嵌入控制"]
categories: ["Embedded Model Control"]
draft: false
---

被控对象以可控动态为核心，进一步引入了扰动动态，其数值实现称为嵌入模型（Embedded Model），是模型嵌入控制设计的基础。本文针对线性时不变（LTI：Linear Time-Invariant）系统建模，给出可控动态和扰动动态离散时间的状态空间表述。

<!--more-->

## 可控动态建模

可控动态是对被控对象物理特性的描述，我们之前在[系统的描述]({{< ref "../../control/MC01-SysDiscription/index.md" >}})中讨论过线性时不变系统的三种描述方法，在此简要复述为：

- 微分方程：被控对象的特性通常可以根据一定的物理原理建立微分方程，这是描述系统特性最基本的数学手段；
- 传递函数（或传递函数矩阵）：系统微分方程的拉普拉斯变换，直接地给出了输入输出关系，是频域设计和分析的依据；
- 状态空间方程：微分方程的等价描述，由于进一步定义了系统状态而能够对系统进行更加精细的描述。离散形式的状态空间还有给出了数值系统的具体实现。

我们假设读者已经具备连续时间系统的建模能力，设被控对象的状态空间微分方程为：

{{< math >}}$$
\left\{\begin{aligned}
    \dot{\bm{x}} &= A \bm{x} + B \bm{u} \\
    \bm{y} &= C \bm{x} + D \bm{u}
\end{aligned}\right.
$${{< /math >}}

其中 {{< math >}}$\bm{x}${{< /math >}} 为系统的状态向量，{{< math >}}$\bm{y}${{< /math >}} 为输出，{{< math >}}$A${{< /math >}}、{{< math >}}$B${{< /math >}}、{{< math >}}$C${{< /math >}}、{{< math >}}$D${{< /math >}} 分别为状态矩阵、输入矩阵、输出矩阵和直馈矩阵。通常情况下 {{< math >}}$D=0${{< /math >}}，在后面的讨论中将省略。

可控动态是对被控对象在离散时间下的建模，换言之，需要将上述连续时间的状态空间方程依据采样时间 {{< math >}}$T${{< /math >}} 离散化。在一阶近似下，状态微分可以由微分代替，为：

{{< math >}}$$
    \dot{\bm{x}} \approx \frac{1}{T} \bigl( \bm{x}_c(iT+T) - \bm{x}_c(iT) \bigr)
$${{< /math >}}

记 {{< math >}}$\bm{x}_c${{< /math >}} 为可控动态的状态变量。为了表述的方便，后续离散时间状态变量的索引中将省略采样时间 {{< math >}}$T${{< /math >}}，改写为 {{< math >}}$\bm{x}_c(iT) \rightarrow \bm{x}_c(i)${{< /math >}}。如此做，可控动态的状态空间方程为：

{{< math >}}$$
\left\{\begin{aligned}
    & \bm{x}_c(i+1) = A_c \bm{x}_c(i) + B_c \bm{u}(i) + \bm{d}(i) \\
    & \bm{y}(i) = C_c \bm{x}_c(i) + C_d \bm{x}_d(i)
\end{aligned}\right.
$${{< /math >}}

其中，{{< math >}}$A_c = I+AT${{< /math >}}，{{< math >}}$B_c = BT${{< /math >}}，{{< math >}}$C_c = C${{< /math >}}。可控动态中引入了输入端扰动 {{< math >}}$\bm{d}${{< /math >}} 和输出端扰动 {{< math >}}$C_d \bm{x}_d${{< /math >}}。在一定的情况下（通常是多个传感器同时测量时），状态预测器能够对被控对象输出端的扰动（如传感器零偏）进行预测，因此不失一般性地可以在输出端引入 {{< math >}}$C_d \bm{x}_d${{< /math >}} 以显式表达该扰动的影响，后面将通过控制律设计对这部分扰动进行补偿。

在连续时间系统的离散化中，如果一阶近似带来较大误差，严格的建模应当从微分方程通解的积分中获得。对于线性时不变系统，状态方程的通解为：

{{< math >}}$$
\bm{x}(t) = \mathrm{e}^{A(t-t_0)} \bm{x}(t_0) + \int_{t_0}^t \mathrm{e}^{A(t-\tau)} B \bm{u}(\tau) \,\mathrm{d} \tau
$${{< /math >}}

取 {{< math >}}$t_0 = iT${{< /math >}}，{{< math >}}$t = (i+1)T${{< /math >}}，并设在 {{< math >}}$iT \le t < (i+1)T${{< /math >}} 时间内指令 {{< math >}}$\bm{u}(t)${{< /math >}} 保持不变，因此离散后的矩阵为：

{{< math >}}$$
A_c = \mathrm{e}^{AT} ,\quad B_c = \int_0^T \mathrm{e}^{A\tau} B \, \mathrm{d} \tau
$${{< /math >}}


## 扰动动态建模

由于扰动具有一定的随机性，扰动动态通常依赖于扰动的统计特性。将扰动看作随机噪声 {{< math >}}$\bm{w}${{< /math >}} 经过扰动动态的输出，于是从频域上可以将扰动动态看作噪声滤波器，其幅频响应与扰动的功率谱密度一致。例如通过某种手段测得外部扰动的功率谱密度呈现 {{< math >}}$1/f${{< /math >}} 的特性，意味着扰动动态可以建模为一阶积分器。

此外，如果可预测部分的扰动具有较强的时域特性，例如零偏或者震荡等，可以将扰动在局部时间内看作某个微分方程的解，因此总体扰动可以看作该微分方程的通解。例如对于未知的常值扰动，可以看作微分方程 {{< math >}}$\dot{d} = 0${{< /math >}} 的某一个解，根据微分方程可以将扰动动态建模为一阶积分器。

不失一般性，扰动动态的状态空间方程可以写为：

{{< math >}}$$
\left\{\begin{aligned}
    &\bm{x}_d(i+1) = A_d \bm{x}_d(i) + G_d \bm{w}_d(i) \\
    &\bm{d}(i) = H_c \bm{x}_d(i) + G_c \bm{w}_c(i)
\end{aligned}\right.
$${{< /math >}}

式中 {{< math >}}$\bm{x}_d${{< /math >}} 为扰动动态的状态向量。为了对扰动进行充分的预测，扰动动态的极点（{{< math >}}$A_d${{< /math >}} 的特征值）应当分布在单位圆上，这存在两种基本形式：

- 极点为 {{< math >}}$1${{< /math >}}：串联积分形式，频域上可以解释为低频扰动的预测，时域上根据积分阶数可以解释为分段常值（一阶积分）、分段线性（二阶积分）扰动等；
- 共轭极点 {{< math >}}$\mathrm{e}^{j 2\pi f_0 T}, \,(f_0 < f_s/2)${{< /math >}}：震荡模型，对应呈现周期特性的扰动。

需要说明的是，随机噪声 {{< math >}}$\bm{w}${{< /math >}} 分为扰动动态的驱动噪声 {{< math >}}$\bm{w}_d${{< /math >}} 和直接作用于可控动态的噪声 {{< math >}}$\bm{w}_c${{< /math >}}。其中，{{< math >}}$\bm{w}_d${{< /math >}} 驱动扰动动态，基于模型的输出部分 {{< math >}}$H_c \bm{x}_d${{< /math >}} 对应可预测部分的扰动，而 {{< math >}}$\bm{w}_c${{< /math >}} 完全随机而无法预测（或者说随机噪声的期望值为 {{< math >}}$0${{< /math >}}，无法提供有效的预测值）。

扰动动态中的矩阵 {{< math >}}$G_d${{< /math >}} 和 {{< math >}}$G_c${{< /math >}} 决定了随机噪声如何对被控对象产生影响，换句话说，被控对象的哪些状态会受到随机扰动的影响？假设驱动噪声 {{< math >}}$\bm{w}${{< /math >}} 各个分量是相互独立的，对于扰动动态，其状态变量不失一般性地都会受到 {{< math >}}$\bm{w}_d${{< /math >}} 的影响。而 {{< math >}}$G_c${{< /math >}} 的设计应当根据可控动态的物理条件决定。

## 示例：二阶系统建模

我们以单自由度弹簧-质量系统为例展示可控动态和扰动动态的建模。设弹簧的特征角频率为 {{< math >}}$\omega_0${{< /math >}}，在控制加速度 {{< math >}}$a_u${{< /math >}} 和扰动加速度 {{< math >}}$a_d${{< /math >}} 的作用下，质点相对平衡位置的位移 {{< math >}}$z${{< /math >}} 的微分方程为：

{{< math >}}$$
\ddot{z} + \omega_0^2 z = a_u + a_d
$${{< /math >}}

选取连续时间的状态变量为 {{< math >}}$\bm{x} = [z, \dot{z}]${{< /math >}}，连续时间的状态空间方程可以写为：

{{< math >}}$$
\left\{\begin{aligned}
    \dot{\bm{x}} &= \begin{bmatrix} 0 & 1 \\ -\omega_0^2 & 0 \end{bmatrix} \bm{x} + \begin{bmatrix} 0 \\ 1 \end{bmatrix} \left( a_u + a_d \right) \\
    y &= \begin{bmatrix} 1 & 0 \end{bmatrix} \bm{x}
\end{aligned}\right.
,\quad \bm{x}(0) = \bm{x}_0
$${{< /math >}}

如果使用差分近似微分，可控动态的各个系数矩阵可以写为：

{{< math >}}$$
A_c = I+AT = \begin{bmatrix} 1 & T \\ -\omega_0^2 T & 1  \end{bmatrix} , \quad B_c = BT = \begin{bmatrix} 0 \\ T \end{bmatrix}
$${{< /math >}}

如果使用积分做准确计算，可控动态的系数矩阵为：

{{< math >}}$$
\begin{gathered}
A_c = \mathrm{e}^{AT} = \begin{bmatrix} \cos(\omega_0T) & \sin(\omega_0T)/\omega_0 \\ -\omega_0 \sin(\omega_0T) & \cos(\omega_0T) \end{bmatrix} \\
B_c = \int_0^T \mathrm{e}^{A\tau} B \, \mathrm{d} \tau = \begin{bmatrix} 2 \sin^2(\omega_0T/2) /\omega_0^2 \\ \sin(\omega_0T)/\omega_0 \end{bmatrix}
\end{gathered}
$${{< /math >}}

当 {{< math >}}$\omega_0T \ll 1${{< /math >}} 且忽略 {{< math >}}$T^2${{< /math >}} 项后，两种方法得到的可控动态一致。

实际中，我们希望将数字积分器改为累加器以节约时间步长 {{< math >}}$T${{< /math >}} 引入的乘法计算。因此，取可控动态的状态向量为 {{< math >}}$\bm{x}_c = [z, \dot{z}T]${{< /math >}}，可控动态变为：

{{< math >}}$$
\left\{\begin{aligned}
    & \bm{x}_c(i+1) = \begin{bmatrix} 1 & 1 \\ -\omega_0^2 T^2 & 1 \end{bmatrix} \bm{x}_c(i) + \begin{bmatrix} 0 \\ 1 \end{bmatrix} u + \bm{d}(i) \\
    & y(i) = \begin{bmatrix} 1 & 0 \end{bmatrix} \bm{x}_c(i)
\end{aligned}\right.
,\quad \bm{x}_c(0) = \bm{x}_{c0}
$${{< /math >}}

其中 {{< math >}}$u = T^2 a_u${{< /math >}} 为数字形式的指令加速度。

假设质点受到的外部扰动时缓变的信号，可以认为具有分段线性特性，因而扰动动态可以取二阶积分器（实际上是累加器），其状态空间方程为：

{{< math >}}$$
\left\{\begin{aligned}
    & \bm{x}_d(i+1) = \begin{bmatrix} 1 & 1 \\ 0 & 1 \end{bmatrix} \bm{x}_d(i) + \begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix} \bm{w}_d(i) \\
    & \bm{d}(i) = \begin{bmatrix} 0 & 0 \\ 1 & 0 \end{bmatrix} \bm{x}_d(i) + \begin{bmatrix} 0 \\ 1 \end{bmatrix} w_c(i)
\end{aligned}\right.
$${{< /math >}}

其中，{{< math >}}$\bm{w}_d${{< /math >}} 的系数矩阵为单位矩阵，意味着驱动噪声 {{< math >}}$\bm{w}_d${{< /math >}} 的两个分量可以分别对扰动状态 {{< math >}}$\bm{x}_d${{< /math >}} 的两个分量产生影响；{{< math >}}$\bm{d}${{< /math >}} 的第一个分量为零，是因为外部扰动时加速度形式，不会直接对质点的速度产生影响；噪声 {{< math >}}$w_c${{< /math >}} 表示不可预测的随机扰动加速度。

