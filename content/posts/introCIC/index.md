---
title: "CIC 滤波器简介"
date: 2022-02-13T13:37:42+08:00
tags: ["CIC","滤波器","降采样","升采样"]
categories: ["数字信号处理"]
draft: false
---

级联积分梳状（CIC, Cascaded Integrator–Comb）滤波器是一种非常“经济”的滤波器。它的实现所需资源少、具有线性相位，同时实现采样率的改变，通常可用于模数转换器（ADC, Analog to Digital Converter）的抗混叠滤波。本文简要介绍 CIC 滤波器的基本原理及其实现方法，分析该滤波器的频率响应，然后给出 CIC 滤波器在降采样（抽取）和升采样（插值）的应用，最后给出降采样倍数的一般设计方法。

<!--more-->


## 从降采样说起

如何将高速采集的数据按照一定的倍数 $R$ 降低采样率？最简单的方法就是从每 $R$ 个数中直接抽取。然而，我们之前在 [傅立叶变换与频域分析]({{< ref "../introSpectrum/index.md" >}}) 讨论过直接抽取所引入的频率混叠问题，为了避免降采样引起的混叠，必须对数据进行滤波处理。考虑到滤波就是一种平均，那么，简单起见，我们只需要对 $R$ 个数取算数平均值作为输出即可。该系统的表达式可以写为：

{{< math >}} $$
y(i) = \frac{1}{R} \left( x(iR) + x(iR-1) + \cdots + x((i-1)R+1) \right) = \frac{1}{R} \sum_{k=0}^{R-1} x(iR-k)
$$ {{< /math >}}

如果我们省略掉归一化系数 $R^{-1}$ ，如果直接实现上述过程，需要 $R-1$ 个寄存器进行单位延时，系统如下图所示。

<div align=center>
    <img src=CascadedDelay.svg width=80% />
</div>

容易想象，当我们需要进行高倍数的降采样时，所需要的寄存器（单位延时）数量会大大增加，这对数字系统设计是非常不“经济”的。下面我们就来讨论 CIC 是如何使用更“经济”的方法实现上述系统。



## CIC 滤波器的实现

省略归一化系数，算数平均值（或者说 $R$ 项累加器）的传递函数可以用 $z$ 变换表示为

{{< math >}} $$
H(z) = \sum_{k=0}^{R-1} z^{-k} 
= \frac{1-z^{-R}}{1-z^{-1}} 
= \underbrace{\frac{1}{1-z^{-1}}}_{H_I(z)} 
  \underbrace{\left(1-z^{-R}\right)}_{H_C(z)}
$$ {{< /math >}}

我们把传递函数人为地分为了两部分：$H_I(z)$ 为数字积分（累加）部分，只需要一个 $z^{-1}$ 就可以实现；$H_C(z)$ 为梳状（差分）部分，原则上需要使用 $R$ 个 $z^{-1}$。神奇之处就在这里，CIC 滤波器在进行差分之前，先进行了 $R$ 倍的降采样，因此降采样之后的一个单位延时 $z_R^{-1}$ 就能实现 $z^{-R}$ 的效果。如此做，CIC 滤波器将原本应当使用 $R-1$ 个寄存器减少到了只需要使用两个寄存器！

{{< admonition note >}}
在 $z$ 变换中，$z^{-1}$ 代表一个单位时间的延时，由一个寄存器实现，而这个“单位时间”的实际长度取决于数据的采样速率，一般的设计中都是同一个常数而不会引起混淆。由于本文的讨论中涉及到采样率的改变，因此我使用了 $z_R^{-1}$ 来表示低速数据的单位延时。也就是说，将高速数据的单位时间记做 $T_s$ （采样率记做 $f_s=1/T_s$ ），$z^{-1}$ 表示 $T_s$ 时间的延时，而 $z_R^{-1} = z^{-R}$ 表示 $RT_s$ 时间的延时。显式地使用 $z_R^{-1}$ 是为了强调只用了一个在“低速”寄存器而不是 $R$ 个“高速”寄存器。
{{< /admonition >}}


进一步地，如果只使用 $R$ 个数据的算数平均无法满足滤波的需求怎么办？我们可以从两方面入手：首先从数学上，我们可以使用更长的数据进行平均（求和）。考虑后级 $1-z_R^{-1} = 1-z^{-R}$ 是从前级的累加中进行差分，即“前 $iR$ 次数据的累加和减去前 $(i-1)R$ 个数据的累加和”而得到“最近 $R$ 个数据的累加和”，也就是说 $z_R^{-1}$ 和 $1=z_R^0$ 是求和数据的区间。如果将 $1-z_R^{-1}$ 改为 $1-z_R^{-M}$ ，就变成了最近 $MR$ 长度的数据进行累加，也就是我们所说使用更长的数据进行平均。另一方面，从系统的角度将，我们还可以将传递函数进行 $N$ 次方以实现“多次重复”滤波。

综合上述两种考虑，一般形式的 CIC 滤波器具有以下形式的传递函数，其中 $R$、$M$、$N$ 为滤波器参数。

{{< math >}} $$
H(z) = \left( \frac{1-z^{-RM}}{1-z^{-1}} \right)^N
= \left(\frac{1}{1-z^{-1}}\right)^N \left( 1-z_R^{-M} \right)^N
= H_I^N(z) H_C^N(z)
$$ {{< /math >}}

工程实践中一般取 $M=1,\,2$ 。


CIC 滤波器用于降采样时的系统框图如下

<div align=center>
    <img src=CICDecimator.svg width=80% />
</div>

用于升采样时，只需要将梳状部分和积分部分交换即可，如下图所示

