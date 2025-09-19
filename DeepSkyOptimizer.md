# 📊 Deep Sky Imaging Optimizer – Math & Logic

This document explains the **equations and reasoning** behind the imaging optimizer.  

---

## 1. Signal-to-Noise Ratio (SNR)

For stacked images, the **raw SNR** is estimated as:

$$
SNR = \sqrt{N \cdot t}
$$

Where:
- $N$ = number of light frames  
- $t$ = exposure time per frame (in seconds)  

👉 Interpretation:  
- Doubling the **number of frames** improves SNR by $\sqrt{2}$  
- Doubling the **exposure time** per frame also improves SNR by $\sqrt{2}$  

---

## 2. Normalized SNR

We scale the raw SNR against a maximum possible SNR ($SNR_{max}$) to get a **percentage value**:

$$
SNR_{\text{norm}} = \frac{SNR}{SNR_{max}} \times 100
$$

Where:
- $SNR_{max}$ is an arbitrary "perfect" SNR reference (e.g. 1000 in code)  

---

## 3. Required Time for Target SNR

To compute how much total integration time is needed to reach a **target normalized SNR**:

$$
T_{req} = \frac{SNR_{target}^2}{t}
$$

Where:
- $SNR_{target}$ = desired raw SNR (derived from normalized percentage)  
- $t$ = exposure time per frame  

This determines how long you must expose in total to meet the SNR goal.  

---

## 4. Exposure Time Recommendation

Exposure time is based on **sky brightness (Bortle scale)** and whether you use **autoguiding**:

- With guiding:

$$
t = 
\begin{cases}
240 & \text{if } Bortle \leq 3 \\
180 & \text{if } Bortle \leq 5 \\
90  & \text{if } Bortle \leq 7 \\
45  & \text{otherwise}
\end{cases}
$$

- Without guiding:

$$
t = 
\begin{cases}
120 & \text{if } Bortle \leq 3 \\
90  & \text{if } Bortle \leq 5 \\
60  & \text{if } Bortle \leq 7 \\
30  & \text{otherwise}
\end{cases}
$$

---

## 5. Calibration Frame Scaling

Calibration frames are balanced against the number of light frames:

- **Bias Frames**:

$$
N_{bias} = \min(\max(\lfloor 0.2 \cdot N_{light} \rfloor, 10), 50)
$$

- **Dark Frames**:

$$
N_{dark} = \min(\max(\lfloor 0.2 \cdot N_{light} \rfloor, 5), 30)
$$

- **Flat Frames**:

$$
N_{flat} = \min(\max(\lfloor 0.15 \cdot N_{light} \rfloor, 5), 20)
$$

This ensures you don’t take **too few** or **too many** calibration frames.  

---

## 6. Calibration Time Estimate

Total time spent on calibration:

$$
T_{calib} = N_{bias} \cdot 0.005 + N_{flat} \cdot \max(0.1, 0.1t) + N_{dark} \cdot t
$$

Where:
- $0.005$ = 5 ms per bias  
- Flats ≈ 10% of light exposure (min 0.1 s)  
- Darks = same exposure as light frames  

---

## 7. Channel Balancing

For **LRGB (or SHO narrowband)** imaging, integration is divided by weights:

$$
T_{channel} = w_i \cdot T_{total}
$$

Where:
- $w_i$ = weight for each channel (e.g., 0.5 for Luminance, 0.166 for RGB)  
- $T_{total}$ = total planned integration time  

---

## 8. Grand Total Time

Finally, the **total session time** (lights + calibration) across all channels:

$$
T_{grand} = \sum_{i=1}^{channels} \big( T_{light,i} + T_{calib,i} \big)
$$

---

✨ With these equations, the program estimates:  
- Optimal **exposure time**  
- Number of **light frames**  
- Required **calibration frames**  
- Session time per **channel** and **grand total**  
