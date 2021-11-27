# 卡尔曼滤波简介


卡尔曼滤波是一种最优滤波器，通过对系统的输入和输出进行数据融合来获得状态的最优估计。本文介绍卡尔曼滤波的基本原理并推导其核心公式。

<!--more-->

## 公式推导

设线性系统的离散状态空间方程为

{{< math >}}$$
\left\{
\begin{aligned}
\mathbf{x}_{k+1} &= A\mathbf{x}_k + B \mathbf{u}_k + \mathbf{w}_k \\
\mathbf{y}_k &= C \mathbf{x}_k + \mathbf{v}_k
\end{aligned}
\right.
$${{< /math >}}

其中 $\mathbf{w}$ 和 $\mathbf{v}$ 分别是状态噪声和测量噪声，假设他们都服从高斯分布，协方差矩阵分别为

{{< math >}}$$\mathrm{E}(\mathbf{w}\mathbf{w}^T) = Q, \quad \mathrm{E}(\mathbf{v}\mathbf{v}^T) = R$${{< /math >}}

由于噪声是不可知的，只能通过模型对输出估计，状态的先验估计（上标带有负号）为

{{< math >}}$$\hat{\mathbf{x}}_{k+1}^- = A \hat{\mathbf{x}}_k + B \mathbf{u}_k$${{< /math >}}

应当注意，下一步状态的先验估计由上一步状态的后验估计（上标没有负号）迭代计算，而后验估计则依据模型误差进行数据融合得到，为

{{< math >}}$$\hat{\mathbf{x}}_{k} = \hat{\mathbf{x}}_{k}^- + K \left(y_k-C\hat{\mathbf{x}}_{k}^- \right)$${{< /math >}}

定义状态估计误差：先验估计误差为 $\mathbf{e}_k^- = \mathbf{x}_k -\hat{\mathbf{x}}_k^-$ ，后验估计误差为 $\mathbf{e}_k = \mathbf{x}_k -\hat{\mathbf{x}}_k$
。卡尔曼滤波（数据融合）的目的是使得后验估计误差最小，即

{{< math >}}$$\mathop{\mathrm{argmin}}\limits_{K}\, \mathrm{tr}\left(P_k\right),\quad P_k = \mathrm{E}\left(\mathbf{e}_k\mathbf{e}_k^T \right)$${{< /math >}}

下面来讨论卡尔曼增益的计算。为了迭代，将后验估计误差写成先验估计误差的迭代形式

{{< math >}}$$
\begin{aligned}
\mathbf{e}_k &= \mathbf{x}_k - \left(  \hat{\mathbf{x}}_{k}^- + K \left( y_k-C\hat{\mathbf{x}}_{k}^- \right) \right) \\
&=  \mathbf{x}_k -\hat{ \mathbf{x}}_k^- -KC \left(\mathbf{x}_k -\hat{ \mathbf{x}}_k^- \right) -KC\mathbf{v}_k \\
&= \left(I-KC \right)\mathbf{e}_k^- - K\mathbf{v}_k
\end{aligned}
$${{< /math >}}

则后验估计的协方差矩阵为

{{< math >}}$$
\begin{aligned}
P_k &= \mathrm{E}\left(  \left((I-KC)\mathbf{e}_k^- - K\mathbf{v}_k\right) \left((I-KC)\mathbf{e}_k^- - K\mathbf{v}_k\right)^T  \right) \\
&= (I-KC)\mathrm{E}\left(\mathbf{e}_k^- (\mathbf{e}_k^-)^T\right)(I-KC)^T 
+ K \mathrm{E}\left(\mathbf{v}_k\mathbf{v}_k^T\right)K^T \\
&\quad -  (I-KC)\mathrm{E}\left(\mathbf{e}_k^- \mathbf{v}_k^T\right)K^T - K\mathrm{E}\left(\mathbf{v}_k(\mathbf{e}_k^-)^T\right)(I-KC)^T \\
&=(I-KC)P_k^-(I-KC)^T + KRK^T
\end{aligned}
$${{< /math >}}

而先验估计误差的协方差矩阵为

{{< math >}}$$
\begin{aligned}
P_k^- &= \mathrm{E}\left(\left(\mathbf{x}_k-\hat{\mathbf{x}}_k^-\right)\left(\mathbf{x}_k-\hat{\mathbf{x}}_k^-\right)^T \right) \\
&= \mathrm{E}\left(\left(A\mathbf{e}_{k-1}+\mathbf{w}_{k-1}\right)\left(A\mathbf{e}_{k-1}+\mathbf{w}_{k-1}\right)^T \right) \\
&= A\mathrm{E}\left(\mathbf{e}_{k-1}\mathbf{e}_{k-1}^T \right) A^T + \mathrm{E}\left(\mathbf{w}_{k-1}\mathbf{w}_{k-1}^T \right) \\
&\quad + A\mathrm{E}\left(\mathbf{e}_{k-1}\mathbf{w}_{k-1}^T \right) +\mathrm{E}\left(\mathbf{w}_{k-1}\mathbf{e}_{k-1}^T \right)A^T \\
&= AP_{k-1}A^T + Q
\end{aligned}
$${{< /math >}}

为了求解最小值问题，令 $\mathrm{tr}(P_k)$ 对 $K$ 的导数为零，其中用到矩阵论的一般结论

{{< math >}}$$\frac{\mathrm{d\,tr}(AB)  }{\mathrm{d}A} = B^T, \quad \frac{\mathrm{d\,tr}(ABA^T)  }{\mathrm{d}A} = 2AB$${{< /math >}}

因而卡尔曼增益为

{{< math >}}$$\frac{\mathrm{d\,tr}(P_k) }{\mathrm{d}K} = -2(I-KC)P_k^-C^T + 2KR = 0 \quad \Rightarrow \quad K = P_k^-C^T\left(CP_k^-C^T+R\right)^{-1}$${{< /math >}}

将卡尔曼增益代回 $P_k$ 可将其化简为

{{< math >}}$$P_k = \left(I-KC\right)P_k^-$${{< /math >}}


## 公式汇总

卡尔曼滤波的五个核心公式总结如下：

{{< math >}}$$
\left\{
\begin{aligned}
&\left.
\begin{aligned}
\hat{\mathbf{x}}_{k+1}^- &= A \hat{\mathbf{x}}_k + B \mathbf{u}_k \\
P_k^- &= AP_{k-1}A^T+Q
\end{aligned}
\quad \right\} \text{预测} \\
&\left.
\begin{aligned}
K &= P_k^-C^T\left(CP_k^-C^T+R\right)^{-1}\\
\hat{\mathbf{x}}_{k} &= \hat{\mathbf{x}}_{k}^- + K\left(y_k-C\hat{\mathbf{x}}_{k}^- \right) \\
P_k &= \left(I-KC\right)P_k^-
\end{aligned}
\quad \right\} \text{更新}
\end{aligned}
\right.
$${{< /math >}}


## 参考资料

1. [DR_CAN 卡尔曼增益超详细推导](https://www.bilibili.com/video/BV1hC4y1b7K7).
2. R. Faragher. Understanding the Basis of the Kalman Filter Via a Simple and Intuitive Derivation. IEEE Signal Processing Magazine. 2012.

