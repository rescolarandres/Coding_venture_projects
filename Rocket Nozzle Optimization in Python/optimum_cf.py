import numpy as np
import matplotlib.pyplot as plt

def optimum_cf (gamma, P_exit_pa, mean_Pc_pa, ):
    cf = lambda p2_p3, p3_p1: np.sqrt((2 * (gamma ** 2) / (gamma - 1)) * ((2 / (gamma + 1)) ** ((gamma + 1) / (gamma - 1))) * (1 - (p2_p3 * p3_p1) ** ((gamma - 1) / gamma))) + (p2_p3 * p3_p1 - p3_p1) \
                                / ((((gamma + 1) / 2) ** (1 / (gamma - 1))) * ((p2_p3 * p3_p1) ** (1 / gamma)) * np.sqrt(((gamma + 1) / (gamma - 1)) * (1 - ((p2_p3 * p3_p1) ** ((gamma - 1) / gamma)))))
    # pe_pa = np.linspace(0.1, 3, 1000000)
    #
    # plt.plot(pe_pa, [cf(i, P_exit_pa / mean_Pc_pa) for i in pe_pa], 1, cf(1, P_exit_pa / mean_Pc_pa), '*')
    # plt.legend(['Thrust coefficient', 'Maximum Thrust Coefficient'])
    # plt.xlabel('Pe/Pa')
    # plt.ylabel(r'$C_{f}$')
    # plt.title('Thrust coefficient VS Exit to ambient pressure ratio')
    # plt.show()
    #
    # max_cf = cf(1,P_exit_pa / mean_Pc_pa)
    Cf = cf()
    return cf