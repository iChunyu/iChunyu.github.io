# 李雅普诺夫稳定性简介


线性时不变系统的稳定性可以通过计算极点、绘制奈奎斯特图或伯德图等多种方式进行判定，对于非线性系统，通常采用李雅普诺夫稳定性判据。本文将简要介绍李雅普诺夫直接法，并介绍实践中常用的引理。

<!--more-->

## 基本定义

记自洽系统（Autonomous System）的微分方程为：

{{< math >}}$$
\dot{\bm{x}} = f(\bm{x}), \quad \bm{x}(0) = \bm{x}_0
$${{< /math >}}

设 {{< math >}}$f(0)=0${{< /math >}}，此时系统将不会发生动态变化，称 {{< math >}}$\bm{x} = 0${{< /math >}} 是该系统的一个平衡点（Equilibrium）。考察系统在平衡点附近邻域的特性：对于任意 {{< math >}}$\varepsilon > 0${{< /math >}}，如果存在 {{< math >}}$\delta > 0${{< /math >}}，使得当系统的初始状态满足 {{< math >}}$\left\lVert \bm{x}_0 \right\rVert < \delta${{< /math >}} 时，在 {{< math >}}$t \ge 0${{< /math >}} 内均有 {{< math >}}$\left\lVert \bm{x} \right\rVert < \varepsilon${{< /math >}}，则称该平衡点是稳定的（Stable）；进一步，如果随着时间的推移，有 {{< math >}}$\lim_{t \to \infty} \left\lVert \bm{x} \right\rVert = 0${{< /math >}}，则称系统是局部渐进稳定的（Locally Asymptotically Stable）；更进一步，如果对于任意初始状态 {{< math >}}$\bm{x}_0 \in \mathbb{R}^n${{< /math >}} 均有 {{< math >}}$\lim_{t \to \infty} \left\lVert \bm{x} \right\rVert = 0${{< /math >}}，则称该平衡点是全局稳定的（Globally Asymptotically Stable）。反之，则称系统是不稳定的（Unstable）。

我们进一步定义正定函数：假设函数 {{< math >}}$V(\bm{x}):\, \mathbb{R}^n \to \mathbb{R}${{< /math >}} 在某个包含原点的定义域 {{< math >}}$\mathcal{X}${{< /math >}} 内同时满足：

