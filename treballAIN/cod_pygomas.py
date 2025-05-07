import math
import random
from pygomas.bditroop import BDITroop
from agentspeak import Actions
from pygomas.ontology import DESTINATION
from agentspeak import Literal

class SoldadoCuidao(BDITroop):
    def add_custom_actions(self, actions):
        super().add_custom_actions(actions)

        @actions.add(".disparaCuidao", 4)
        def _dispara_cuidao(PosAliado,DistAliado,DistEnemigo,PosEnemigo):
            myX = self.movement.position[0]
            myZ = self.movement.position[-1]
            AliadoX = PosAliado[0]
            AliadoZ = PosAliado[-1]
            EnemigoX = PosEnemigo[0]
            EnemigoZ = PosEnemigo[-1]
            
            eucAX = AliadoX - myX
            eucAZ = AliadoZ -myZ
            
            eucEX = EnemigoX -myX
            eucEZ = EnemigoZ -myZ
            
            if(not((eucAX/eucEX == eucAZ/eucEZ) or DistAliado < DistEnemigo)):
                    self.shoot(3,PosEnemigo)
            yield
