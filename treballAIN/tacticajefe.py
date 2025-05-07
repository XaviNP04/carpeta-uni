import math
import random
from pygomas.bditroop import BDITroop
from agentspeak import Actions
from pygomas.ontology import DESTINATION
from agentspeak import Literal

class Jefe(BDITroop):
    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        @actions.add_function(".puedeir",(int,int,int))
        def _puedeir(X, Y, Z):
            return bool(self.map.can_walk(X,Z))
        
        @actions.add_function(".round",(float))
        def _redondea(X):
            
            return int(X)