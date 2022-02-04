import numpy as np


class Agent:

    """An Agent as in the Schelling (1969, :cite:`Schelling69`)
    segregation model. Move each period until enough neighbours
    of the same type are found or the maximum number of moves
    is reached.

    Code is based on the example in the Stachurski and Sargent
    Online Course :cite:`StachurskiSargent13`.

    """

    def __init__(
        self, typ, initial_location, n_neighbours, require_same_type, max_moves
    ):
        self.type = typ
        self.location = np.asarray(initial_location)
        self._n_neighbours = n_neighbours
        self._require_same_type = require_same_type
        self._max_moves = max_moves

    def _draw_new_location(self):
        self.location = np.random.uniform(size=self.location.shape)

    def _get_distance(self, other):
        """Return the Euclidean distance between self and other agent."""
        return np.linalg.norm(self.location - other.location)

    def _happy(self, agents):
        """True if sufficient number of nearest neighbours are of the same type."""
        # Create a sorted list of pairs (d, agent), where d is distance from self
        distances = [
            (self._get_distance(other), other) for other in agents if not self == other
        ]
        distances.sort()
        # Extract the types of neighbouring agents
        neighbour_types = [other.type for d, other in distances[: self._n_neighbours]]
        # Count how many neighbours have the same type as self
        n_same_type = sum(self.type == nt for nt in neighbour_types)
        return n_same_type >= self._require_same_type

    def move_until_happy(self, agents):
        """If not happy, then randomly choose new locations until happy."""

        if self._happy(agents):
            return
        else:
            for _m in range(self._max_moves):
                self._draw_new_location()
                if self._happy(agents):
                    return