{{< math >}}$$
\left\{\begin{aligned}
    V(\bm{x}) &= 0 ,\quad \bm{x} = 0 \\
    V(\bm{x}) &> 0 ,\quad \bm{x} \ne 0,\; \bm{x} \in \mathcal{X}
\end{aligned}\right.
$${{< /math >}}

则称函数 {{< math >}}$V(\bm{x})${{< /math >}} 是正定的（Positive Definite）；如果 {{< math >}}$\mathcal{X} = \mathbb{R}^n${{< /math >}}，则称为全局正定（Globally Positive Definite）。特别地，如果第二个式子只能满足 {{< math >}}$V(\bm{x}) \ge 0${{< /math >}}，则称函数 {{< math >}}$V(\bm{x})${{< /math >}} 为半正定的（Positive Semidefinite）。若将第二个条件改为 {{< math >}}$V(\bm{x})<0${{< /math >}} 或 {{< math >}}$V(\bm{x}) \le 0${{< /math >}}，则分别称函数为负定（Negative Definite） 和半负定（Negative Semidefinite）。

在上面的定义下，我们可以通过李雅普诺夫直接法（又称第二法）来判断平衡点的稳定性：对于自洽系统，如果存在一个连续可微的正定函数 {{< math >}}$V(\bm{x})${{< /math >}}，进一步，如果有 {{< math >}}$\dot{V}(\bm{x})${{< /math >}} 是半负定的，则 {{< math >}}$\bm{x}=0${{< /math >}} 是一个稳定的平衡点；如果 {{< math >}}$\dot{V}(\bm{x})${{< /math >}} 是负定的，则 {{< math >}}$\bm{x}=0${{< /math >}} 是一个渐进稳定平衡点。相应的函数 {{< math >}}$V(\bm{x})${{< /math >}} 称为李雅普诺夫函数。

下面我们用一个例子来说明李雅普诺夫稳定性判定。

刚体的姿态运动可以使用四元数的微分方程表示为：

{{< math >}}$$
    \dot{\mathfrak{q}} = \frac{1}{2} \mathfrak{q} \otimes \bm{\omega}
    = \frac{1}{2} \left[ \begin{gathered}
        q_0 \\ \bm{q}
    \end{gathered} \right] \otimes \left[ \begin{gathered}
        0 \\ \bm{\omega}
    \end{gathered} \right]
    = \frac{1}{2} \left[ \begin{gathered}
        - \bm{q}^{\mathrm{T}} \bm{\omega} \\
        q_0 \bm{\omega} + \bm{q} \times \bm{\omega}
    \end{gathered} \right]
$${{< /math >}}

其中四元数表示为 {{< math >}}$\mathfrak{q} = [q_0, \bm{q}] = [q_0, q_1, q_2, q_3]${{< /math >}}。考虑反馈的角速度为：

{{< math >}}$$
\bm{\omega} = -K \mathrm{sign}(q_0) \bm{q} ,\quad  K>0
$${{< /math >}}

此时姿态运动变为：

{{< math >}}$$
\dot{\mathfrak{q}} = \frac{1}{2} K \mathrm{sign}(q_0) \left[\begin{gathered}
    \bm{q}^{\mathrm{T}} \bm{q} \\
    -q_0 \bm{q}
    \end{gathered}\right]
$${{< /math >}}

可知 {{< math >}}$\mathfrak{q} = [\pm 1, 0, 0, 0]${{< /math >}} 是系统的平衡点。取正定函数：

{{< math >}}$$
V(\mathfrak{q}) = 2 \left( 1 - \sqrt{1-\bm{q}^\mathrm{T} \bm{q}} \right) = 2 \left( 1 - \left\lvert q_0 \right\rvert \right)
$${{< /math >}}

可知

{{< math >}}$$
\dot{V}(\mathfrak{q}) = - 2 \mathrm{sign}(q_0) \dot{q}_0 = - K \bm{q}^{\mathrm{T}} \bm{q}
$${{< /math >}}

为负定的。因此 {{< math >}}$\mathfrak{q}=[\pm 1, 0, 0, 0]${{< /math >}} 是渐进稳定的平衡点。这种结合四元数标量符号的反馈策略称为有符号反馈，可用于姿态控制器设计。



## 芭芭拉引理

实际在构造李雅普诺夫函数时经常会遇到 {{< math >}}$\dot{V}(\bm{x})${{< /math >}} 是半负定的情况，因而只能判断平衡点是稳定的。为了进一步了解部分状态的收敛特性，需要使用芭芭拉引理（Barbalat's Lemma）。

假设定义在 {{< math >}}$t\ge 0${{< /math >}} 上的实值函数 {{< math >}}$f(t)${{< /math >}} 一致连续（Uniformly Continuous），且满足：

{{< math >}}$$
\lim_{T \to \infty} \,\int_0^T f(t) \,\mathrm{d}t < \infty
$${{< /math >}}

则有：

{{< math >}}$$
\lim_{t \to \infty} f(t) = 0
$${{< /math >}}

其中，函数 {{< math >}}$f(t)${{< /math >}} 一致连续是指： {{< math >}}$\forall \varepsilon > 0${{< /math >}}，{{< math >}}$\exist \delta > 0${{< /math >}}，使得 {{< math >}}$\forall \left\lvert t_1 - t_2 \right\rvert < \delta${{< /math >}} 时恒有 {{< math >}}$\left\lvert f(t_1) - f(t_2) \right\rvert < \varepsilon${{< /math >}}。函数的一致连续性可以通过判断其导数是否有界来判定，对于实际的物理系统，状态的一致连续性通常都是可以保证的。

在判断平衡点稳定性的时候，更常用的是芭芭拉引理的推论：如果标量函数 {{< math >}}$V(\bm{x})${{< /math >}} 同时满足（1）{{< math >}}$V(\bm{x})${{< /math >}} 存在下界；（2）{{< math >}}$\dot{V}(\bm{x})${{< /math >}} 是半负定的；（3）{{< math >}}$\dot{V}(\bm{x})${{< /math >}} 关于时间一致连续。则有 {{< math >}}$\lim_{t \to \infty} \dot{V}(\bm{x}) = 0${{< /math >}}。

我们可以用下面一阶系统的模型参考自适应控制（MRAC：Model Reference Adaptive Control）来说明芭芭拉引理的应用。

设一阶系统的微分方程为：

{{< math >}}$$
\dot{y} = -a y + b u , \quad a > 0
$${{< /math >}}

其中 {{< math >}}$u${{< /math >}} 和 {{< math >}}$y${{< /math >}} 分别为系统的输入、输出，{{< math >}}$a${{< /math >}} 和 {{< math >}}$b${{< /math >}} 是未知的系统参数。给定参考模型为：

{{< math >}}$$
\dot{y}_m = -a_m y_m + b_m u_m ,\quad a_m > 0
$${{< /math >}}

其中 {{< math >}}$a_m${{< /math >}} 和 {{< math >}}$b_m${{< /math >}} 为已知参数。假设被控对象的控制指令为：

{{< math >}}$$
u = \theta_1 u_m - \theta_2 y
$${{< /math >}}

且定义系统输出与参考模型输出的误差为：

{{< math >}}$$
e = y - y_m
$${{< /math >}}

于是有：

{{< math >}}$$
\dot{e} = -a_m e - \left( b \theta_2 + a - a_m \right) y + \left( b\theta_1 - b_m \right) u_m
$${{< /math >}}

理想情况下，我们希望被控对象与参考模型完全对齐，即 {{< math >}}$y = y_m${{< /math >}}、{{< math >}}$b\theta_1 = b_m${{< /math >}}、{{< math >}}$b\theta_2 = a_m - a${{< /math >}}，因此 {{< math >}}$\theta_1${{< /math >}} 和 {{< math >}}$\theta_2${{< /math >}} 也应当自适应地进行调整。设

{{< math >}}$$
V(e,\theta_1,\theta_2) = \frac{1}{2} e^2 + \frac{1}{2 b \gamma} \left( b\theta_1 - b_m \right)^2 + \frac{1}{2 b \gamma} \left( b\theta_2 + a - a_m \right)^2 , \quad \gamma > 0
$${{< /math >}}

则有：

{{< math >}}$$
\dot{V}(e,\theta_1,\theta_2) = -a_m e^2 + \frac{1}{\gamma} \left( b \theta_1 - b_m \right) \left( \dot{\theta}_1 + \gamma u_m e \right) + \frac{1}{\gamma} \left( b\theta_2 + a-a_m \right)\left( \dot{\theta}_2 - \gamma y e \right)
$${{< /math >}}

如果取自适应律为：

{{< math >}}$$
\left\{\begin{aligned}
    \dot{\theta}_1 &= - \gamma u_m e \\
    \dot{\theta}_2 &= \gamma y e
\end{aligned}\right.
$${{< /math >}}

则 {{< math >}}$\dot{V}(e,\theta_1,\theta_2) = e^2/2${{< /math >}} 是半负定的。利用李雅普诺夫稳定性判据只能知道 {{< math >}}$e=0${{< /math >}} 是个稳定的平衡点，即误差是有界的。

对于实际的物理系统，状态及其微分都可以满足一致连续的条件，因此根据芭芭拉引理的推论，可知 {{< math >}}$\lim_{t \to \infty}\dot{V}(e,\theta_1,\theta_2) = 0${{< /math >}}。因此在给定的自适应律下，可以进一步判定模型的跟踪误差将收敛到 {{< math >}}$0${{< /math >}}，被控对象的输出将能够理想地跟随参考模型。注意，芭芭拉引理并没有给出参数的收敛特性，因而尽管输出表现了良好的跟随，内部的参数可能并不会收敛到真实值。


## 拉萨尔不变性原理

在某些场景下，我们只能得到半负定的李雅普诺夫函数，而根据直觉经验系统应当是渐进稳定的。为了证明系统的稳定性，需要引入拉萨尔不变性原理（LaSalle's Invariance Principle）：

设 {{< math >}}$\bm{x}=0${{< /math >}} 是自洽系统 {{< math >}}$ \dot{\bm{x}} = f(\bm{x})${{< /math >}} 的一个平衡点，标量函数 {{< math >}}$V(\bm{x})${{< /math >}} 是正定的，且 {{< math >}}$\dot{V}(\bm{x}) \ne 0${{< /math >}}。记 {{< math >}}$\mathcal{I}${{< /math >}} 为所有满足 {{< math >}}$\dot{V}(\bm{x})=0${{< /math >}} 的完整状态轨迹的集合。如果 {{< math >}}$\mathcal{I}${{< /math >}} 除了平衡点 {{< math >}}$\bm{x}=0${{< /math >}} 外不包含任何其他轨迹，则系统渐进稳定。

下面我们使用维基百科上经典的单摆系统来阐述拉萨尔不变性原理的应用。

带阻尼的单摆系统可以由如下微分方程进行描述：

{{< math >}}$$
mgl \ddot{\theta} = - mg \sin \theta - kl \dot{\theta}
$${{< /math >}}

取状态变量 {{< math >}}$x_1=\theta${{< /math >}}、{{< math >}}$x_2 = \dot{\theta}${{< /math >}}，则系统的状态空间方程可写为：

{{< math >}}$$
\left\{\begin{aligned}
    \dot{x}_1 &= x_2 \\
    \dot{x}_2 &= - \frac{g}{l} \sin x_1 - \frac{k}{m} x_2
\end{aligned}\right.
,\quad \bm{x}(0) = \begin{bmatrix} \theta_0 \\ \dot{\theta}_0 \end{bmatrix}
$${{< /math >}}

取正定函数：

{{< math >}}$$
V(x_1, x_2) = \frac{g}{l} \left( 1-\cos x_1 \right) + \frac{1}{2} x_2^2
$${{< /math >}}

可知其导数为：

{{< math >}}$$
\dot{V}(x_1,x_2) = \frac{g}{l} \sin x_ 1 \dot{x}_1 + x_2 \dot{x}_2 = - \frac{k}{m} x_2^2
$${{< /math >}}

为半负定函数。进一步，考虑满足 {{< math >}}$\dot{V}(\bm{x})=0${{< /math >}} 的集合为：

{{< math >}}$$
\mathcal{I} = \left\{ (x_1, x_2) \left| \dot{V}(x_1,x_2) = 0 \right.\right\} = \left\{ (x_1, x_2) \left| x_2=0 \right. \right\}
$${{< /math >}}

首先可知平衡点 {{< math >}}$\bm{x} = 0${{< /math >}} 属于集合 {{< math >}}$\mathcal{I}${{< /math >}}。为了确认该集合不包含其他轨迹，假设在某一时刻 {{< math >}}$t = t_i${{< /math >}} 有 {{< math >}}$x_1(t_i) \ne 0, \, x_2(t_i) = 0${{< /math >}}，代入状态空间方程可知 {{< math >}}$\dot{x}_2(t_i) \ne 0${{< /math >}}，则 {{< math >}}$x_2${{< /math >}} 将无法维持为 {{< math >}}$0${{< /math >}}，轨迹将不在集合 {{< math >}}$\mathcal{I}${{< /math >}} 中。因此集合 {{< math >}}$\mathcal{I}${{< /math >}} 只包含系统的稳定点，进而根据拉萨尔不变性原理可以判定该系统渐进稳定。



## 参考文献

1. Karl Johan Åström, Björn Wittenmark. Adaptive Control. 2nd Edition. Dover Publications. 2008.
2. Enrico Canuto, Carlo Novara, Luca Massotti, et al. Spacecraft Dynamics and Control: The Embedded Model Control Approach. Butterworth-Heinemann. 2018.
3. Naira Hovakimyan, Chengyu Gao. {{< math >}}$\mathcal{L}_1${{< /math >}} Adaptive Control Theory: Guaranteed Robustness with Fast Adaptation. Society for Industrial and Applied Mathematics. 2010.
4. [LaSalle's invariance principle](https://en.wikipedia.org/wiki/LaSalle%27s_invariance_principle). Wikipedia. 