<div align=center>
    <img src=CICInterpolator.svg width=80% />
</div>


小结：CIC 滤波器使用高速度累加和低速率差分，使用时根据降/升采样目标调整积分部分和梳状部分的顺序即可。


## CIC 滤波器的频率响应

为了得到 CIC 滤波器的频率响应，将 $z=\mathrm{e}^{j\omega}$ 带入传递函数即可。需要注意的是，这里的 $z$ 代表的是高速采样率 $f_s$ 下的算子，数字频率 $\omega$ 与实际频率 $f$ 的关系为

{{< math >}} $$
\omega = 2 \pi \frac{f}{f_s}
$$ {{< /math >}}

考虑到

{{< math >}} $$
\begin{aligned}
1- \mathrm{e}^{-j\theta} &= 1- \left(\cos\theta - j \sin\theta\right) \\
&= 1-\cos\theta + 2j \sin\frac{\theta}{2}\cos\frac{\theta}{2} \\
&= 2\sin^2\frac{\theta}{2} + 2j \sin\frac{\theta}{2}\cos\frac{\theta}{2} \\
&= 2j \sin\frac{\theta}{2} \left(-j\sin\frac{\theta}{2} + \cos\frac{\theta}{2} \right) \\
&= 2j \sin\frac{\theta}{2} \mathrm{e}^{-j\frac{\theta}{2}}
\end{aligned}
$$ {{< /math >}}

CIC 滤波器的传递函数可以写为

{{< math >}} $$
H(\mathrm{e}^{j\omega}) = \left( \frac{1-\mathrm{e}^{ -jRM\omega }}{1-\mathrm{e}^{- j\omega}} \right)^N
= \left( 
\frac{\sin\frac{RM}{2}\omega}{\sin\frac{1}{2}\omega} 
\right)^N \mathrm{e}^{-j\frac{RM-1}{2}N\omega}
$$ {{< /math >}}

因此幅频响应为

{{< math >}} $$
\left| H(\mathrm{e}^{j\omega})\right| = \left| \frac{\sin\frac{RM\omega}{2}}{\sin\frac{\omega}{2}} 
\right|^N 
\xrightarrow{R\rightarrow \infty}  (RM)^N \left(\frac{\sin\frac{RM\omega}{2}}{\frac{\omega}{2}} \right)^N 
= (RM)^N \left| \mathrm{sinc}\, \frac{RM\omega}{2} \right|^N
$$ {{< /math >}}

当 $R\rightarrow\infty$ 时幅频响应趋近于 $\mathrm{sinc}$ 函数，因此 CIC 滤波器也称为 SINC 滤波器。

从传递函数 $\mathrm{e}$ 指数的虚部可以看出 CIC 滤波器的相频响应为

{{< math >}} $$
\varphi(\omega) = -\frac{RM-1}{2}N\omega
$$ {{< /math >}}

其具有线性相位，群延时为常数

{{< math >}} $$
\tau = -\frac{\partial \varphi (\omega)}{\partial \omega} = \frac{RM-1}{2}N
$$ {{< /math >}}

即 CIC 滤波器对信号有 $\tau$ 个采样点的延时，即 $\Delta t = \tau T_s$ 。



## 降采样倍数的设计

最后我们讨论一下降采样倍数的设计，这实际上是指过采样设计，可以描述为这么一个问题：已知 ADC 的位数 为 $\mu_y$ ，参考电压为 $\pm V_\mathrm{ref}$，记输出的采样率为 $f_s$。为了减小 ADC 的量化误差，通常先进行高速采样（过采样，oversampling）将量化误差分布在更宽的频带从而减小其功率谱密度，然后再降采样。若要求 ADC 量化误差的功率谱密度不超过 $S_{w,\max} \\, [\mathrm{V/\sqrt{Hz}}]$，降采样倍数（或者说过采样倍数）$R$ 最小应当取多少？

首先，ADC 对正负电压进行采样，其量化的电压分辨率为

{{< math >}} $$
\rho_y = \frac{V_\mathrm{ref}}{2^{\mu_y-1}}
$$ {{< /math >}}

假设量化误差在时域上均匀分布，则方差为

{{< math >}} $$
\sigma_w^2 = = \int_{-\rho_y/2}^{\rho_y/2} x^2 \frac{1}{\rho_y} \,\mathrm{d}x = \frac{1}{12} \rho_y^2
$$ {{< /math >}}

进一步假设量化误差在频域上为白噪声。过采样的采样率为 $Rf_s$ ，则噪声将均匀分布在 $Rf_s/2$ 频带内，根据 Parseval 等式有

{{< math >}} $$
S_w^2 \frac{Rf_s}{2} = \sigma_w^2   \quad \Rightarrow \quad S_w^2 = \frac{2\sigma_w^2}{Rf_s}  \le S_{w,\mathrm{max}}^2
$$ {{< /math >}}

根据谱密度需求，有

{{< math >}} $$
R \ge R_\mathrm{min} = \left \lceil \frac{2\sigma_w^2}{f_sS_{w,\mathrm{max}}^2 } \right \rceil
= \left \lceil \frac{1}{6f_s S_{w,\mathrm{max}}^2} \left(\frac{V_\mathrm{ref}}{2^{\mu_y-1}}\right)^2 \right \rceil
$$ {{< /math >}}


## 参考资料

1. E. Hogenauer, [An Economical Class of Digital Filters for Decimation and Interpolation](https://doi.org/10.1109/TASSP.1981.1163535), IEEE Transactions on Acoustics, Speech, and Signal Processing. 29 (1981) 155–162.

