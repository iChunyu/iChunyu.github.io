---
title: "最小二乘法与参数估计"
date: 2023-08-26T19:14:16+08:00
tags: ["最小二乘法","参数估计"]
categories: ["数字信号处理"]
draft: false
---


最小二乘法（Least-Squares Method）是一种常用的参数估计方法，本文将介绍最小二乘法的基本原理，并推导其递归形式，讨论时变参数的估计策略。

<!--more-->


## 最小二乘法

考察下式给出的多变量模型：

{{< math >}}$$
y = \theta_1\varphi_1 + \theta_2\varphi_2 + \cdots + \theta_n \varphi_n = \bm{\varphi}^\mathrm{T} \bm{\theta}
$${{< /math >}}

其中，{{< math >}}$\bm{\theta}^\mathrm{T} = [\theta_1,\,\theta_2,\dots,\theta_n]${{< /math >}} 为模型的参数，{{< math >}}$\bm{\varphi}^\mathrm{T} = [\varphi_1,\,\varphi_2,\,\dots,\,\varphi_n]${{< /math >}} 为一系列已知且相互独立的函数。需要注意的是，{{< math >}}$\bm{\varphi}${{< /math >}} 可以是关于另一变量的非线性函数，例如 {{< math >}}$\varphi_k = x^{k-1}${{< /math >}} 表示多项式。由于模型关于参数 {{< math >}}$\bm{\theta}${{< /math >}} 是线性的，为了表述的方便，采用加粗的符号表示列向量，上式最后的等号将模型写成了矩阵的形式。

假设现在进行了 {{< math >}}$i${{< /math >}} 次观测，根据模型可以建立方程组：

{{< math >}}$$
\underbrace{\begin{bmatrix}
    \varphi_1(1) & \varphi_2(1) & \cdots & \varphi_n(1) \\
    \varphi_1(2) & \varphi_2(2) & \cdots & \varphi_n(2) \\
    \vdots & \vdots & & \vdots \\
    \varphi_1(i) & \varphi_2(i) & \cdots & \varphi_n(i) \\
\end{bmatrix}}_{\Phi(i)}
\underbrace{\begin{bmatrix} 
\theta_1 \\ \theta_2 \\ \vdots \\ \theta_n
\end{bmatrix}}_{\bm{\theta}}
= \underbrace{\begin{bmatrix} 
y(1) \\ y(2) \\ \vdots \\ y(i)
\end{bmatrix}}_{Y(i)}
$${{< /math >}}

显然，当观测次数 {{< math >}}$i < n${{< /math >}} 时，方程数小于变量数，存在多解；当 {{< math >}}$i=n${{< /math >}} 且观测相互独立时，上述方程组可以定解；当 {{< math >}}$i > n${{< /math >}} 时，由于噪声的存在，方程通常是相互矛盾的，为了对参数 {{< math >}}$\bm{\theta}${{< /math >}} 进行估计，考虑误差的平方和最小，即：

{{< math >}}$$
\hat{\bm{\theta}}(i) = \mathop{\mathrm{argmin}}\limits_{\bm{\theta}} J(\bm{\theta},i) ,\quad J(\bm{\theta},i) = \frac{1}{2} \bigl( Y(i) - \Phi(i) \bm{\theta} \bigr)^\mathrm{T}\bigl( Y(i) - \Phi(i) \bm{\theta} \bigr)
$${{< /math >}}

令上式关于 $\bm{\theta}$ 的导数为零，可得：

{{< math >}}$$
\frac{\partial J(\bm{\theta},i)}{\partial \bm{\theta}} = 0 \quad \Rightarrow \quad \Phi^\mathrm{T}(i) \Phi(i) \bm{\theta} = \Phi^\mathrm{T} Y(i)
$${{< /math >}}

由此可以解得：

{{< math >}}$$
\hat{\bm{\theta}}(i) = \bigl( \Phi^\mathrm{T}(i) \Phi(i) \bigr)^{-1} \Phi^\mathrm{T}(i) Y(i)
$${{< /math >}}

于是 {{< math >}}$\hat{\bm{\theta}}(i)${{< /math >}} 就是参数 {{< math >}}$\bm{\theta}${{< /math >}} 在 {{< math >}}$i${{< /math >}} 次测量下的最小二乘估计。


## 递归最小二乘法

如果将 {{< math >}}$i${{< /math >}} 看作离散时间系统的时间索引（后面将从 0 开始计数），根据上面最小二乘法的表达式可以实时对参数进行估计。为此，我们通常需要将上式转化为递归形式，即递归最小二乘法（Recursive Least-Squares）。

首先考虑将矩阵 {{< math >}}$\Phi^\mathrm{T}(i)\Phi(i)${{< /math >}} 进行分解：

