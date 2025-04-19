# Neural Engineering Project

## 3.1 Analysis of Peripheral Nerve Signals
Contribution: 
-	Plotted raw VF, Flex, and Pinch nerve signals across full-window and 50 ms windows to characterize amplitude dynamics. Designed and applied a causal 4th order Butterworth bandpass filter (1.8–2.2 kHz) for real time SNR enhancement. Verified filter efficacy via Welch PSD comparison, confirming targeted noise suppression. 
-	Engineered 448 dimensional feature vectors using 100 ms windows (0% overlap) of MAV and unbiased VAR metrics. Quantified discriminability through SNR and F score metrics, identifying VAR’s consistently higher SNR, especially for Flex stimuli. Recommended k fold cross validation for optimal window/overlap tuning balancing resolution and sample size. 
- Built binary and 4 class Random Forest and SVM decoders with 10 fold CV, achieving up to 92% accuracy and 76% balance when combining MAV + VAR. Analyzed confusion matrices to confirm Flex as the easiest-to-detect class, consistent with PSD and SNR results. Employed chronological data splitting to ensure fair generalization on non stationary biological signals. 
 
## 3.2 Analysis of Electromyography (EMG) Signals
Contribution: 
- Filtered four channel EMG with a 20–255 Hz 4th order Butterworth bandpass and 60 Hz Notch to isolate muscle activation bands and remove line noise. Segmented ~2.5 s task trials (~1283–1290 samples) into sensor wise arrays, handling non uniform lengths via dynamic data mapping.
Confirmed post filter PSD distinguishing Rest vs. Task peaks in 20–256 Hz band. 
-	Extracted MAV and Zero Crossing Rate (ZCR) features over 200 ms windows (0% overlap) to capture amplitude and frequency signatures of grasp, pinch, and point tasks. Visualized MAV–ZCR scatter for each subject, demonstrating superior class separability in Subject 2 and guiding subject specific decoder design. Validated ZCR’s independence from MAV and superiority over alternative features (VAR, RMS). 
-	Developed run wise cross validated LDA and Random Forest classifiers, achieving within subject accuracies up to 95% and cross subject transfer only ~40%. Identified generalization bias via confusion heatmaps, recommending Cohen’s Kappa and F1 score for balanced evaluation. Employed run wise splitting to prevent temporal leakage and simulate real world BCI deployment.
 
## 3.3 Longitudinal EEG-MI Training and Plasticity
Contribution: 
-	Computed command delivery accuracy and timeout rates per run using trigger labels; averaged across runs to plot session wise trends for both subjects. Applied linear regression and paired t tests showing significant accuracy improvement by session 3 (p<0.005) while timeout trends remained non significant. Confirmed group level accuracy trend (p=3.43e 5) indicating motor imagery learning adaptations. 
-	Extracted 448 PSD features (32 channels × 14 bands, 4–30 Hz @2 Hz) per session and visualized scaleograms showing reduced variance and increased mean power over training. Computed Fisher scores to rank feature discriminability; tracked top 10 features revealing alpha/beta band prominence (10–12, 20–22, 24–26 Hz) and temporal stability patterns. Generated MNE topoplots of summed Fisher scores, highlighting occipital channels O2 (14–16 Hz) and Oz (24–26 Hz) as most discriminative. 
-	Correlated Subject 2’s top 10 feature discriminability with command accuracy, finding significant positive associations in occipital beta band (24–26 Hz) channels. Interpreted occipital beta activity’s role in visual motor imagery (VMI), suggesting increasing reliance on visual strategies during training. Discussed statistical power limitations of single feature tests and proposed aggregated discriminability metrics for future analysis. 

## Analysis of Peripheral Nerve Signals (PNS)

