= Agents
Have:
- Abilities
- Goals/Preferences
- Prior Knowledge
- Stimuli
- Past Experiences
- Actions

*Belief State*: Internal belief about the world
*Knowledge*: Information used to solve tasks
*Representation*: Data structure to encode knowledge
*Knowledge Base*: Representation of all knowledge possessed
*Model*: How KB relates to world

== Dimensions of Complexity
1. Modularity
    - Flat: No modularity in computation
    - Modular: Each component is separateand siloed
    - Hierarchical: Modular components are broken into a hierarchical manner of subproblems
2. Planning Horizon:
    - Non-Planning: World doesn't change as a result (Ex: Protein Folding)
    - Finite: Reason ahead fixed number of steps
    - Indefinite: Reason ahead finite number (but undetermined) of steps
    - Infinite: Reason forever (focus on process)
3. Representation:
    - States: State describes how world exists
    - Features: An attribute of the world
    - Individuals and relations: How features relate to one another (Eg: child.failing() relates to child.grade)
4. Computational limits:
    - Perfect rationality: Agent always picks best action (Eg: Tic-Tac-Toe)
    - Bounded rationality: Agent picks best action given limited computation (Eg: Chess)
5. Learning:
    - Given knowledge (Eg Road laws)
    - Learned knowledge (Eg How car steers in rain)
6. Uncertainty:
    - Fully observable: Agent knows full state of world from observations (Eg: Chess)
    - Partially observable: Many states can lead to same representation (Eg: Battleship)
    - Deterministic: Action has predictable effect
    - Stochastic: Uncertainty exists over effect of action to state
7. Preference:
    - Achievement Goal: Goal to reach (binary)
    - Maintenance Goal: State to maintain
    - Complex Preferences: Complex tradeoffs between criteria and ordinality (can't please everyone)
8. Num Agents:
    - Single agent
    - Adversarial
    - Multiagent
9. Interactivity:
    - Offline: Compute its set of actions before agent has to act, so no computations required
    - Online: Computation is done between observing and acting