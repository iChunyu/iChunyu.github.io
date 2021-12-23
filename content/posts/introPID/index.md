---
title: "感性认识 PID"
date: 2020-09-08
tags: ["PID","控制器"]
categories: ["控制理论基础"]
draft: false
---

比例积分微分（PID）控制器是一种经典的控制器，以其简单的结构和较强的鲁棒性广泛适用于各种控制系统。对 PID 的原理有多种解释，今天跟大家分享一些自己的看法。


<!--more-->


## 弹簧-质量-阻尼系统

弹簧-质量-阻尼系统可以说是最经典也是最容易让大家产生感性认识的物理系统，如下图所示，假设一质量块的质量为 $m$ 无摩擦地放置于地面，通过刚度系数为 $k$ 的弹簧和阻尼系数为 $c$ 的阻尼器与墙壁连接。

<div align=center>
    <img src=mass2nd.svg width=50% />
</div>

将坐标系原点建立在弹簧的自由长度处，在图示正方向下，质量块受到的力有：外部作用产生的合力 $F$、弹簧的回复力 $-kx$、阻尼器产生的阻尼 $-c\dot{x}$。根据牛顿第二定律可以得到质量块的运动方程为

{{< math >}}$$
m \ddot{x} = F - kx - c \dot{x}
$${{< /math >}}

可见，质量块的运动由系统特性（刚度和阻尼）及作用力决定。为了改变系统的动态，我们可以换一个弹簧或者阻尼器来改变系统自身的特性，或者施加一定的力$F$引导质量块的运动。

<div align=center>
    <img src=sysmdl.png width=70% />
</div>

## 增益与微分

为了改变质量块的运动特性，首先将增益和微分环节引入反馈。也就是令上面的外力依据质量块的位置和速度施加 $F = -(P x + D \dot{x })$，这时系统的动态方程将变为

{{< math >}}$$
m \ddot{x} = - kx - c \dot{x} - (P x + D \dot{x }) = -(k+P)x- (c+D) \dot{x}
$${{< /math >}}

方程中，控制器参数的比例增益 $P$ 与刚度 $k$ 处于等价的位置，而微分增益 $D$ 与阻尼系数 $c$ 等价。这就说明，虽然我们不能从物理层面改变弹簧的刚度和系统的阻尼，但是可以通过分别调整 $P$ 和 $D$ 来等效地改变系统的“闭环刚度”和“闭环阻尼”，从而改变系统的动态响应。

PD控制器的理论实现如下图所示，需要说明的是，这里的微分器仅作示意，实际上理想的微分器是不存在的，可以参考 [信号的微分]({{< ref "../diffSignal/index.md" >}})。

<div align=center>
    <img src=PD.png width=70% />
</div>


我们说经典控制是基于误差来消除误差，而误差的定义是什么呢？实际上，控制的目的是使系统的输出跟随一个参考信号 $r$，这里就对应质量块按照需求发生位移。需求值与实际值不同，就是反馈所用的误差，在本例中为

{{< math >}}$$
e = r-x
$${{< /math >}}

使用了误差反馈时，反馈力为

{{< math >}}$$
F = Pe + D\dot{e} = - (P x + D \dot{x }) + (Pr + D\dot{r})
$${{< /math >}}

该式的前一个括号对应地改变了系统的刚度和阻尼，而后一个括号是对参考信号的考究：增益考虑了参考信号以多大的强度输入到控制系统，而微分则是对参考信号进一步预测，使系统能够提前做出响应。

## 积分的作用

从上面的讨论可知，PD控制器似乎已经能够满足需求，为什么还需要用到积分呢？一般的讨论中，我们会计算PD控制下的稳态误差：令动态方程中位置的各阶导数为零，对应着没有速度、加速度，因而处于稳态。得到（下标 $\rm ss$ 表示 steady-state）

{{< math >}}$$
m \ddot{x} = - kx - c \dot{x} - (P x + D \dot{x }) + (Pr + D\dot{r})
\quad \Rightarrow \quad
x_{\rm ss} = \frac{P}{k+P}r
$${{< /math >}}

可以看到，当刚度不为$0$或者参考信号不恒为$0$时，仅采用PD控制存在稳态误差，增大$P$可以减小稳态误差，这时反馈力中$Pr$项增大，因此前面说$P$也对应于参考信号输入到控制系统的强度。

为了使稳态误差为零，这可以通两种方式补偿：

- 当系统的刚度准确可知时，令参考信号的输入强度（比例增益）为$k+P$，即反馈力的计算修改为 $F = - (P x + D \dot{x }) + \left[(P+k)r + D\dot{r} \right]$；

- 当系统的刚度不可知时，引入积分环节，反馈力变为 $F = Pe + D\dot{e} + I \int e\mathrm{d}t$，此时，系统稳定时所有的动态停止，意味着积分停止，即误差收敛到 $0$。利用积分器的这个特性，我们可以说积分环节补偿了系统参数（刚度）的不确定性。

除了系统参数不确定性外，更重要是外部扰动的不确定性。为了说明这一点，设参考信号恒为 $0$，从上面的计算可知 PD 控制不会引入稳态误差。然而当存在外部扰动力 $F_n$ 时（为方便讨论，假定为恒力），质量块最终会稳定在

{{< math >}}$$
x_{\rm ss} = \frac{F_n}{k+P}
$${{< /math >}}

即外部扰动力也会使质量块出现稳态误差，同样，我们引入积分环节，达到稳态时，各动态停止，积分的停止意味着 $e=0$，则有

{{< math >}}$$
m \ddot{x} = F_n - kx - c \dot{x} + Pe + D\dot{e} + I \int e\mathrm{d}t 
\quad \Rightarrow \quad
F_n + I \int e\mathrm{d}t = 0
$${{< /math >}}

可见积分补偿了外部扰动。

由上述讨论可知，积分环节能够补偿系统参数不确定性引入的误差和外部扰动引入的误差，从而使稳态误差收敛到 $0$。总的来说：积分能够补偿系统的不确定性。


## 总结

采用 PID 进行反馈控制时：

- P 能够改变系统的刚度，调整系统的自振频率，改变动态过程，在引入参考信号时能够调整参考信号的输入强度；
- D 能够改变系统的阻尼，使系统的自振能够快速收敛，同时能够对参考信号做出预测，使系统提前响应；
- I 则用于补偿系统由于参数不确定性、扰动不确定性引入的误差，提高系统鲁棒性。