<!-- Result_Figures_1: Figures (1).jpg – Figures (13).jpg -->
![PNS Fig 1](Result_Figures_1/Figures%20(1).jpg)  
![PNS Fig 2](Result_Figures_1/Figures%20(2).jpg)  
![PNS Fig 3](Result_Figures_1/Figures%20(3).jpg)  
![PNS Fig 4](Result_Figures_1/Figures%20(4).jpg)  
![PNS Fig 5](Result_Figures_1/Figures%20(5).jpg)  
![PNS Fig 6](Result_Figures_1/Figures%20(6).jpg)  
![PNS Fig 7](Result_Figures_1/Figures%20(7).jpg)  
![PNS Fig 8](Result_Figures_1/Figures%20(8).jpg)  
![PNS Fig 9](Result_Figures_1/Figures%20(9).jpg)  
![PNS Fig 10](Result_Figures_1/Figures%20(10).jpg)  
![PNS Fig 11](Result_Figures_1/Figures%20(11).jpg)  
![PNS Fig 12](Result_Figures_1/Figures%20(12).jpg)  
![PNS Fig 13](Result_Figures_1/Figures%20(13).jpg)  

---

## Analysis of Electromyography (EMG) Signals

<!-- Result_Figures_2: Figures (1).png – Figures (21).png -->
![EMG Fig 1](Result_Figures_2/Figures%20(1).png)  
![EMG Fig 2](Result_Figures_2/Figures%20(2).png)  
![EMG Fig 3](Result_Figures_2/Figures%20(3).png)  
![EMG Fig 4](Result_Figures_2/Figures%20(4).png)  
![EMG Fig 5](Result_Figures_2/Figures%20(5).png)  
![EMG Fig 6](Result_Figures_2/Figures%20(6).png)  
![EMG Fig 7](Result_Figures_2/Figures%20(7).png)  
![EMG Fig 8](Result_Figures_2/Figures%20(8).png)  
![EMG Fig 9](Result_Figures_2/Figures%20(9).png)  
![EMG Fig 10](Result_Figures_2/Figures%20(10).png)  
![EMG Fig 11](Result_Figures_2/Figures%20(11).png)  
![EMG Fig 12](Result_Figures_2/Figures%20(12).png)  
![EMG Fig 13](Result_Figures_2/Figures%20(13).png)  
![EMG Fig 14](Result_Figures_2/Figures%20(14).png)  
![EMG Fig 15](Result_Figures_2/Figures%20(15).png)  
![EMG Fig 16](Result_Figures_2/Figures%20(16).png)  
![EMG Fig 17](Result_Figures_2/Figures%20(17).png)  
![EMG Fig 18](Result_Figures_2/Figures%20(18).png)  
![EMG Fig 19](Result_Figures_2/Figures%20(19).png)  
![EMG Fig 20](Result_Figures_2/Figures%20(20).png)  
![EMG Fig 21](Result_Figures_2/Figures%20(21).png)  

---

## Longitudinal EEG‑MI Training and Plasticity Analysis

<!-- Result_Figures_3: Figures (1).JPG – Figures (12).JPG -->
![EEG‑MI Fig 1](Result_Figures_3/Figures%20(1).JPG)  
![EEG‑MI Fig 2](Result_Figures_3/Figures%20(2).JPG)  
![EEG‑MI Fig 3](Result_Figures_3/Figures%20(3).JPG)  
![EEG‑MI Fig 4](Result_Figures_3/Figures%20(4).JPG)  
![EEG‑MI Fig 5](Result_Figures_3/Figures%20(5).JPG)  
![EEG‑MI Fig 6](Result_Figures_3/Figures%20(6).JPG)  
![EEG‑MI Fig 7](Result_Figures_3/Figures%20(7).JPG)  
![EEG‑MI Fig 8](Result_Figures_3/Figures%20(8).JPG)  
![EEG‑MI Fig 9](Result_Figures_3/Figures%20(9).JPG)  
![EEG‑MI Fig 10](Result_Figures_3/Figures%20(10).JPG)  
![EEG‑MI Fig 11](Result_Figures_3/Figures%20(11).JPG)  
![EEG‑MI Fig 12](Result_Figures_3/Figures%20(12).JPG)  
