# 模型嵌入控制（5）：控制律设计


模型嵌入控制的控制律可以利用预测的状态和扰动实现反馈，此外，利用参考发生器还可以先验地给出前馈指令。本文将对控制律进行具体推导，实现模型嵌入控制的结构设计。

<!--more-->

控制系统的核心目标是驱动被控对象的输出跟随参考信号。在状态空间的建模下，我们可以将这种跟随进一步描述为被控对象对参考动态的跟随，具体表现为被控对象与参考动态的跟踪误差 {{< math >}}$\tilde{\bm{x}}${{< /math >}} 收敛。为此，首先考虑被控对象的状态方程为：

{{< math >}}$$
\left\{\begin{aligned}
    & \bm{x}_c(i+1) = A_c \bm{x}_c(i) + B_c \bigl( \bm{u}(i) + \bm{h}(\bm{x}_c(i)) \bigr) + H_c \bm{x}_d(i) + G_c \bm{w}_c(i) \\
    & \bm{x}_d(i+1) = A_d \bm{x}_d(i) + G_d \bm{w}_d(i) \\
    & \bm{y}(i) = C_c \bm{x}_c(i) + C_d \bm{x}_d(i)
\end{aligned}\right.
$${{< /math >}}

同时假设参考发生器的状态方程为：

{{< math >}}$$
    \left\{\begin{aligned}
        & \bm{x}_r (i+1) = A_c \bm{x}_r(i) + B_c \bm{u}_r(i) \\
        & \bm{y}_r(i) = C_c \bm{x}_r(i)
    \end{aligned}\right.
    ,\quad \bm{x}_r(0) = \bm{x}_{r0}
$${{< /math >}}

参考发生器中的参考动态 {{< math >}}$\bm{x}_r${{< /math >}} 仅受参考指令 $\bm{u}_r$ 的驱动，不受到任何外部扰动的影响；此外，参考输出 $\bm{y}_r$ 仅与参考状态相关，没有引入任何噪声。因此，参考发生器可以看作理想的被控对象，能够提供理想条件下的参考轨迹。参考指令 {{< math >}}$\bm{u}_r${{< /math >}} 可以基于 $\bm{x}_r$ 采用理想的状态反馈，从而达到给定条件下的最优控制。

考虑到被控对象输出可能受到扰动 $C_d\bm{x}_d$ 的影响，引入待定参数矩阵 $Q$ 进行修正，定义状态的跟踪误差为：
{{< math >}}$$
\tilde{\bm{x}}_r = \bm{x}_c - \bm{x}_r + Q \bm{x}_d
$${{< /math >}}

于是输出的跟踪误差为：

{{< math >}}$$
    \tilde{\bm{y}}_r = \bm{y} - \bm{y}_r = C_c \bm{x}_c + C_d \bm{x}_d - C_c \bm{x}_r = C_c \tilde{\bm{x}}_r + \left( C_d - C_c Q \right) \bm{x}_d
$${{< /math >}}

当被控对象跟踪良好时，外部扰动通过控制律补偿，扰动动态 $\bm{x}_d$ 不应当对输出的跟踪误差产生影响，因此可以得到控制律设计的第一个约束方程：

{{< math >}}$$
    C_d - C_c Q = 0
$${{< /math >}}

进一步，考察跟踪误差 $\tilde{\bm{x}}_r$ 的动态方程为：

{{< math >}}$$
    \tilde{\bm{x}}_r(i+1) = A_c \tilde{\bm{x}}_r(i) + B_c \bigl( \bm{u}(i) + \bm{h}(\bm{x}_c(i)) - \bm{u}_r(i) \bigr) + \left( H_c + Q A_d - A_c Q \right) \bm{x}_d(i) + \bm{w}_r(i)
$${{< /math >}}

其中 $\bm{w}_r = G_c \bm{w}_c + Q G_d \bm{w}_d$ 将扰动动态的随机噪声 {{< math >}}$[\bm{w}_c,\,\bm{w}_d]${{< /math >}} 折合到对跟踪误差的扰动，是被控对象对参考信号跟踪性能的限制因素，必须通过控制环路的闭环极点配置进行约束。控制律主要由三部分构成：

- 状态反馈 $-K \tilde{\bm{x}}_r$：状态反馈不仅能够确保状态的跟踪误差收敛，还能通过参数设计实现闭环极点的任意配置，是影响系统性能的关键要素；
- 参考指令  $\bm{u}_r$：参考指令能够驱动参考状态跟随目标参考信号，相应地可以作为开环控制指令驱动被控对象以改善系统的动态响应；
- 扰动补偿 $-\bm{h}(\bm{x}_c) - P \bm{x}_d$：其中 $\bm{h}(\bm{x}_c)$ 和 $P \bm{x}_d$ 分别代表被控对象受到的内部扰动和外部扰动，补偿后可以改善跟踪性能。

综上所述，理想控制律为：

{{< math >}}$$
    \bm{u}(i) = - K \tilde{\bm{x}}_r(i) + \bm{u}_r(i) - \bm{h}(\bm{x}_c(i)) - P \bm{x}_d(i)
$${{< /math >}}

将上式代入跟踪误差的状态方程，得：

{{< math >}}$$
    \tilde{\bm{x}}_r(i+1) = \left( A_c - B_c K \right) \tilde{\bm{x}}_r(i) + \left( H_c + Q A_d - A_c Q - B_c P \right) \bm{x}_d(i) + \bm{w}_r(i)
$${{< /math >}}

考虑外部扰动应当被控制所补偿，令 $\bm{x}_d$ 的系数矩阵为 $0$，增加约束条件：

{{< math >}}$$
H_c + Q A_d - A_c Q - B_c P = 0
$${{< /math >}}


结合两个约束条件可以对参数矩阵 {{< math >}}$Q${{< /math >}} 和 {{< math >}}$P${{< /math >}} 定解；通过对闭环状态矩阵 {{< math >}}$A_c-B_c K${{< /math >}} 的极点配置能够实现控制参数 {{< math >}}$K${{< /math >}} 设计，理想控制律设计得以完成。在实际设计中，状态真值 {{< math >}}$[\bm{x}_c,\,\bm{x}_d]${{< /math >}} 替换为状态预测器给出的预测值 {{< math >}}$[\hat{\bm{x}}_c,\,\hat{\bm{x}}_d]${{< /math >}}。同样地，状态耦合 {{< math >}}$\bm{h}(\bm{x}_c)${{< /math >}} 也应当替换为相应的标称模型 {{< math >}}$\bm{h}_{\mathrm{nom}}(\hat{\bm{x}}_c)${{< /math >}}。于是实际的控制律应当修正为：

{{< math >}}$$
    \bm{u}(i) = - K \bm{e}_r(i) + \bm{u}_r(i) - \bm{h}_{\mathrm{nom}}(\hat{\bm{x}}_c(i)) - P \hat{\bm{x}}_d(i)
$${{< /math >}}

其中，标称耦合 $\bm{h}_{\mathrm{nom}}(\hat{\bm{x}}_c)$ 与实际 $\bm{h}(\bm{x}_c)$ 之间的误差将按照参数不确定性处理。实际测得的跟踪误差定义为：

{{< math >}}$$
\bm{e}_r = \hat{\bm{x}}_c - \bm{x}_r + Q \hat{\bm{x}}_d
$${{< /math >}}

响应的状态方程为：

{{< math >}}$$
\bm{e}_r(i+1) = \left( A_c - B_c K \right) \bm{e}_r(i) + G_c \bar{\bm{w}}_c(i) + QG_d \bar{\bm{w}}_d(i)
$${{< /math >}}

结合 [状态预测器设计]({{< ref "../emc04-statepredictor/index.md" >}}) 给出的状态预测误差方程，可得全系统的误差动态方程为：

{{< math >}}$$
    \begin{bmatrix} \tilde{\bm{x}}_c(i+1) \\ \tilde{\bm{x}}_d(i+1) \\ -\bar{\bm{x}}_n(i+1) \\ \bm{e}_r(i+1) \end{bmatrix} = 
    \left[\begin{array}{ccc:c}
     A_c-G_cL_cC_c & H_c-G_cL_cC_d & G_cN_c & 0 \\
    -G_dL_dC_c    & A_d-G_dL_dC_d & G_dN_d  & 0\\
    -L_nC_c       & -L_nC_d       & A_n & 0 \\ \hdashline
        L_wC_c                               & L_wC_d & -N_w & A_c - B_c K \\
    \end{array}\right]
    \begin{bmatrix} \tilde{\bm{x}}_c(i) \\ \tilde{\bm{x}}_d(i) \\ -\bar{\bm{x}}_n(i) \\ \bm{e}_r(i) \end{bmatrix}
    + \begin{bmatrix} G_c\bm{w}_c(i) \\ G_d \bm{w}_d(i) \\ 0 \\ 0 \end{bmatrix}
$${{< /math >}}

式中 $L_w = G_cL_c + QG_dL_d$，$N_w = G_cN_c + QG_dN_d$。完整误差环路的状态矩阵为下三角矩阵，主对角线分别由状态预测环路的状态矩阵和理想控制环路的状态矩阵组成。因此，当模型准确时，环路设计满足分离定理，状态预测器和控制律能够单独设计。

