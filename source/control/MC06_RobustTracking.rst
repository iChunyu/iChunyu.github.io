现代控制基础（6）：鲁棒跟踪控制
==========================================


参考信号引入的方法广泛适用于各种参考信号，如果参考信号的特征（微分方程）是已知的，还可以采用所谓的鲁棒跟踪控制进一步提高系统对该类信号的跟踪能力。

假设输入的参考信号满足微分方程

.. math::

   \ddot{r} + \alpha_1 \dot{r} +\alpha_0 r = 0

这里以二阶信号为例，实际的参考信号并不必须为二阶，只要找到能够描述该参考信号的微分方程即可。例如如果参考信号为 :math:`\omega_1` 和 :math:`\omega_2` 两个正弦信号的叠加，它的微分方程可选为

.. math::


   r^{(4)}+(\omega_1^2+\omega_2^2)r^{(2)} + \omega_1^2\omega_2^2 =0

可以用下面两种方法其一实现鲁棒跟踪控制。



扩展控制律
----------------------------------------

设被控对象的状态空间表述为

.. math::


   \left\{ {\begin{array}{*{20}{l}}
     {{\mathbf{\dot x}} = {A\mathbf{x}} + {B}u} \\ 
     {y = {C\mathbf{x}} } 
   \end{array}} \right.

定义跟踪误差 :math:`e=y-r` 。将其代入参考信号的微分方程，有

.. math::


   \begin{align}
     \ddot e + {\alpha _1}\dot e + {\alpha _0}e &= \ddot y + {\alpha _1}\dot y + {\alpha _0}y \\ 
      &= {C}\left( {{\mathbf{\ddot x}} + {\alpha _1}{\mathbf{\dot x}} + {\alpha _0}{\mathbf{x}}} \right) \\ 
      &= {C\mathbf{\xi }} \\ 
   \end{align}

这里定义了 :math:`\xi={{\mathbf{\ddot x}} +{\alpha_1}{\mathbf{\dot x}} +{\alpha_0}{\mathbf{x}}}` ，考察它的动态，有

.. math::


   \begin{align}
   \bf{\dot \xi } &= \frac{\mathrm{d}}{{\mathrm{d}t}}\left( {{\bf{\ddot x}} + {\alpha _1}{\bf{\dot x}} + {\alpha _0}{\bf{x}}} \right) \\\
   &= \frac{{{\mathrm{d}^2}}}{{\mathrm{d}{t^2}}}{\bf{\dot x}} + {\alpha _1}\frac{\mathrm{d}}{{\mathrm{d}t}}{\bf{\dot x}} + {\alpha _0}{\bf{\dot x}} \\\
   &= { A}\left( {{\bf{\ddot x}} + {\alpha _1}{\bf{\dot x}} + {\alpha _0}{\bf{x}}} \right) + {B}\left( {\ddot u + {\alpha _1}\dot u + {\alpha _0}u} \right) \\\
   &= {A\bf{\xi }} + {B}\mu 
   \end{align}

同样补充定义了 :math:`\mu  = \ddot u + \alpha \dot u + \alpha_0 u` 。

综上，利用误差和扩展的状态量构造误差空间（Error Space）

.. math::


   {\bf{\dot z}} = {{ A}_z}{\bf{z}} + {{B}_z}\mu =
   \left[ {\begin{array}{*{20}{c}}
   0&1&{0}\\\
   { - {\alpha _0}}&{ - {\alpha _1}}&{C}\\\
   {0}&{0}&{ A}
   \end{array}} \right]
   \left[
   \begin{array}{c}
   e \\ \dot{e} \\ \xi
   \end{array} \right]
   + \left[ {\begin{array}{*{20}{c}}
   0\\\
   0\\\
   {B}
   \end{array}} \right] \mu

取状态反馈为 :math:`\mu = - {{K}_z}{\bf{z}} = - \left[ {\begin{array}{*{20}{c}} {{K_{e0}}}&{{K_{e1}}}&{{{K}_x}} \end{array}} \right]\bf{z}` ，当上述误差收敛时，由于跟踪误差为零，系统的输出将跟随输入。

为了实现上述控制器，需要从 :math:`\mu` 中求解系统输入 :math:`u` ，这可以从 :math:`\mu` 的定义中获得

.. math::


   \begin{gathered}
     \ddot u + {\alpha _1}\dot u + {\alpha _0}u =  - {{K}_z}{\mathbf{z}} =  - {K_{e0}}e - {K_{e1}}\dot e - {{K}_x}\left( {{\mathbf{\ddot x}} + {\alpha _1}{\mathbf{\dot x}} + {\alpha _0}{\mathbf{x}}} \right) \\ 
      \Updownarrow  \\ 
     \frac{{{{\text{d}}^2}}}{{{\text{d}}{t^2}}}\left( {u + {{K}_x}{\mathbf{x}}} \right) + {\alpha _1}\frac{{\text{d}}}{{{\text{d}}t}}\left( {u + {{K}_x}{\mathbf{x}}} \right) + {\alpha _0}\left( {u + {{K}_x}{\mathbf{x}}} \right) =  - {K_{e0}}e - {K_{e1}}\dot e \\ 
      \Downarrow  \\ 
     e \to u + {{K}_x}{\mathbf{x}}:\quad H(s) =  - \frac{{{K_{e1}}s + {K_{e0}}}}{{{s^2} + {\alpha _1}s + {\alpha _0}}} \\ 
   \end{gathered}

利用微分方程的实现手段（传递函数或状态空间的标准实现），根据 :math:`e` 求解 :math:`u + {{K}_x}{\mathbf{x}}` ，然后与 :math:`{{K}_x}{\mathbf{x}}` 相减即可得到系统的输入信号 :math:`u` 。

这种方法可以看作是对控制律的扩展，而状态估计器与一般的估计器并无大异，可以将这种方法命名为扩展控制律，其结构如下图所示。

.. figure:: figures/mc06a.png
    :figwidth: 80%
    :align: center



扩展状态估计器
----------------------------------------

既然控制律可以利用已知的参考信号动态进行扩展，那么状态估计器也应当能够扩展。我们可以这样想：如果系统的输出与参考之间存在误差，说明系统的输入端存在没有被完全抵消的扰动 :math:`\rho` ，如果能够对这个扰动进行估计，令 :math:`u=-K\mathbf{x}-\rho` 就可以在控制器的输出端抵消这个扰动，从而减小跟踪误差。

从系统的输出向输入看，表现为各微分的组合，当参考信号 :math:`r` 满足某个微分方程时， :math:`\rho` 也一定会满足该微分方程，在本例中

.. math::


   \ddot{\rho} + \alpha_1 \dot{\rho} +\alpha_0 \rho = 0

类似扩展控制律，将扰动和系统状态合一起作为扩展状态，状态空间可表述为

.. math::


   \left\{ {\begin{array}{*{20}{l}}
     {{\mathbf{\dot z}} = {{A}_z}{\mathbf{z}} + {{B}_z}u = \left[ {\begin{array}{*{20}{c}}
     0&1&{\mathbf{0}} \\ 
     { - {\alpha _0}}&{ - {\alpha _1}}&{\mathbf{0}} \\ 
     {B}&{\mathbf{0}}&{A} 
   \end{array}} \right]\left[ {\begin{array}{*{20}{c}}
     \rho  \\ 
     {\dot \rho } \\ 
     {\mathbf{x}} 
   \end{array}} \right] + \left[ {\begin{array}{*{20}{c}}
     0 \\ 
     0 \\ 
     {B} 
   \end{array}} \right]u{\text{ }}} \\ 
     {y = {{C}_z}{\mathbf{z}} = \left[ {\begin{array}{*{20}{c}}
     0&0&{C} 
   \end{array}} \right]{\mathbf{z}}} 
   \end{array}} \right.

其对应的扩展状态估计器为

.. math::


   \mathbf{\dot{\hat z}} = {{A}_z}{\mathbf{z}} + {{B}_z}u + {L}_z\left( {y - {{C}_z}{\mathbf{z}}} \right)

利用 :math:`{{A}_z} - {{L}_z}{{C}_z}` 的特征值设计使扩展状态估计器稳定，最后用 :math:`u=-K\hat{\mathbf{x}} - \hat{\rho}` 即可完成整个控制器设计。本例中的闭环框图如下，状态估计器相对于普通的状态估计器增加了对扰动的建模，因此称为扩展状态估计器。

.. figure:: figures/mc06b.png
    :figwidth: 80%
    :align: center



参考资料
--------------------------------------------------

#. G. F. Franklin, J. D. Powell, and A. Emami-Naeini, Feedback Control of Dynamic Systems, 7th ed. Upper Saddle River, NJ, USA: Prentice Hall Press, 2014.

另请参阅： `鲁棒跟踪仿真测试 <https://github.com/iChunyu/LearnCtrlSys/blob/master/ModernControl/note5_RobustTracking.mlx>`_

.. 
   Converted from ``Markdown`` to ``reStructuredText`` using pandoc
   Last edited by iChunyu on 2021-04-11