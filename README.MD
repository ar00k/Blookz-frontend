# BLOOKZ

**Blookz** is a project that integrates Machine Learning elements with simple gameplay mechanics

## Project Goal

Create a strategic game based on an **N×N board**, whose goal is to **study player behavior** and **implement adaptive improvements** (e.g., opponent strategy changes), so that **artificial intelligence learns to defeat the player**. The project should utilize **machine learning** elements or **adaptive heuristics** to modify opponent logic.

## Game Mechanics

- The board has an **Rectangular** size and consists of blocks with different **states**: neutral, captured, hostile, blocked, or the most important - base.
- Each block has **power (strength)**, which increases at the end of each turn.
- **Block capture:** you can capture a block adjacent to your own if your block has **greater strength**.
- **Block reinforcement:** if a block (yours or enemy's) has **more than 4 neighbors**, it gains **+1 additional strength per round** (standard +1).
- **Player actions:** in each turn you can perform a limited number of actions, e.g., capture, reinforcement, or transfer strength to an adjacent block.
- The goal is to **capture the opponent's base block**.

## Analytical and AI Goals

1. **Player behavior analysis:**
   - Collecting data on decisions (e.g., expansion direction, offense/defense balance).
   - Classifying gameplay style (aggressive, defensive, random, balanced).

2. **Adaptive opponent learning:**
   - Using machine learning (Reinforcement Learning / Supervised Learning) or heuristic algorithms (e.g., Minimax with weight adaptation).
   - Dynamic AI strategy adjustment based on gameplay history.

3. **Comparison capability:**
   - AI with fixed rule set vs adaptively learning AI.
   - Analysis of results and learning curve.

## Technology Proposals

### Backend / Game Logic

- **Python** - good integration with ML libraries (TensorFlow, PyTorch, scikit-learn).

### Frontend / Game Visualization

- **TS/Vue** - interactive board, block state visualization.

### Machine Learning / Adaptation

- Reinforcement Learning: Stable Baselines3 (Python) or TensorFlow Agents.
- Heuristic algorithms: Minimax with adaptive heuristic state evaluation.
- Data analysis: Pandas, Matplotlib, scikit-learn.

### Data / Experiments

- Saving gameplay logs (JSON, CSV).
- Visualization in **Jupyter Notebook** - analysis of player decision trends.
- Ability to create _replays_ for AI debugging.

## Additional Development Directions

- Implementation of **genetic algorithms for opponent strategies**.
- Testing different AI configurations and visualizing the learning process.
- Export experiment results to an engineering report (e.g., in **LaTeX**).
