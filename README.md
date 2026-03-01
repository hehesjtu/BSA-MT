# BSA-MT-Enhanced: Image Detail Enhancement Algorithm

This project implements a single image detail enhancement tool based on the Bear Smell Algorithm (BSA) for parameter optimization and the Metropolis Theorem (MT) for patch matching. The algorithm adaptively identifies the optimal gradient, texture, and temperature factors through swarm intelligence to achieve robust detail extraction and reinforcement.

## Project Introduction
The project consists of a complete image enhancement workflow:
* **Parameter Optimization**: Uses `initialization.m` to generate the population and `evaluate_MT_fitness.m` to calculate fitness, searching for the optimal `lambda` parameters for the specific image.
* **Detail Extraction**: In `BSA_MT_Enhanced.m`, the optimized parameters are used for block matching across different image scales (L0, L1). The MT criterion is applied to accept non-optimal solutions to avoid local optima.
* **Synthesis and Evaluation**: In `DE_demo.m`, the extracted detail layer (Residual) is superimposed onto the original image. Finally, `calculate_dataset_y_metrics_mixed.m` automatically computes the Y-channel PSNR and SSIM metrics.

## File Structure
├── BSA_MT_Enhanced.m           # [Core Algorithm] Optimization, MT matching, and detail extraction logic
├── DE_demo.m                   # [Main Program] Batch processes images and calls evaluation modules
├── calculate_dataset_y_metrics_mixed.m # [Evaluation] Computes Y-channel PSNR/SSIM for PNG/JPG files
├── evaluate_MT_fitness.m       # [Fitness Function] Evaluates parameter quality during BSA optimization
├── initialization.m            # [Initialization] Standard population initialization for the optimizer
├── grad.p                      # [Plugin] Encapsulated gradient feature extraction (Required)
├── texture.p                   # [Plugin] Encapsulated texture feature extraction (Required)
├── data/                       # [Input Folder] Folder for raw images (.png or .jpg)
├── result/                     # [Output Folder] Folder for enhanced images and calculated metrics
└── Requirements.txt            # Environment dependency instructions
## Quick Start
Step 1: Prepare Environment
Ensure MATLAB and the Image Processing Toolbox are installed.

A high-performance computer is recommended due to the use of global variables and nested loops.

Step 2: Prepare Data
Create a folder named data in the project directory.

Place the images to be enhanced into this folder (supports mixed .png and .jpg formats).

Step 3: Run the Program
Open MATLAB and set the current folder to the project directory.

Type DE_demo in the Command Window and press Enter, or click the Run button in DE_demo.m.

## Parameter Description
factor (Default: 4): Detail enhancement multiplier; higher values make edges sharper but may increase noise.

T0 (Default: 2000): Initial temperature for the MT criterion.

gamma (Default: 0.9): Cooling coefficient for the simulated annealing process.

maxiter (In BSA_MT_Enhanced.m): Maximum iterations for the Bear Smell Algorithm optimization.

## Notes
P-file Dependencies: grad.p and texture.p are essential components; do not delete or rename them.

Execution Time: The algorithm involves a while loop for optimization and double for loops for spatial searching, which may be time-consuming for high-resolution images.

Output Format: All processed images are saved as .png to maintain image quality.

## Output Results
Enhanced images are saved in the result folder with the naming convention: [Original Filename]_BSA_MT_Enhanced.png. The Average Y-PSNR and Average Y-SSIM for the dataset will be printed in the Command Window upon completion.