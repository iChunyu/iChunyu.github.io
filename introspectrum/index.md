# 傅立叶变换与频域分析简介


广义的傅立叶变换是指时域信号在频域内的分解，具体包括周期信号的傅立叶级数、非周期信号的傅立叶变换、离散信号的离散时间傅立叶变换和离散傅立叶变换。本文介绍这几种变换，旨在梳理其中的关系并简要讨论信号离散化带来的的问题。

<!--more-->


## 连续信号频域分析

### 傅立叶级数

首先我们从一个问题开始：假设现在有一个周期信号，不妨假设为下图蓝色曲线所示的方波。凭借朴素的直觉，这个周期信号应当能够分解为另一系列周期信号的叠加。如果选择正弦信号为基准，如何将给定的方波信号分解为正弦信号的叠加？


<div align=center>
    <img src=FourierSeriesShow.png width=70% />
</div>


提到分解，不免会想到矢量的分解。对于一个给定的矢量，如果想将它分解为不同矢量的叠加，通常需要选择一组正交的单位基矢（坐标系），然后通过内积计算向量在不同基矢上的投影（坐标），最后就可以通过投影和基矢来表达原来的矢量。


<div align=center>
    <img src=vecProj.png width=35% />
</div>


于是，我们可以类比地选择 $\cos n \omega_0 t$ 和 $\sin n \omega_0 t$ 为函数空间的基；矢量内积的相乘、相加运算类比过来就是相乘、积分，而由于是周期信号，因此积分区间只取一个周期即可；最后只要按照内积的定义计算相应的“坐标”即可知道各个正弦信号对应的幅值。这就是函数的 [正交投影]({{< ref "../orthogonalProjection/index.md" >}})。


{{< admonition note>}}
可以通过内积进行验证：倍频正弦（包括余弦）是在周期内是正交的，即任意两个相乘在周期内积分为零。实际上这样的正交基并不局限于正弦，由于傅立叶变换是基于正弦信号展开，故此处仅讨论正弦的情况。
{{< /admonition >}}


根据这个思路，实际上我们已经自己推导出了傅立叶变换，用公式表示为

- 综合公式

{{< math >}}$$
x(t) = \frac{a_0}{2} + \sum_{k=1}^{+\infty} \left(a_k \cos k\omega_0t + b_k \sin k\omega_0t\right)
$${{< /math >}}

- 分析公式