{{< math >}}$$
\Phi^\mathrm{T}(i)\Phi(i) 
% = \begin{bmatrix}
%     \bm{\varphi}(1) & \bm{\varphi}(2) & \cdots & \bm{\varphi}(i)
% \end{bmatrix}
% \begin{bmatrix}
%     \bm{\varphi}^\mathrm{T}(1) \\ \bm{\varphi}^\mathrm{T}(2) \\ \vdots \\ \bm{\varphi}^\mathrm{T}(i)
% \end{bmatrix}
= \sum_{k=0}^i \bm{\varphi}(k) \bm{\varphi}^\mathrm{T}(k)
= \Phi^\mathrm{T}(i-1)\Phi(i-1) + \bm{\varphi}(i) \bm{\varphi}^\mathrm{T}(i)
$${{< /math >}}

为了表述的方便，记 {{< math >}}$P(i) = \bigl( \Phi^\mathrm{T}(i) \Phi(i) \bigr)^{-1}${{< /math >}}，上式写为：

{{< math >}}$$
P^{-1}(i) = P^{-1}(i-1) + \bm{\varphi}(i) \bm{\varphi}^\mathrm{T}(i)
$${{< /math >}}

于是参数估计可以写成迭代形式：

{{< math >}}$$
\begin{aligned}
\hat{\bm{\theta}}(i) &= P(i) \sum_{k=0}^i \bm{\varphi}(k) y(k) \\
&= P(i) \left( \sum_{k=0}^{i-1} \bm{\varphi}(k) y(k) + \bm{\varphi}(i)y(i) \right) \\
&= P(i) \left( P^{-1}(i-1) \hat{\bm{\theta}}(i-1) + \bm{\varphi}(i) y(i) \right) \\
&= P(i) \left( \left( P^{-1}(i) - \bm{\varphi}(i) \bm{\varphi}^\mathrm{T}(i) \right) \hat{\bm{\theta}}(i-1) + \bm{\varphi}(i) y(i) \right) \\
&= \hat{\bm{\theta}}(i-1) + \underbrace{P(i) \bm{\varphi}(i)}_{K(i)} \left( y(i) - \bm{\varphi}^\mathrm{T}(i) \hat{\bm{\theta}}(i-1) \right)
\end{aligned}
$${{< /math >}}

式中 {{< math >}}$\hat{\bm{\theta}}(i-1)${{< /math >}} 为参数 {{< math >}}$\bm{\theta}${{< /math >}} 上一时刻的估计值；{{< math >}}$y(i)${{< /math >}} 为当前时刻测量值；{{< math >}}$\bm{\varphi}(i) \hat{\bm{\theta}}(i-1)${{< /math >}} 是利用当前测量和上一时刻的参数给出的先验估计。

为了得到矩阵 {{< math >}}$P(i)${{< /math >}} 的递归形式，进一步考虑矩阵求逆公式：

{{< math >}}$$
\left( A + BCD \right)^{-1} = A^{-1} - A^{-1} B \left( C^{-1} + D A^{-1}B \right)^{-1} DA^{-1}
$${{< /math >}}

于是有：

{{< math >}}$$
\begin{aligned}
P(i) &= \bigl( \Phi^\mathrm{T}(i-1)\Phi(i-1) + \bm{\varphi}(i) \bm{\varphi}^\mathrm{T}(i) \bigr)^{-1} \\
&= \bigl( \underbrace{P^{-1}(i-1)}_{A} + \underbrace{\bm{\varphi}(i)}_{B} \underbrace{I}_{C} \underbrace{\bm{\varphi}^\mathrm{T}(i)}_{D} \bigr)^{-1} \\
&= P(i-1) - P(i-1) \bm{\varphi}(i) \bigl( I + \bm{\varphi}^\mathrm{T}(i) P(i-1) \bm{\varphi}(i) \bigr)^{-1} \bm{\varphi}^\mathrm{T}(i) P(i-1)
\end{aligned}
$${{< /math >}}

同时可知：

{{< math >}}$$
\begin{aligned}
K(i) &= P(i) \bm{\varphi}(i) \\
&= P(i-1) \bm{\varphi}(i) \left( I - \bigl( I + \bm{\varphi}^\mathrm{T}(i) P(i-1) \bm{\varphi}(i) \bigr)^{-1} \bm{\varphi}^\mathrm{T}(i) P(i-1) \bm{\varphi}(i) \right) \\
&= P(i-1) \bm{\varphi}(i)\bigl( I + \bm{\varphi}^\mathrm{T}(i) P(i-1) \bm{\varphi}(i) \bigr)^{-1}
\end{aligned}
$${{< /math >}}

