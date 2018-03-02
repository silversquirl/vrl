from abc import ABC, abstractmethod

class Action(ABC):
  @abstractmethod
  def apply(self, entity): pass

class MoveOrAttackAction(Action):
  def __init__(self, v):
    self.v = v

  def apply(self, entity):
    succ, pos = entity.move(self.v)
    if succ:
      return True
    # Attack
    return False
