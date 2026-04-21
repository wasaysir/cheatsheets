= Rendering Pipeline

#image("../assets/rendering-pipeline.png")

Composition of transforms is $p' = P V M_i p$

$V$ represents World->View transformation, and $M$ represents modelling transformation. $V M$ transforms from modelling coordinates to view coordinates.

*Note* $M$ is both modelling transformation and Model to World change of basis. It's implicitly the change of basis, nothing needs to be done.

Assuming all frames are orthonormal. To transform view frame by $T$, apply $T^(-1)$ to old view frame coordinates to get new view frame coordinates. (Ex. moving world left to move view "right"). So old CoB $V arrow.double$ new CoB $T^(-1) V$

*Viewing Transformations*: Embodied in World->View CoB matrix $V$. $V$ moves from WCS (RHS) to VCS (LHS). Tranformations of view frame done by $T$ are done relative to view frame as $V' = T^(-1) V$

*Modelling Transformations*: Embodied in matrix $M$, which moves from MCS (RHS) to WCS (LHS). To transform model by $T$ relative to modelling frame, new modelling transformation $M'$ is given by $M' = M T$.
