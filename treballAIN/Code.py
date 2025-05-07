import json
import numpy as np
from loguru import logger
from spade.behaviour import OneShotBehaviour
from spade.template import Template
from spade.message import Message
from pygomas.bditroop import BDITroop
from pygomas.bdisoldier import BDISoldier
from agentspeak import Actions
from agentspeak import grounded
from agentspeak.stdlib import actions as asp_action
from pygomas.ontology import DESTINATION

from pygomas.agent import LONG_RECEIVE_WAIT

class BDICode(BDISoldier):

    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)

        @actions.add_function(".code", (tuple, tuple, int, tuple))
        def _code(bandera, base, n, unidades):
            centro = [bandera[0], bandera[2]]
            centro = np.array(centro)

            inicio = [base[0], base[2]]
            inicio = np.array(inicio)

            vector = inicio-centro
            mid = vector/2

            # normalitsar vector
            vector = vector / np.linalg.norm(vector)
            
            theta = np.arctan2(vector[1], vector[0])
            angulos = np.linspace(theta, theta + np.pi/2, n)
            puntos = 100 * np.array([np.cos(angulos), np.sin(angulos)]).T
            puntos = puntos.tolist()

            posiciones = []
            i = 0
            for x in puntos:
                X = int(centro[0] + x[0])
                Z = int(centro[1] + x[1])
                if self.map.can_walk(X,Z) == True:
                    posiciones.append((unidades[i], tuple([X, 0, Z])))
                else:
                    posiciones.append((unidades[i], tuple([centro[0] + mid[0], 0, centro[1] + mid[1]])))
                i += 1

            return tuple(posiciones)

        # @actions.add_function(".soldadosConPosicion", (tuple, tuple))
        # def _soldadosConPosicion(soldados, posiciones):
        #     print(soldados)
        #     print(posiciones)
        #     return
