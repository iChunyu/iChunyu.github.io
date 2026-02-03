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

