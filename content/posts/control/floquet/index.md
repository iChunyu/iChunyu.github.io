---
title: "周期系统稳定性与 Floquet 理论简介"
date: 2026-02-04T00:20:00+08:00
tags: ["Floquet 理论", "周期系统", "稳定性分析"]
categories: ["控制理论基础"]
draft: false
---

周期系统是指系统参数随着时间以某一固定周期变化的动态系统，Floquet 理论为我们提供了一种有效的方法来研究这类系统的稳定性。本文将简要介绍 Floquet 理论的基本概念，并给出一个简单的示例来说明其应用。

<!--more-->

{{< admonition info 说明 >}}
本文的正文会从数学上对线性时变微分方程的通解进行讨论，为了帮助读者快速了解其与周期系统稳定性之间的关系，简要梳理其思路为：周期系统的通解与一个常数矩阵 {{< math >}}$B${{< /math >}} 呈现周期性关系，该矩阵的特征值对因通解的包络，其模长决定了系统的稳定性。
{{< /admonition >}}

## 线性周期系统与基础矩阵

考虑如下的线性时变微分方程：

{{< math >}}$$
\dot{\bm{x}}(t) = A(t) \bm{x}(t)
$${{< /math >}}

其中 {{< math >}}$A(t)${{< /math >}} 以 {{< math >}}$T${{< /math >}} 为周期。假设 {{< math >}}$\bm{x}_1(t), \, \bm{x}_2(t) , \dots , \bm{x}_n(t)${{< /math >}} 为上述方程的一组线性独立的解，将其按列向量拼接为矩阵 {{< math >}}$X(t)${{< /math >}}，称之为基础矩阵（Fundamental Matrix） ，即：

{{< math >}}$$
X(t) = \begin{bmatrix} \bm{x}_1(t) & \bm{x}_2(t) & \dots & \bm{x}_n(t) \end{bmatrix}
$${{< /math >}}

同时，记 {{< math >}}$W(t) = \left\lvert X(t) \right\rvert${{< /math >}} 为基础矩阵的行列式（Wronskian 行列式），容易证明：

{{< math >}}$$
W(t) = W(t_0) \exp\left( \int_{t_0}^{t} \mathrm{tr}(A(\tau)) \, d\tau \right)
$${{< /math >}}

显然，{{< math >}}$W(t)${{< /math >}} 表达式中 {{< math >}}$e${{< /math >}} 指数部分恒大于零，只要 {{< math >}}$W(t_0)${{< /math >}} 非零，即基础矩阵 {{< math >}}$X(t)${{< /math >}} 在 {{< math >}}$t=t_0${{< /math >}} 时刻线性无关，则在任意时刻均线性无关。因此，基础矩阵通常可以通过设置初始条件 {{< math >}}$X(t_0) = I${{< /math >}} 来确定。

给定基础矩阵 {{< math >}}$X(t)${{< /math >}} 和常数非奇异矩阵 {{< math >}}$B${{< /math >}}，取 {{< math >}}$Y(t) = X(t)B${{< /math >}}，显然有：

{{< math >}}$$
\dot{Y}(t) = \frac{\mathrm{d}}{\mathrm{d}t} \left( X(t) B \right) = \dot{X}(t) B = A(t) X(t) B = A(t) Y(t)
$${{< /math >}}

因此 {{< math >}}$Y(t)${{< /math >}} 也是一个基本矩阵。类似的方法可以证明 {{< math >}}$X(t+T)${{< /math >}} 也是一个基本矩阵。

## 基础矩阵的性质

基础矩阵的一个重要特性是 {{< math >}}$X(t+T) = X(t)B${{< /math >}}，即基础矩阵在经理一个参数变化周期后，与原基础矩阵仅相差一个常数矩阵 {{< math >}}$B${{< /math >}}。

