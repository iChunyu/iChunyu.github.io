---
title: "从零构建数字滤波器"
date: 2025-07-19T13:21:33+08:00
tags: ["IIR", "滤波器"]
categories: ["数字信号处理"]
draft: true
---

滤波器在信号处理、控制系统等领域起着十分重要的作用。然而，在实际的数字信号处理中，过于简单的 IIR（Infinite Impulse Response）滤波器结构会引入数值精度的影响，甚至可能导致滤波器发散。为了便于构造稳定的滤波器，本文将具体梳理 数字滤波器的实现步骤，并给出简单的推导和必要的伪代码步骤。

<!--more-->

## 基本思路

从线性系统理论层面讲，拉普拉斯变换可以更方便地分析系统的频率响应，因此我们首先会在 {{< math >}}$s${{< /math >}} 域完成模拟滤波器（Analog Filter）的设计。特别地，得益于 {{< math >}}$s${{< /math >}} 域的变换，我们可以根据滤波器原型变换得到各种形式的滤波器。然后进行一定的离散化变换即可得到数字滤波器（Digital Filter）。

从稳定性上来看，滤波器是否稳定取决于极点分布，因此模拟滤波器可用零极点（Zero-Pole-Gain，通常简称 zpk）的形式表示，以减少数值误差的影响。而在数值计算上看，数字滤波器的阶数不易太高，以避免状态量之间存在量级差异而引入计算误差，所以实际会将高阶滤波器拆解为串联的二阶节（SOS：Second-Order Sections）形式。

简言之，数字滤波器的实现可以分为以下几个步骤：

1. 设计模拟滤波器的原型，得到 {{< math >}}$s${{< /math >}} 域的零极点分布；
2. 根据频域变换，将滤波器原型变换为符合需求的模拟滤波器；
3. 根据采样率对滤波器参数离散化，得到 {{< math >}}$z${{< /math >}} 域的零极点分布；
4. 将 {{< math >}}$z${{< /math >}} 域的零极点匹配，拆解为多个二阶节并排序；
5. 按照二阶系统的处理方法依次处理二阶节即可实现滤波。

需要注意的是，离散化通常采用 **双线性变换**，因此在上述第二步进行 {{< math >}}$s${{< /math >}} 域的变换前需要对频率进行 **预畸**。


## 常用滤波器原型

我们在 [信号的滤波]({{< ref "../filterDesign/index.md" >}}) 讨论过滤波器的基本参数和四种常见的滤波器，此处不再赘述。模拟滤波器的零极点形式为：

{{< math >}}$$
H(s) = g \frac{(s-z_1)(s-z_2)\cdots(s-z_m)}{(s-p_1)(s-p_2)\cdots(s-p_n)} = g \frac{\Pi_{k=1}^m (s - z_k)}{\Pi_{k=1}^n (s - p_k)} ,\quad g > 0
$${{< /math >}}

其中 {{< math >}}$z_k \; (k = 1,2,\dots,m)${{< /math >}} 为零点，{{< math >}}$p_k \; (k = 1,2,\dots,n)${{< /math >}} 为极点。稳定的、非最小相位系统零极点的实部均小于零；进一步，适定系统的零点的阶次不超过极点，即 {{< math >}}$m \le n${{< /math >}}。特别地，如果系统不存在有限的零点（零点在无穷远），此时传递函数的分子为常数。

滤波器原型通常是指转折频率为 {{< math >}}$1\,\mathrm{rad/s}${{< /math >}} 的低通滤波器，下面我们将归纳几种常见滤波器原型的零极点分布。

### 巴特沃斯滤波器

巴特沃斯滤波器（[Butterworth Filter](https://en.wikipedia.org/wiki/Butterworth_filter)）是通带最平坦的滤波器。能量衰减一半（幅值衰减 {{< math >}}$\sqrt{2}/2${{< /math >}}）对应的频率为转折频率，也是我们常说的 {{< math >}}$-3 \,\mathrm{dB}${{< /math >}} 带宽。

巴特沃斯滤波器原型不存在有限零点，{{< math >}}$N${{< /math >}} 阶滤波器原型的极点均匀分布在复平面单位圆左侧，即：

{{< math >}}$$
p_k = \mathrm{e}^{-j\frac{2k + N - 1}{2N} \pi}, \quad
k = 1,2,\dots, N
$${{< /math >}}

巴特沃斯滤波器原型直流增益为 {{< math >}}$1${{< /math >}}，无须再进行修正，因而 {{< math >}}$g = 1${{< /math >}}。

### 切比雪夫 I 型滤波器

切比雪夫 I 型滤波器（[Type I Chebyshev Filter](https://en.wikipedia.org/wiki/Chebyshev_filter#Type_I_Chebyshev_filters_%28Chebyshev_filters%29)）允许在转折频率表示的带宽以内，滤波器的增益在 {{< math >}}$[1/\sqrt{1 + \varepsilon^2}, \, 1]${{< /math >}} 之间波动。

切比雪夫 I 型滤波器同样没有零点，指定通带纹波系数 {{< math >}}$\varepsilon > 0${{< /math >}}，{{< math >}}$ N ${{< /math >}} 阶滤波器原型的极点按照辐角均匀分布在复平面椭圆左侧，可以根据下式计算：

{{< math >}}$$
p_k = - \sinh \mu \sin \theta_k + j \cosh \mu \cos \theta_k , \quad
\mu = \frac{1}{N} \mathrm{arsinh} \frac{1}{\varepsilon} , \quad
\theta_k = \frac{2k - 1}{2N} \pi , \quad
k = 1,2,\dots, N
$${{< /math >}}

为了将直流增益修正到 {{< math >}}$1${{< /math >}}，需要补充增益：

{{< math >}}$$
g =  \frac{1}{2^{N-1} \varepsilon}
$${{< /math >}}

### 切比雪夫 II 型滤波器

切比雪夫 II 型滤波器（[Type II Chebyshev Filter](https://en.wikipedia.org/wiki/Chebyshev_filter#Type_II_Chebyshev_filters_%28inverse_Chebyshev_filters%29)）具有平坦的通带和波动的阻带，阻带增益不高于 {{< math >}}$\varepsilon / \sqrt{1 + \varepsilon^2}${{< /math >}}，转折频率定义为幅频响应第一次低于阻带增益的频率。

与 I 型不同，{{< math >}}$N${{< /math >}} 阶切比雪夫 II 型滤波器具有



### 椭圆滤波器

## 滤波器原型变换

### 低通变换

### 高通变换

### 带通变换

### 带阻变换

## 滤波器离散化


## 数字滤波器集成

### 二阶节转换

### 滤波器更新

### 状态重置

