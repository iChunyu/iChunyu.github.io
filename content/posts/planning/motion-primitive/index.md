---
title: "Motion Primitive 简介"
date: 2024-10-06T22:54:32+08:00
tags: ["Motion Primitive", "运动基元", "轨迹规划"]
categories: ["规划算法入门"]
draft: false
---

Motion Primitive（常译为“运动原语”或“运动基元”）是一种简单高效的轨迹规划算法。在已知系统动力学方程和初始状态下，只需要给定目标状态及其到达时间就可以实现轨迹规划。本文将简要介绍这种算法的理论基础，并以一维的刚体运动为例进行推导。

<!--more-->

## 基本理论

假设系统的状态空间方程可以表述为：

{{< math >}}$$
\dot{\bm{x}(t)} = \bm{f}\bigl( \bm{x}(t), \bm{u}(t) \bigr), \quad \bm{x}(0) = \bm{x}_0
$${{< /math >}}

其中 {{< math >}}$\bm{x}(t)${{< /math >}} 为系统的状态，其初始值 {{< math >}}$\bm{x}(0) = \bm{x}_0${{< /math >}} 假设已知，{{< math >}}$\bm{u}${{< /math >}} 为系统的控制指令。

Motion Primitive 的基本思想是：系统状态应当在指定的时间 {{< math >}}$T${{< /math >}} 内转移到目标状态 {{< math >}}$\bm{x}_t${{< /math >}}，并且使控制指令的“能量” 最小。其对应的代价函数用公式表示为：

{{< math >}}$$
J = \int_0^T L \bigl( \bm{x}(t), \bm{u}(t) \bigr)  \, \mathrm{d}t = \int_0^T \left\lVert \bm{u}(t) \right\rVert^2 \, \mathrm{d}t
$${{< /math >}}

该问题的求解可以使用庞特里亚金最小值原理（Pontryagin’s minimum principle）：引入时变拉格朗日乘子向量（或称“伴随状态”） {{< math >}}$\bm{\lambda}(t)${{< /math >}}，构造如下哈密顿量：

{{< math >}}$$
H\bigl( \bm{x}(t), \bm{u}(t), \bm{\lambda}(t), t \bigr) = \bm{\lambda}^\mathrm{T} \bm{f}(\bm{x}(t), \bm{u}(t)) + L(\bm{x}(t), \bm{u}(t))
$${{< /math >}}

伴随方程可写为：

{{< math >}}$$
\dot{\bm{\lambda}}(t) = - \frac{\partial H}{\partial \bm{x}}
$${{< /math >}}

根据系统状态方程和伴随方程，代入如下最优控制条件即可获得指令的通解，最后根据终值条件定解即可。

{{< math >}}$$
\frac{\partial H}{\partial \bm{u}} = 0
$${{< /math >}}


## 示例

假设被控对象为一维的刚体，其状态变量 {{< math >}}$x_1${{< /math >}}、{{< math >}}$x_2${{< /math >}} 和 {{< math >}}$x_3${{< /math >}} 分别对应位置、速度和加速度，控制指令 {{< math >}}$u${{< /math >}} 为加加速度（jerk）。则系统的状态空间方程为：