最后一个等号反用了矩阵求逆公式，其中考虑 {{< math >}}$A=B=C=I,\, D=\bm{\varphi}^\mathrm{T}(i) P(i-1) \bm{\varphi}(i)${{< /math >}}。

综上，递归最小二乘法整理为：

{{< math >}}$$
\left\{\begin{aligned}
    \hat{\bm{\theta}}(i) &= \hat{\bm{\theta}}(i-1) + K(i) \bigl( y(i) - \bm{\varphi}^\mathrm{T}(i) \hat{\bm{\theta}}(i-1) \bigr) \\
    K(i) &= P(i-1) \bm{\varphi}(i)\bigl( I + \bm{\varphi}^\mathrm{T}(i) P(i-1) \bm{\varphi}(i) \bigr)^{-1} \\
    P(i) &= \bigl( I - K(i) \bm{\varphi}^\mathrm{T}(i) \bigr) P(i-1)
\end{aligned}\right.
$${{< /math >}}

根据最小二乘法的讨论可知，参数估计至少需要 {{< math >}}$n${{< /math >}} 次测量。为了能够使迭代形式在 {{< math >}}$i=0${{< /math >}} 时刻就开始运行，通常可以根据先验知识给出估计参数的初值 {{< math >}}$\hat{\bm{\theta}}(0)${{< /math >}}，并令 $P(0)$ 充分大，通过迭代使其收敛。

{{< admonition note "提示" >}}
递归最小二乘法可以看作如下关于参数 {{< math >}}$\bm{\theta}${{< /math >}} 系统的 [卡尔曼滤波]({{< ref "../../control/KalmanFilter/index.md" >}})：

{{< math >}}$$
\bm{\theta}(i+1) = \bm{\theta}(i) \, \quad
y(i) = \bm{\varphi}^\mathrm{T}(i) \bm{\theta}(i) + e(i)
$${{< /math >}}

其中测量误差 $e(i)$ 为单位高斯白噪声。
{{< /admonition >}}


## 时变参数估计

如果参数 {{< math >}}$\bm{\theta}${{< /math >}} 会随着时间发生缓慢的变化，我们在考虑误差可以对最近时刻的测量引入更高的权重。引入指数形式的遗忘因子 {{< math >}}$0 < \lambda \le 1${{< /math >}}，最小二乘法的代价函数变为：

{{< math >}}$$
J(\bm{\theta}, i) = \frac{1}{2} \bigl( \Phi(i) \bm{\theta} - Y(i) \bigr)^\mathrm{T} \Lambda(i) \bigl( \Phi(i) \bm{\theta} - Y(i) \bigr) = \frac{1}{2} \sum_{k=0}^i \lambda^{i-k} \left( y(k) - \bm{\varphi}^\mathrm{T}(k) \bm{\theta} \right)^2
$${{< /math >}}

类似地，令代价函数对参数的偏导为零可得：

{{< math >}}$$
\frac{\partial J(\bm{\theta},i)}{\partial \bm{\theta}} = 0
\quad \Rightarrow \quad
\Phi^\mathrm{T}(i) \Lambda(i) \Phi(i) \bm{\theta} = \Phi^\mathrm{T}(i) \Lambda(i) Y(i)
$${{< /math >}}

其中，加权矩阵 {{< math >}}$\Lambda(i)${{< /math >}} 为对角矩阵：

{{< math >}}$$
\Lambda(i) = \begin{bmatrix} 
\lambda^{i} & 0 & \cdots & 0 \\
0 & \lambda^{i-1} & \cdots & 0 \\
0 & \vdots  & \ddots & \vdots \\
0 & 0 & \cdots & \lambda^0
\end{bmatrix}
$${{< /math >}}

于是参数估计值为：

{{< math >}}$$
\hat{\bm{\theta}}(i) = \bigl( \Phi^\mathrm{T}(i) \Lambda(i) \Phi(i) \bigr)^{-1} \Phi^\mathrm{T}(i) \Lambda(i) Y(i)
$${{< /math >}}

定义 {{< math >}}$P(i) =\bigl( \Phi^\mathrm{T}(i) \Lambda(i) \Phi(i) \bigr)^{-1}${{< /math >}}，有：

{{< math >}}$$
\begin{aligned}
P^{-1}(i) &= \sum_{k=0}^i \lambda^{i-k}\bm{\varphi}(k) \bm{\varphi}^\mathrm{T}(k) \\
& = \lambda \left( \sum_{k=0}^{i-1} \lambda^{i-k}\bm{\varphi}(k) \bm{\varphi}^\mathrm{T}(k) \right) + \bm{\varphi}(i) \bm{\varphi}^\mathrm{T}(i) \\
&= \lambda P^{-1}(i-1) + \bm{\varphi}(i) \bm{\varphi}^\mathrm{T}(i)
\end{aligned}
$${{< /math >}}

据此将参数估计写成迭代形式为：

{{< math >}}$$
\begin{aligned}
\hat{\bm{\theta}}(i) &= P(i) \sum_{k=0}^{i} \lambda^{i-k} \bm{\varphi}(k) y(k) \\
&= P(i) \left( \lambda \sum_{k=0}^{i-1} \lambda^{i-k} \bm{\varphi}(k) y(k) + \bm{\varphi}(i) y(i)  \right) \\
&= P(i) \left( \lambda P^{-1}(i-1) \hat{\bm{\theta}}(i-1) + \bm{\varphi}(i)y(i) \right) \\
&= P(i) \left( \left( P^{-1}(i) - \bm{\varphi}(i) \bm{\varphi}^\mathrm{T}(i) \right) \hat{\bm{\theta}}(i-1) + \bm{\varphi}(i)y(i) \right) \\
&= \hat{\bm{\theta}}(i-1) + \underbrace{P(i) \bm{\varphi}(i)}_{K(i)} \left( y(i) - \bm{\varphi}^\mathrm{T}(i) \hat{\bm{\theta}}(i-1) \right)
\end{aligned}
$${{< /math >}}

与没有遗忘因子的迭代具有完全相同的形式。进一步根据矩阵求逆公式考虑 {{< math >}}$P(i)${{< /math >}} 的递归方程为：

{{< math >}}$$
P(i) = \lambda^{-1} P(i-1) - \lambda^{-1} P(i-1) \bm{\varphi}(i) \left( I + \bm{\varphi}^\mathrm{T}(i) \lambda^{-1} P(i-1) \bm{\varphi}(i) \right)^{-1} \bm{\varphi}^\mathrm{T}(i) \lambda^{-1} P(i-1)
$${{< /math >}}

进一步有：

{{< math >}}$$
\begin{aligned}
K(i) &= P(i) \bm{\varphi}(i) \\
&= \lambda^{-1} P(i-1) \bm{\varphi}(i) \left( I - \left( I + \bm{\varphi}^\mathrm{T}(i) \lambda^{-1} P(i-1) \bm{\varphi}(i) \right)^{-1} \bm{\varphi}^\mathrm{T}(i) \lambda^{-1} P(i-1) \right) \\
&= \lambda^{-1} P(i-1) \left( I + \bm{\varphi}^\mathrm{T}(i) \lambda^{-1} P(i-1) \bm{\varphi}(i) \right)^{-1} \\
&= P(i-1) \left( \lambda + \bm{\varphi}^\mathrm{T}(i)P(i-1) \bm{\varphi}(i) \right)^{-1}
\end{aligned}
$${{< /math >}}

整理后得到时变参数的最小二乘估计为：

{{< math >}}$$
\left\{\begin{aligned}
    \hat{\bm{\theta}}(i) &= \hat{\bm{\theta}}(i-1) + K(i) \bigl( y(i) - \bm{\varphi}^\mathrm{T}(i) \hat{\bm{\theta}}(i-1) \bigr) \\
    K(i) &= P(i-1) \bm{\varphi}(i)\bigl( \lambda + \bm{\varphi}^\mathrm{T}(i) P(i-1) \bm{\varphi}(i) \bigr)^{-1} \\
    P(i) &=  \lambda^{-1} \bigl( I - K(i) \bm{\varphi}^\mathrm{T}(i) \bigr) P(i-1)
\end{aligned}\right.
$${{< /math >}}


## 连续时间模型

连续时间下，考虑遗忘因子 {{< math >}}$\alpha \ge 0${{< /math >}}，代价函数可以表述为：

{{< math >}}$$
J(\bm{\theta},t) = \int_0^t \mathrm{e}^{-\alpha(t-\tau)} \left( y(\tau) - \bm{\varphi}^\mathrm{T}(\tau) \bm{\theta} \right)^2 \, \mathrm{d}\tau
$${{< /math >}}


相似的推导可以得到连续时间模型的最小二乘估计为：

{{< math >}}$$
\left\{\begin{aligned}
\frac{\mathrm{d}\hat{\bm{\theta}}(t)}{\mathrm{d}t} &= P(t) \bm{\varphi}(t) \left( y(t) - \bm{\varphi}^\mathrm{T}(t) \hat{\bm{\theta}}(t) \right) \\
\frac{\mathrm{d}P(t)}{\mathrm{d}t} &= \alpha P(t) - P(t) \bm{\varphi}(t) \bm{\varphi}^\mathrm{T}(t) P(t)
\end{aligned}\right.
$${{< /math >}}


## 参考文献

1. Karl Johan Åström, Björn Wittenmark. Adaptive Control. 2nd Edition. Dover Publications. 2008.
