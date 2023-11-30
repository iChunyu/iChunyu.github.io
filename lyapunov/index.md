# 李雅普诺夫稳定性


线性时不变系统的稳定性可以通过计算极点、绘制奈奎斯特图或伯德图等多种方式进行判定，对于非线性系统，通常采用李雅普诺夫稳定性判据。本文将简要介绍李雅普诺夫直接法，并介绍实践中常用的引理。

<!--more-->

## 李雅普诺夫稳定性

假设非线性系统为：

{{< math >}}$$
\dot{\bm{x}} = f(\bm{x})
$${{< /math >}}

设 {{< math >}}$f(\underline{\bm{x}})=0${{< /math >}}，则 {{< math >}}$\underline{\bm{x}}${{< /math >}} 是该系统的一个平衡点。对于任意在平衡点附近有界的初始状态 {{< math >}}$\left\lVert \bm{x}(0) - \underline{\bm{x}} \right\rVert < \delta${{< /math >}}，如果在时间 {{< math >}}$t \ge 0${{< /math >}} 内都有 {{< math >}}$\left\lVert \bm{x}(t) - \underline{\bm{x}} \right\rVert < \varepsilon${{< /math >}}，则系统满足李雅普诺夫稳定性（Lyapunov Stability）。进一步，如果当 {{< math >}}$t \to \infty${{< /math >}} 时有 {{< math >}}$\left\lVert \bm{x}(t) - \underline{\bm{x}}\right\rVert \to 0${{< /math >}}，则称该系统渐进稳定（Asymptotically Stable）。

通俗来讲，李雅普诺夫稳定性强调的是在有界的初始条件下，系统的状态不会自然地发散。在此概念下，一个简谐振荡的二阶系统仍然可以称之为是李雅普诺夫稳定的，这在经典控制中也称作临界稳定（Marginally Stable）。对于实际情况，我们更希望状态收敛，因此通常要求系统渐进稳定。

我们进一步定义正定函数：假设函数 {{< math >}}$V(\bm{x}):\, \mathbb{R}^n \to \mathbb{R}${{< /math >}} 在某个包含原点的定义域 {{< math >}}$\mathcal{X}${{< /math >}} 内同时满足：

{{< math >}}$$
\left\{\begin{aligned}
    V(\bm{x}) &= 0 ,\quad \bm{x} = 0 \\
    V(\bm{x}) &> 0 ,\quad \bm{x} \ne 0,\; \bm{x} \in \mathcal{X}
\end{aligned}\right.
$${{< /math >}}

则称函数 {{< math >}}$V(\bm{x})${{< /math >}} 是正定的（Positive Definite）；如果 {{< math >}}$\mathcal{X} = \mathbb{R}^n${{< /math >}}，则称为全局正定（Globally Positive Definite）。特别地，如果第二个式子只能满足 {{< math >}}$V(\bm{x}) \ge 0${{< /math >}}，则称函数 {{< math >}}$V(\bm{x})${{< /math >}} 为半正定的（Positive Semidefinite）。若将第二个条件改为 {{< math >}}$V(x)<0${{< /math >}} 或 {{< math >}}$V(\bm{x}) \le 0${{< /math >}}，则分别称函数为负定（Negative Definite） 和半负定（Negative Semidefinite）。

有了上面的铺垫，我们可以给出李雅普诺夫直接法（又称第二法）的判据：对于系统 {{< math >}}$\dot{\bm{x}} = f(\bm{x})${{< /math >}}，如果关于所有状态的函数 {{< math >}}$V(\bm{x})${{< /math >}} 是正定的，且 {{< math >}}$\dot{V}(\bm{x})${{< /math >}} 是半负定的，则系统是稳定的，同时称 $V(\bm{x})$ 为李雅普诺夫函数。进一步，如果 {{< math >}}$\dot{V}(\bm{x})${{< /math >}} 是负定的，则系统渐进稳定。


## 拉萨尔不变性原理

某些系统的李雅普诺夫函数在求导之后丢失了某些状态变量，因而 {{< math >}}$\dot{V}(\bm{x})${{< /math >}} 只能是半负定的。为了进一步证明系统是渐进稳定的，需要引入如下拉萨尔不变性原理（LaSalle's Invariance Principle）：

假设 {{< math >}}$V(\bm{x})${{< /math >}} 是系统 {{< math >}}$\dot{\bm{x}} = f(\bm{x})${{< /math >}} 的李雅普诺夫函数。记满足 {{< math >}}$\dot{V}(\bm{x})${{< /math >}} 的点构成集合 {{< math >}}$\mathcal{V}${{< /math >}}，且 {{< math >}}$\mathcal{V}${{< /math >}} 的最大不变集只包含平衡点 {{< math >}}$\underline{\bm{x}}${{< /math >}}，则系统是渐进稳定的。

<!-- 为了定性地说明这一点，我们将李雅普诺夫函数想象成是一个碗状的曲面（例如二阶系统常取 {{< math >}}$V(x_1,x_2) = \frac{1}{2} x_1^2 + \frac{1}{2} x_2^2${{< /math >}}），当 {{< math >}}$\dot{V}(x_1,x_2) < 0${{< /math >}} 时，{{< math >}}$V${{< /math >}} 将逐渐趋近于 $0$，因而两个状态也都将收敛到原点，为渐进稳定。如果存在 {{< math >}}$\dot{V}=0${{< /math >}}，意味着这个碗状的曲面存在某个平坦的路径，因而当系统的状态恰好落在这个路径上时，{{< math >}}$V${{< /math >}} 的值将不在发生变动，但状态可能在这个路径上移动。拉萨尔不变性指出，如果满足 {{< math >}}$\dot{V}=0${{< /math >}} 的集合只有平衡点 {{< math >}}$\underline{\bm{x}}${{< /math >}}，那么状态只可能维持在平衡点，因此系统为渐进稳定。 -->


## 芭芭拉引理

在以自适应控制为例的场景下，我们更希望系统的跟踪误差收敛，而对系统中的可变参数放松约束，这就需要使用芭芭拉引理（Barbalat Lemma）：

假设定义在 {{< math >}}$t\ge 0${{< /math >}} 上的实值函数 {{< math >}}$g(t)${{< /math >}} 一致连续，且满足

{{< math >}}$$
\lim_{T \to \infty} \,\int_0^T g(t) \,\mathrm{d}t < \infty
$${{< /math >}}

则有

{{< math >}}$$
\lim_{t \to \infty} g(t) = 0
$${{< /math >}}

该引理的一个推论可以表述为：如果实值函数 {{< math >}}$g(t) \in \mathcal{L}_2${{< /math >}} 且 {{< math >}}$\dot{g}(t)${{< /math >}} 有界，则 {{< math >}}$\lim_{t \to \infty} g(t) = 0${{< /math >}}。


芭芭拉引理通常在 {{< math >}}$V \le 0${{< /math >}} 时通过继续求导，证明 {{< math >}}$\ddot{V}${{< /math >}} 有界，从而判定 {{< math >}}$\lim_{t \to \infty} \dot{V} = 0${{< /math >}}，进一步表明 {{< math >}}$\dot{V}${{< /math >}} 所包含的部分状态将收敛。

## 参考文献

1. E. Canuto, C. Novara, D. Carlucci, et al. Spacecraft Dynamics and Control: The Embedded Model Control Approach. Butterworth-Heinemann. 2018.
2. Karl Johan Åström, Björn Wittenmark. Adaptive Control. 2nd Edition. Dover Publications. 2008.