{{< math >}}$$
\left\{\begin{aligned}
    \dot{x}_1 &= x_2 \\
    \dot{x}_2 &= x_3 \\
    \dot{x}_3 &= u
\end{aligned}\right.
, \quad
\bm{x}(0) = \begin{bmatrix} p_0 \\ v_0 \\ a_0 \end{bmatrix}
$${{< /math >}}

假设目标是在 {{< math >}}$T${{< /math >}} 时间内将系统状态调整到 {{< math >}}$\bm{x}_t = [p_t, v_t, a_t]^\mathrm{T}${{< /math >}}。Motion Primitive 考虑的代价函数为：

{{< math >}}$$
J = \int_0^T u^2  \, \mathrm{d}t, \quad \left( L = u^2 \right)
$${{< /math >}}

设伴随状态为 {{< math >}}$\bm{\lambda} = [\lambda_1, \lambda_2, \lambda_3]^\mathrm{T}${{< /math >}}，则哈密顿量可以表示为：

{{< math >}}$$
H = \lambda_1 x_2 + \lambda_2 x_3 + \lambda_3 u + u^2
$${{< /math >}}

由伴随方程可知：

{{< math >}}$$
\left\{\begin{aligned}
    \dot{\lambda}_1 &= - \frac{\partial H}{\partial x_1} = 0 \\
    \dot{\lambda}_2 &= - \frac{\partial H}{\partial x_2} = -\lambda_1 \\
    \dot{\lambda}_3 &= - \frac{\partial H}{\partial x_3} = -\lambda_2
\end{aligned}\right.
\quad \Rightarrow \quad
\left\{\begin{aligned}
    \lambda_1 &= C_1 \\
    \lambda_2 &= C_1t + C_2 \\
    \lambda_3 &= \frac{1}{2}C_1 t^2 + C_2 t + C_3
\end{aligned}\right.
$${{< /math >}}

其中 {{< math >}}$C_1${{< /math >}}、{{< math >}}$C_2${{< /math >}} 和 {{< math >}}$C_3${{< /math >}} 为待定常数。将上述结果代入到最优化条件可得：

{{< math >}}$$
\frac{\partial H}{\partial u} = \lambda_3 + 2u = 0
\quad \Rightarrow \quad
u = - \frac{1}{2} \lambda_3 := \frac{1}{2} \alpha t^2 + \beta t + \gamma
$${{< /math >}}

上式为了表述的方便，将待定系数转化为了 {{< math >}}$\alpha${{< /math >}}、{{< math >}}$\beta${{< /math >}} 和 {{< math >}}$\beta${{< /math >}}。将上述指令代入到状态方程，可知 {{< math >}}$t${{< /math >}} 时刻的状态为：

{{< math >}}$$
\bm{x}(t) = \begin{bmatrix}
\frac{1}{120} \alpha t^5 + \frac{1}{24} \beta t^4 + \frac{1}{6} \gamma t^3 + \frac{1}{2} a_0 t^2 + v_0 t + p_0 \\
\frac{1}{24} \alpha t^4 + \frac{1}{6} \beta t^3 + \frac{1}{2} \gamma t^2 + a_0 t + v_0 \\
\frac{1}{6} \alpha t^3 + \frac{1}{2} \beta t^2 + \gamma t + a_0
\end{bmatrix}
$${{< /math >}}

代入 {{< math >}}$\bm{x}(T) = [p_t, v_t, a_t]^\mathrm{T}${{< /math >}} 即可得到待定系数：

{{< math >}}$$
\begin{bmatrix} \alpha \\ \beta \\ \gamma \end{bmatrix} =
\frac{1}{T^5} \begin{bmatrix} 720 & -360T & 60T^2 \\ -360T & 168T^2 & -24T^3 \\ 60T^2 & -24T^3 & 3T^4 \end{bmatrix}
\begin{bmatrix} p_t - (p_0 + v_0T + \frac{1}{2}a_0T^2) \\ v_t - (v_0 + a_0T) \\ a_t - a_0 \end{bmatrix}
$${{< /math >}}

最后，将解得的待定系数重新代回指令和状态的表达式，即可得到状态轨迹和相应的控制指令。对于底层控制器而言，规划的状态轨迹可以作为参考状态，由反馈回路进行跟踪；而规划的控制指令可以作为参考指令，以前馈的形式改善系统的动态响应。



## 参考文献

1. Mueller, M. W., Hehn, M., D’Andrea, R. [A Computationally Efficient Motion Primitive for Quadrocopter Trajectory Generation](https://ieeexplore.ieee.org/document/7299672). IEEE Transactions on Robotics 2015, 31(6), 1294–1310.
2. Wikipedia. [Pontryagin's maximum principle](https://en.wikipedia.org/wiki/Pontryagin%27s_maximum_principle).