为了证明 {{< math >}}$B${{< /math >}} 矩阵与时间无关，记 {{< math >}}$Y(t) = X(t+T)${{< /math >}}，不失一般性可以将基础矩阵一个周期内的变化表示为 {{< math >}}$B(t) = X^{-1}(t)X(t+T) = X^{-1}(t)Y(t)${{< /math >}}，于是根据定义有 {{< math >}}$Y(t) = X(t)B(t)${{< /math >}}，其初始为 {{< math >}}$Y_0(t_0) = X(t_0)B(t_0)${{< /math >}}；另一方面，前面证明基础矩阵右乘常数矩阵仍为基础矩阵，取 {{< math >}}$B_0 = B(t_0)${{< /math >}}，因此 {{< math >}}$Y_0(t) = X(t)B_0${{< /math >}} 是基础矩阵，其初始也为 {{< math >}}$Y_0(t_0) = X(t_0)B(t_0)${{< /math >}}。相同的方程、相同的初值，对因的基础矩阵一定是相同的，因此有 {{< math >}}$Y(t) = Y_0(t)${{< /math >}}，进而得到 {{< math >}}$B(t) = B_0${{< /math >}}，即矩阵 {{< math >}}$B${{< /math >}} 与时间无关。

为了得到矩阵 {{< math >}}$B${{< /math >}}，通常取 {{< math >}}$t_0 = 0${{< /math >}} 和 {{< math >}}$X(0) = I${{< /math >}}，对原方程进行积分（可能需要数值方法），即可得到 {{< math >}}$B = X(T)${{< /math >}}。

## 线性周期方程的解

Floquet 指数 {{< math >}}$\mu_i \; (i=1,2,\dots,n)${{< /math >}} 与矩阵 {{< math >}}$B${{< /math >}} 的特征值 {{< math >}}$\rho_i \; (i=1,2,\dots,n)${{< /math >}} 之间的关系记为 {{< math >}}$\rho_i = \mathrm{e}^{\mu_iT}${{< /math >}}。可以证明原线性周期方程的解 {{< math >}}$\bm{x}(t)${{< /math >}} 满足：

1. {{< math >}}$\bm{x}(t+T) = \rho \bm{x}(t)${{< /math >}}
2. {{< math >}}$\bm{x}(t) = \bm{p}(t) \mathrm{e}^{\mu t}${{< /math >}}，其中 {{< math >}}$\bm{p}(t) = \bm{p}(t+T)${{< /math >}} 为周期函数

第一个性质的证明比较直接，记 {{< math >}}$\bm{b}${{< /math >}} 和 {{< math >}}$\rho${{< /math >}} 为矩阵 {{< math >}}$B${{< /math >}} 的一个特征向量和其对应的特征值，取 {{< math >}}$\bm{x}(t) = X(t) \bm{b}${{< /math >}}，则有：

{{< math >}}$$
\bm{x}(t+T) = X(t+T) \bm{b} = X(t) B \bm{b} = \rho X(t) \bm{b} = \rho \bm{x}(t)
$${{< /math >}}

对于第二个性质，取 {{< math >}}$\bm{p}(t) = \bm{x}(t) \mathrm{e}^{-\mu t}${{< /math >}}，则有：

{{< math >}}$$
\bm{p}(t+T) = \bm{x}(t+T) \mathrm{e}^{-\mu (t+T)} = \rho \mathrm{e}^{-\mu T} \bm{x}(t) \mathrm{e}^{-\mu t} = \bm{x}(t) \mathrm{e}^{-\mu t} = \bm{p}(t)
$${{< /math >}}

由此可见，矩阵 {{< math >}}$B${{< /math >}} 的特征值决定了周期方程解的包络：

- 当所有特征值的模长均小于 1 时，通解将收敛到零，对应到控制系统就是满足内部稳定性；
- 当存在特征值的模长大于 1 时，存在指数发散的通解，系统不稳定；
- 当所有特征值的模长均小于等于 1 且存在模长等于 1 的特征值时，存在周期震荡的解，系统临界稳定。


## 示例

考虑一个二阶弹簧阻尼系统，取状态变量 {{< math >}}$\bm{x} = [x, v]${{< /math >}} 为位置和速度，则系统的状态空间方程为：

{{< math >}}$$
\dot{\bm{x}}(t) = \begin{bmatrix} 0 & 1 \\ -\omega_n^2(t) & -2 \xi \omega_n(t) \end{bmatrix} \bm{x}(t)
$${{< /math >}}

假设系统的固有频率是随时间周期变化的，即：{{< math >}}$\omega_n = \omega_c + \omega_a \sin\omega_d t${{< /math >}}，则该系统为本文所讨论的线性时变系统。

