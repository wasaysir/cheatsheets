= Windows, Viewports, NDC

/ Window: Rectangular region of visible scene in coordinates of the scene.
/ Viewport: Rectangular region on device. 
/ NDC: Normalized Device Coordinates. Normalized coordinates (-1 to 1) cube in normalized coordinate space done post perspective division. Mostly meant for clipping and normalization across multiple screen spaces.
/ Viewport: Device-specific coordinates related to the pixels of that scene. Final step before rasterization. (Note: Viewport is separate from the "window" of the computer, but they can be the same. Recall the box we drew in A2. THAT is the viewport, everything else is nothing.)

Given window point $(x_w, y_w)$ it maps to viewport points $(x_v, y_v)$ via $x_v = L_v / L_w (x_w - x_(w l)) + x_(v l)$. Note $L$ represents length, $x_(w l)$ represents offset for viewport on the screen. A similar process is done for the y-coordinate. 

/ Aspect Ratio: Ratio between height and width of window. 

If aspect ratios aren't the same between window and viewport, distortion occurs.