{{< math >}}$$
\left\{\begin{aligned}
    a_k &= \frac{2}{T} \int_T x(t) \cos k\omega_0t \,\mathrm{d}t \\
    b_k &= \frac{2}{T} \int_T x(t) \sin k\omega_0t \,\mathrm{d}t \\
\end{aligned}\right.
$${{< /math >}}


其中综合公式类比于矢量用基矢的表示，而分析公式则给出基矢的投影（坐标）。$T$ 为信号的周期，$\omega_0=\frac{1}{T}$ 是正弦的基频。虽然这些正弦函数相互正交，但是它们不是归一化的，因此分析公式中存在系数 $\frac{2}{T}$ 进行归一化。在这种表达中，频率索引 $k$ 非负，意味着频域是“单边”的，如果我们允许负频率的存在，并将相应的 $b_k$ 反号以与上式保持一致，就能得到更加统一的表达式：


{{< math >}}$$
x(t) =  \sum_{k=-\infty}^{+\infty} \left(a_k \cos k\omega_0t + b_k \sin k\omega_0t\right)
\quad \left\{\begin{aligned}
    a_k &= \frac{1}{T} \int_T x(t) \cos k\omega_0t \,\mathrm{d}t \\
    b_k &= \frac{1}{T} \int_T x(t) \sin k\omega_0t \,\mathrm{d}t \\
\end{aligned}\right.
$${{< /math >}}


但是这样还不足够简洁。进一步考虑欧拉公式将 $\mathrm{e}$ 的复指数分解成了正弦和余弦，如果采用这种表达，可以得到最漂亮的傅立叶级数（Fourier Series）表达式（注意 $\mathrm{e}$ 指数的符号）：


{{< math >}}$$
x(t) = \sum_{k=-\infty}^{+\infty} A_k \mathrm{e}^{\mathrm{j}k\omega_0t}  
\qquad
A_k = \frac{1}{T} \int_T x(t) \mathrm{e}^{-\mathrm{j}k\omega_0t}\,\mathrm{d}t
$${{< /math >}}


方波的傅立叶级数分解如下图所示。

<div align=center>
    <img src=FourierSeries.png width=70% />
</div>

傅立叶级数存在收敛条件，实际上是约束信号真实存在，这里我不做过多解释，直接给出（后边的傅立叶变换也有相似的条件）：

- 在一个周期内信号绝对可积
- 不存在第二类间断点（无穷间断点、震荡间断点）


在开始下一部分之前，小结一下傅立叶级数的特点：

- 适用于连续、周期信号
- 频率间隔 $\Delta f = \frac{1}{T}$
- $A_k$ 共轭对称
- 时域周期对应频域离散




### 傅立叶变换

为了将傅立叶级数应用到非周期信号，只需要重新理解一下什么是非周期信号即可：非周期嘛，不就是周期无限大吗？将傅立叶变换的综合公式取极限，有


{{< math >}}$$
\begin{aligned}
    x(t) &= \sum_{k=-\infty}^{+\infty} A_k \mathrm{e}^{\mathrm{j}k\omega_0t}  \\
    &= \lim_{T \to \infty} \sum_{k=-\infty}^{+\infty} \frac{1}{T}\mathrm{e}^{\mathrm{j}k\omega_0t} 
    \underbrace{\int_{-\infty}^{+\infty} x(t) \mathrm{e}^{-\mathrm{j}k\omega_0t}\,\mathrm{d} t }_{X(\mathrm{j}\omega)} \\
    &= \lim_{\omega_0 \to 0} \sum_{k  = -\infty}^{+\infty} X(\mathrm{j}\omega) \mathrm{e}^{\mathrm{j}k\omega_0t} \omega_0  \\
    &= \int_{-\infty}^{+\infty} X(\mathrm{j}\omega)  \mathrm{e}^{\mathrm{j}\omega t}\, \mathrm{d}\omega
\end{aligned}
$${{< /math >}}


当周期 $T$ 趋于无穷大，基频 $\omega_0$ 就趋近于 $0$，离散频率 $k\omega_0$ 就变成了连续的频率 $\omega$。整理上式就可以得到非周期信号的傅立叶变换（Fourier Transform）：


{{< math >}}$$
x(t) = \frac{1}{2\pi} \int_{-\infty}^{+\infty} X(\mathrm{j}\omega) \mathrm{e}^{\mathrm{j}\omega t}\,\mathrm{d}\omega 
\qquad
X(\mathrm{j}\omega) = \int_{-\infty}^{+\infty} x(t) \mathrm{e}^{-\mathrm{j}\omega t}\,\mathrm{d}t 
$${{< /math >}}


下图给出了傅立叶变换的示意，其具有以下基本性质：

- $X(\mathrm{j}\omega)$ 共轭对称
- 时域非周期对应于频域连续

<div align=center>
    <img src=FourierTransform.png width=70% />
</div>


至此，我们得到了两个非常重要的定性的结论：周期对应离散，非周期对应连续。实际上这个结论是“对称”的。例如在后面我们会讨论到，如果时域是离散的，那么频域就是周期的。




### 两者的统一


现在我们有了傅立叶级数用于处理连续的周期信号，还有傅立叶变换处理连续的非周期信号。然而，无论是数学“抽象归纳”的思想，或者逻辑上傅立叶变换是傅立叶级数的延拓，我们都希望这两者能够在表达上统一。为此，引入狄拉克函数，用 $\delta (t)$ 表示。它是一个广义函数，形式上可以定义为单位阶跃函数 $u(t)$ 的导数：


{{< math >}}$$
u(t) = \left\{\begin{array}{cl}
            0 & t < 0 \\
            1 & t > 0
        \end{array}\right.
        \quad \rightarrow \quad
        \delta (t) := \frac{\mathrm{d}}{\mathrm{d}t} u(t) = \left\{\begin{array}{cl}
            \infty & t = 0 \\
            0 & t \ne 0
        \end{array}\right. 
$${{< /math >}}


狄拉克函数有以下两个重要性质，将在后面的讨论中使用：

- 采样性质：$\int f(t) \delta (t-t_0) \mathrm{d} t = \int f(t_0) \delta (t-t_0)  \mathrm{d} t = f(t_0)$
- 卷积性质：$f(t) \ast \delta (t-t_0) = \int f(\tau) \delta (t-t_0-\tau)  \mathrm{d} \tau = f(t-t_0)$


根据上面的采样性质，傅立叶级数可以以傅立叶变换的形式统一表示为

{{< math >}}$$
\begin{gathered}
        X(\mathrm{j}\omega) = \sum_{k=-\infty}^{+\infty}  2 \pi A_k \delta (\omega - k\omega_0)\\
        \frac{1}{2\pi} \int_{-\infty}^{+\infty} X(\mathrm{j}\omega) \mathrm{e}^{\mathrm{j}\omega t}\,\mathrm{d}\omega 
        \Leftrightarrow  \sum_{k=-\infty}^{+\infty} A_k \mathrm{e}^{\mathrm{j}k\omega_0t}  
\end{gathered}
$${{< /math >}}


{{< admonition note>}}
需要注意的是，这种表述方法常用于分析频谱。对于实际的周期信号，还是应当使用傅里叶级数计算系数，然后改写成狄拉克函数。直接依据傅立叶变换计算会得到无穷大，无法获知狄拉克函数的系数。

正弦函数利用傅立叶变换得到的无穷大可以作为狄拉克函数的另一种定义方法。
{{< /admonition >}}



## 离散信号频域分析


### 时域采样与频率混叠

为了将连续信号离散化，可以采用冲击串进行采样，冲击串用狄拉克函数表达为

{{< math >}}$$
p(t) = \sum_{n=-\infty}^{+\infty} \delta (t - n T_s) 
$${{< /math >}}

<div align=center>
    <img src=sample.png width=50% />
</div>

代入傅立叶变换的表达式，进一步可以整理出离散时间傅立叶变换（Discrete-Time Fourier Transform）：

{{< math >}}$$
x(n) = \frac{1}{2\pi} \int_{2\pi} X(\mathrm{e}^{\mathrm{j}\omega}) \mathrm{e}^{\mathrm{j}\omega n}\,\mathrm{d}\omega 
            \qquad
            X(\mathrm{e}^{\mathrm{j}\omega}) = \sum_{n=-\infty}^{+\infty} x(n) \mathrm{e}^{-\mathrm{j}\omega n}    
$${{< /math >}}

应当注意，上式中的 $\omega$ 是数字频率，它被采样率 $f_s$ 归一化，是数字信号处理的常用方式。对于实际频率为 $f$ 的信号，其对应的数字频率为 $\omega = 2 \pi \frac{f}{f_s}$ 。


采样会引入一个非常重要的效应：频谱混叠。在对此进行解释之前，两个小结论需要读者自行证明：

- 时域乘积对应频域卷积
- 时域冲击串的频谱也是冲击串，且频域冲击间隔为采样率。

根据这两个结论，我们可以从下图直观地感受到频谱混叠的含义：首先，第一个图中的三角形假设为原连续信号的频谱，冲击串为采样函数的频谱；当进行采样，时域相乘，频域卷积。根据前面提到狄拉克函数的卷积性质，实际上是将原来的频谱按照采样率为间隔进行复制粘贴，如第二个图所示；如果原信号的带宽过大，复制粘贴之后的频谱重叠，合成之后的频谱就会发生改变，如第三个图所示，这就是所谓的频谱混叠。

<div align=center>
    <img src=aliasing.png width=70% />
</div>


可见，要想避免混叠，信号的带宽不应当超过采样率的一半。对于实际数据，如果混叠来自高频噪声，可以使用滤波器进行滤除，相应的滤波器称为抗混叠滤波器；如果是由于信号的频率较大，那么应当适当提高采样率。



### 有限窗长与频率泄露


除了频谱混叠，由于实际采样的时间有限，还会有频率泄露的效应。为了说明这个问题，定义一个窗函数，其在采样持续时间内为正值，否则为零。最常见的窗函数就是矩形窗，如下图所示


<div align=center>
    <img src=window.png width=50% />
</div>


同样，时域上信号与窗函数相乘，频域表现为原信号的频谱与窗函数频谱做卷积，这会在一定程度上影响原信号的频谱，使采样后的结果存在误差。这也是通常我们说谱估计而不是谱计算的原因。


一般情况下，窗函数具有如下图所示的频谱特征：其具有一个主瓣和多个旁瓣。为了好理解，假设原始信号就是正弦，那么与窗函数相乘之后的频谱的形状与窗函数的频谱相同（但中心频率点不同）。显然，窗函数的主瓣宽度会影响单频信号的频率分辨率，而旁瓣则容易产生出“误解”，错误地认为存在对应频率点的信号。

<div align=center>
    <img src=window-function.png width=40% />
</div>


由于采样总是有限时常，窗函数引入的频率泄露无法避免。为了尽可能减小这个效应，可以使用非矩形窗如汗宁窗、海明窗等，它们通常表现为窗的两端小，中间大。具体可以在 MATLAB 中使用 `hann` 等函数查看。


### 频域采样与栅栏效应

至此我们已经分析了时域离散的情况，距离使用计算机计算之差最后一步：频域离散化。前面讨论了离散化是冲击串相乘，时域离散对应着频域周期延拓。反过来，频域离散对应这时域周期延拓，如下图所示，为了避免利用采样后的频谱恢复时域数据时发生混叠，频率间隔应当不大于采样时长的倒数。

<div align=center>
    <img src=freqDiscrete.png width=70% />
</div>

取 $\Delta f = \frac{1}{T}$ 时，恰好不发生混叠，频域样本点数与时域数据点数相同。此时有离散傅立叶变换（Discrete Fourier Transform）

{{< math >}}$$
x(n) = \frac{1}{N} \sum_{k=0}^{N-1} X(k) \mathrm{e}^{\mathrm{j} 2\pi\frac{k}{N} n} 
            \qquad
            X(k) = \sum_{n=0}^{N-1} x(n) \mathrm{e}^{-\mathrm{j} 2\pi\frac{k}{N} n}
$${{< /math >}}


此时，频域离散，得到的频谱都是离散的点，似乎是通过栅栏在进行观察，因此叫做栅栏效应。


### 频率分辨率与计算分辨率

最后，对两个概念进行梳理

- 离散时间傅立叶变换中能够分辨的最小频率间隔 $f_{\rm res} = \frac{1}{T}$
- 离散傅立叶变换的频率间隔（栅栏效应）$\Delta f = \frac{f_s}{N}$

两个概念可以用下面的图粗糙地进行示意。

<div align=center>
    <img src=freqs-resolution.png width=70% />
</div>


在大多数情况下，两个概念并不需要进行区分，这是有 $\Delta f = \frac{f_s}{N} = \frac{1}{N T_s} = \frac{1}{T} = f_{\rm res}$ 。快速傅立叶变化的算法得到的频率点数与时域样本点数相同，可以在时域数据后补若干 $0$ 增加计算点数，从而改善计算分辨率。但是这种补 $0$ 的操作并不影响离散时间傅立叶变换，因此不会改变实际的频率分辨率。


此外，通常的频域采样是为了确保采样后的数据能够根据逆变换公式反演出时域数据，如果只关注频域特性，对频域采样不会具有太高的要求。例如 [LPSD 功率谱估计]({{< ref "../lpsd/index.md" >}}) 就采用了非均匀的频域采样。


## 参考文献

1. Alan V. Oppenheim 等, 刘树棠译. 信号与系统. 第二版. 电子工业出版社. 2014.
2. 程佩清. 数字信号处理. 第四版. 清华大学出版社. 2013.

