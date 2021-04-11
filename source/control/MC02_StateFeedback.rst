现代控制基础（2）：状态反馈
==========================================

现代控制理论基于状态空间建模，对于连续的线性时不变系统，其状态空间可表述为：

.. math::
    \left\{
    \begin{aligned}
    \dot{\mathbf{x}} &= A \mathbf{x} + Bu  \\
    y &= C \mathbf{x} + Du
    \end{aligned}
    \right.

通常情况下 :math:`D=0` 。

如果系统矩阵 :math:`\mathbf{A}` 存在正实部的特征值而导致系统不稳定，或是系统虽然稳定但性能不满足需求，可以通过反馈控制来改变系统特性。现代控制理论采用的状态反馈区别于经典控制中利用输出和参考信号的误差进行反馈，其根据系统的状态来计算控制信号，对于线性系统，反馈信号可表述为 :math:`u = -{\mathbf{Kx} }` ，此时系统的动态响应变为

.. math::
    \dot{\mathbf{x}} = \left( \mathbf{A}-\mathbf{BK} \right) \mathbf{x} 

因此，只要我们合理设计反馈增益 :math:`\mathbf{K}` ，使得 :math:`\mathbf{A}-\mathbf{BK}` 的特征值（对应传递函数的极点）均分布在复平面的左半平面，即可实现系统的稳定。

常用的系统极点的配置方法有主导极点法和LQR设计法，下面用一些例子来介绍反馈增益的设计方法。



主导极点法
--------------------------------------------

稳定系统的收敛速度取决于离虚轴最近的极点，称为主导极点。主导极点法是将主导极点按照适当的二阶系统进行配置，引入相应的阻尼和刚度使其满足要求；对于其他的非主导极点，将其布置在实轴上，并尽可能远离主导极点，使这些极点领导的响应能够快速收敛。

设某系统状态空间矩阵为：

.. math::
   \begin{gathered}
     {\mathbf{A}} = \begin{bmatrix}
     0&2&0&0&0 \\ 
     { - 0.1}&{ - 0.35}&{0.1}&{0.1}&{0.75} \\ 
     0&0&0&2&0 \\ 
     {0.4}&{0.4}&{ - 0.4}&{ - 1.4}&0 \\ 
     0&{ - 0.03}&0&0&{ - 1} 
   \end{bmatrix} \\
     {\mathbf{B}} = {\left[ {\begin{array}{*{20}{r}}
     1&0&0&0&0 
   \end{array}} \right]^T} \hfill \\
     {\mathbf{C}} = \left[ {\begin{array}{*{20}{r}}
     1&0&0&0&0 
   \end{array}} \right] \hfill \\
   \end{gathered}

容易计算系统矩阵的特征值有： :math:`[0,-0.5075,-0.9683,-0.6371\pm0.6669j]` ，可见改系统具有四个稳定的极点和一个位于原点的极点，可以判定该系统为Ⅰ型系统：系统的阶跃响应收敛于斜直线，如下图所示：

.. figure:: figures/mc02a.png
   :figwidth: 60%
   :align: center

通过计算二阶系统的响应，我们发现在 :math:`\omega_n = 1 \rm{ rad/s} ,  \zeta = 0.5` 时二阶系统 :math:`H(s)=\frac{\omega_n^2}{s^2+2\zeta\omega_ns+\omega_n^2}`
的响应接近需求，其极点为 :math:`-0.5\pm0.866j` 。

因此，我们可以将该系统的主导极点设置为二阶系统的极点，其他极点的距离4倍于主导极点，设置为 :math:`-4` 。

使用函数 ``acker`` 或 ``place`` 均可以实现极点配置，前者由于容易引入数值误差，一般用于阶数较低（ :math:`\le10` ）的系统；后者的算法是基于特征向量来的，应当避免使用重复极点，必要时可以使重复极点具有微妙的差别。

.. note::
   极点移动的距离越大，意味着反馈增益越大，即需要的能量越大。


通过极点配置，反馈后系统矩阵 :math:`\mathbf{A}-\mathbf{BK}`
的特征值为：:math:`[-0.5 \pm 0.866j,\,-3.99,\,-4,\,-4.01]` 。进而可以得到系统响应为（输出按20s处的值进行了归一化以便于对比）：

.. figure:: figures/mc02b.png
   :figwidth: 60%
   :align: center



LQR设计法
--------------------------------------------

LQR设计旨在寻找合适 :math:`\mathbf{K}` 的使得下面的积分取得最小值

.. math::
   {\mathcal{J} } = \int_0^\infty  { { {\mathbf{x} }^T}{\mathbf{Qx + } }{ {\mathbf{u} }^T}{\mathbf{Ru} } } \,\mathrm{d} t

其中， :math:`\mathbf{Q}` 和 :math:`\mathbf{R}` 的选取是相对“任意”的，初次设计时，可以将其选择为对角矩阵，并令各对角元素为允许误差平方的导数，即：

.. math::
   {Q_{ii} } = \frac{1}{ {\max (x_i^2)} },\quad {\text{ } }{R_{ii} } = \frac{1}{ {\max (u_i^2)} }

选定 :math:`\mathbf{Q}` 和 :math:`\mathbf{R}` 后，利用MATLAB函数 ``lqr`` 即可完成设计。

这里，我们令 :math:`\mathbf{R}=1` ，采用两种 :math:`\mathbf{Q}` 进行设计对比，结果如下图所示

.. math::
   \begin{gathered}
      {{\mathbf{Q}}_1} = \begin{bmatrix}
      {25}&0&0&0&0 \\ 
      0&{25}&0&0&0 \\ 
      0&0&{25}&0&0 \\ 
      0&0&0&{25}&0 \\ 
      0&0&0&0&{25} 
   \end{bmatrix} \\
      {{\mathbf{Q}}_2} = \begin{bmatrix}
      4&0&0&0&0 \\ 
      0&{100}&0&0&0 \\ 
      0&0&4&0&0 \\ 
      0&0&0&{100}&0 \\ 
      0&0&0&0&4 
   \end{bmatrix} 
   \end{gathered} 

.. figure:: figures/mc02c.png
   :figwidth: 60%
   :align: center



参数设计源码
--------------------------------------------

下面给出参数设计的部分源码以供参考，本文所述工作已整理在 `控制理论学习仓库 <https://github.com/iChunyu/LearnCtrlSys>`_ ，欢迎讨论！

.. code:: matlab

   % Plant
   A = [0 2 0 0 0; -0.1 -0.35 0.1 0.1 0.75; 0 0 0 2 0;
        0.4 0.4 -0.4 -1.4 0; 0 -0.03 0 0 -1];
   B = [0 0 0 0 1]';
   C = [1 0 0 0 0];

   % Dominant Second-Order Poles
   p = [-0.5+0.866i -0.5-0.866i -3.99 -4.00 -4.01]';
   K = place(A,B,p);

   % Linear Quadratic Regulator
   xm = [0.2 0.2 0.2 0.2 0.2];
   Q = diag(1./xm.^2)
   R = 1;
   K = lqr(A,B,Q,R);


.. 
   Converted from ``Markdown`` to ``reStructuredText`` using pandoc
   Last edited by iChunyu on 2021-04-11