假设该系统的标称固有频率为 3 Hz，阻尼比 {{< math >}}$\xi=0.01${{< /math >}} 为定制，固有周期的波动范围为 0.1 Hz，波动频率分别为 5.9 Hz 和 6.0 Hz，在初位移条件下系统的位置响应如下图所示：

{{< image src="floquet_test.png" caption="变频振荡器响应示意" width="90%" >}}

当参数波动频率为 5.9 Hz 时，系统对应 {{< math >}}$B${{< /math >}} 矩阵绝对值最大的特征值为 0.968，系统稳定，因此位移响应将震荡收敛；而当参数波动频率为 6.0 Hz 时，系统对应 {{< math >}}$B${{< /math >}} 矩阵绝对值最大的特征值为 1.021，系统不稳定，因此位移响应的包络将呈指数发散。

```Python
import numpy as np
import numpy.typing as npt
import matplotlib.pyplot as plt
import scipy

class DampedOscillator:
    def __init__(self, fc: float, fa: float, fd: float, xi: float = 0.01):
        self.fc = fc
        self.fa = fa
        self.fd = fd
        self.xi = xi

        B = self.get_floquet_matrix()
        self.eigvals = np.linalg.eigvals(B)
        self.max_eig = np.max(np.abs(self.eigvals))

    @property
    def info(self) -> str:
        info = 'DampedOscillator\n'
        info += f'    Nominal Frequency: {self.fc:.3f} Hz\n'
        info += f'    Damping Ratio: {self.xi:.3f}\n'
        info += f'    Frequency Variation: {self.fa:.3f} Hz\n'
        info += f'    Frequency Modulation: {self.fd:.3f} Hz\n'
        info += f'    Max Characteristic Multipliers: {self.max_eig:.3f}\n'
        info += f'    Stable: {self.max_eig < 1.0}\n'
        return info

    def __repr__(self) -> str:
        return self.info

    def simulate(self, t, x0: npt.NDArray[np.float64]) -> npt.NDArray[np.float64]:
        sol = scipy.integrate.solve_ivp(self.A, (t[0], t[-1]), x0, method='RK45', t_eval=t)
        return sol.y

    def A(self, t: float, x: npt.NDArray[np.float64]) -> npt.NDArray[np.float64]:
        mat = np.zeros((2, 2))
        mat[0, 1] = 1.0

        omega = 2.0 * np.pi * (self.fc + self.fa * np.sin(2.0 * np.pi * self.fd * t))
        mat[1, 0] = -omega**2
        mat[1, 1] = -2.0 * self.xi * omega
        return mat @ x

    def get_floquet_matrix(self) -> npt.NDArray[np.float64]:
        B = np.zeros((2, 2))
        for i in range(2):
            e = np.zeros(2)
            e[i] = 1.0
            sol = scipy.integrate.solve_ivp(self.A, (0.0, 1.0 / self.fd), e, method='RK45', t_eval=[1.0 / self.fd])
            B[:, i] = sol.y[:, -1]
        return B

if __name__ == "__main__":
    sys1 = DampedOscillator(3.0, 0.1, 5.9)
    sys2 = DampedOscillator(3.0, 0.1, 6.0)

    t = np.arange(0.0, 30.0, 0.001)
    y1 = sys1.simulate(t, np.array([1.0, 0.0]))
    y2 = sys2.simulate(t, np.array([1.0, 0.0]))

    fig = plt.figure()
    ax1 = fig.add_subplot(2, 1, 1)
    ax1.plot(t, y1[0, :], label='sys1')
    ax1.annotate(sys1.info, xy=(1.05, 0.5), xycoords='axes fraction', fontsize=10, ha='left', va='center')
    ax1.grid()

    ax2 = fig.add_subplot(2, 1, 2)
    ax2.plot(t, y2[0, :], label='sys2')
    ax2.annotate(sys2.info, xy=(1.05, 0.5), xycoords='axes fraction', fontsize=10, ha='left', va='center')
    ax2.grid()

    ax1.sharex(ax2)
    ax1.set_title('Damped Oscillator with Time-Varying Frequency')
    ax2.set_xlabel('Time [s]')

    plt.subplots_adjust(right=0.6)
    plt.show()
```

## 参考文献

1. [Basic Floquet Theory](https://personal.math.ubc.ca/~ward/teaching/m605/every2_floquet1.pdf). Michael Jeffrey Ward.
