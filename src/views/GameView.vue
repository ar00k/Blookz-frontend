<template>
  <v-container fluid class="pa-4">
    <!-- Game Title -->
    <v-row justify="center" class="mb-4">
      <v-col cols="auto">
        <h1 class="text-h3 text-center">BLOOKZ</h1>
        <p class="text-center text-h6">Strategic Board Game</p>
      </v-col>
    </v-row>

    <!-- Game Board and Action Buttons -->
    <v-row justify="center" align-start>
      <v-col cols="auto">
        <v-card elevation="3" class="pa-4">
          <div class="game-board">
            <!-- Column Headers (A, B, C, ...) -->
            <div class="board-row">
              <div class="board-cell corner-cell"></div>
              <div v-for="col in columns" :key="col" class="board-cell header-cell">
                {{ col }}
              </div>
            </div>

            <!-- Board Rows -->
            <div v-for="(row, rowIndex) in boardState" :key="rowIndex" class="board-row">
              <!-- Row Number -->
              <div class="board-cell header-cell">
                {{ rowIndex + 1 }}
              </div>

              <!-- Board Cells -->
              <div
                v-for="(cell, colIndex) in row"
                :key="`${rowIndex}-${colIndex}`"
                class="board-cell game-cell"
                :class="getCellClass(cell)"
                @click="selectCell(rowIndex, colIndex)"
              >
                <div class="cell-content">
                  <div v-if="cell.state !== 'blocked'" class="cell-power">{{ cell.power }}</div>
                  <v-icon
                    v-if="cell.state === 'base'"
                    size="small"
                    :color="cell.owner === 'player' ? 'blue' : 'red'"
                    :icon="mdiCastle"
                  />
                </div>
              </div>
            </div>
          </div>
        </v-card>
      </v-col>

      <!-- Action Buttons -->
      <v-col cols="auto" class="ml-6">
        <v-card class="pa-4 mb-4">
          <v-card-title class="text-h6 pb-3">Actions</v-card-title>
          <div class="d-flex flex-column ga-3">
            <v-btn
              v-for="action in availableActions"
              :key="action.name"
              :color="action.color"
              variant="flat"
              :disabled="action.disabled"
              @click="performAction(action.name)"
              class="action-btn"
              size="large"
              :prepend-icon="action.icon"
            >
              {{ action.name }}
            </v-btn>
          </div>
        </v-card>

        <!-- Game Stats -->
        <v-card class="pa-3">
          <v-card-title class="text-h6 pb-3">Game Stats</v-card-title>
          <div class="d-flex flex-column ga-3">
            <div class="stat-block stat-primary">
              <div class="stat-label">Turn number:</div>
              <div class="stat-value">{{ currentTurn }}</div>
            </div>
            <div class="stat-block stat-success">
              <div class="stat-label">Actions Left:</div>
              <div class="stat-value">{{ actionsLeft }}</div>
            </div>
            <div class="stat-block stat-info">
              <div class="stat-label">Turn of:</div>
              <div class="stat-value">{{ currentPlayer }}</div>
            </div>
          </div>
        </v-card>
      </v-col>
    </v-row>

    <!-- Legend -->
    <v-row justify="center" class="mt-4">
      <v-col cols="10">
        <v-card class="pa-4">
          <v-card-title class="text-h6 text-center mb-3">Legend</v-card-title>
          <div class="d-flex justify-center ga-6">
            <div v-for="legend in blockLegend" :key="legend.state" class="d-flex align-center ga-2">
              <div :class="['legend-block', `legend-${legend.state}`]"></div>
              <div class="text-body-2 font-weight-medium">{{ legend.label }}</div>
            </div>
          </div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { mdiSwordCross, mdiShieldPlus, mdiArrowRightThick, mdiSkipNext, mdiCastle } from '@mdi/js'

// Types
type BlockState = 'neutral' | 'player' | 'enemy' | 'blocked' | 'base'
type Owner = 'player' | 'enemy' | null

interface BlockData {
  state: BlockState
  power: number
  owner: Owner
  neighbors: number
}

// Game constants
const BOARD_WIDTH = 9
const BOARD_HEIGHT = 10
const INITIAL_ACTIONS = 3

// Reactive state
const currentTurn = ref(1)
const actionsLeft = ref(INITIAL_ACTIONS)
const currentPlayer = ref('Player')
const selectedCell = ref<{ row: number; col: number } | null>(null)

// Generate column letters
const columns = computed(() =>
  Array.from({ length: BOARD_WIDTH }, (_, i) => String.fromCharCode(65 + i)),
)

// Initialize board state
const initializeBoard = (): BlockData[][] => {
  const board: BlockData[][] = []

  for (let row = 0; row < BOARD_HEIGHT; row++) {
    board[row] = []
    for (let col = 0; col < BOARD_WIDTH; col++) {
      let state: BlockState = 'neutral'
      let owner: Owner = null
      let power = Math.floor(Math.random() * 3) + 1 // Random power 1-3

      // Place player base at the bottm-middle
      if (row === BOARD_HEIGHT - 1 && col === Math.floor(BOARD_WIDTH / 2)) {
        state = 'base'
        owner = 'player'
        power = 5
      }
      // Place enemy base at top-right
      else if (row === 0 && col === Math.floor(BOARD_WIDTH / 2)) {
        state = 'base'
        owner = 'enemy'
        power = 5
      }
      // Place some player blocks near base
      else if ((row === BOARD_HEIGHT - 1 && col === 1) || (row === BOARD_HEIGHT - 2 && col === 0)) {
        state = 'player'
        owner = 'player'
        power = Math.floor(Math.random() * 2) + 2
      }
      // Place some enemy blocks near base
      else if ((row === 0 && col === BOARD_WIDTH - 2) || (row === 1 && col === BOARD_WIDTH - 1)) {
        state = 'enemy'
        owner = 'enemy'
        power = Math.floor(Math.random() * 2) + 2
      }
      // Add some blocked cells
      else if (Math.random() < 0.1) {
        state = 'blocked'
        power = 0
      }

      // Calculate neighbors (simplified - just for demo)
      const neighbors = Math.floor(Math.random() * 8)

      board[row][col] = { state, power, owner, neighbors }
    }
  }

  return board
}

const boardState = ref(initializeBoard())

// Available actions
const availableActions = computed(() => [
  {
    name: 'Capture',
    icon: mdiSwordCross,
    color: 'primary',
    disabled: !selectedCell.value || actionsLeft.value === 0,
  },
  {
    name: 'Reinforce',
    icon: mdiShieldPlus,
    color: 'success',
    disabled: !selectedCell.value || actionsLeft.value === 0,
  },
  {
    name: 'Transfer',
    icon: mdiArrowRightThick,
    color: 'warning',
    disabled: !selectedCell.value || actionsLeft.value === 0,
  },
  {
    name: 'End Turn',
    icon: mdiSkipNext,
    color: 'secondary',
    disabled: false,
  },
])

// Block legend
const blockLegend = [
  { state: 'neutral', label: 'Neutral' },
  { state: 'player', label: 'Player' },
  { state: 'enemy', label: 'Enemy' },
  { state: 'blocked', label: 'Blocked' },
  { state: 'base', label: 'Base' },
]

// Methods
const getCellClass = (cell: BlockData) => {
  const classes = [`cell-${cell.state}`]
  if (cell.neighbors > 4) {
    classes.push('cell-reinforced')
  }
  return classes
}

const selectCell = (row: number, col: number) => {
  selectedCell.value = { row, col }
}

const performAction = (actionName: string) => {
  if (actionName === 'End Turn') {
    endTurn()
  } else if (selectedCell.value && actionsLeft.value > 0) {
    // Perform the action
    actionsLeft.value--
    console.log(
      `Performing ${actionName} on cell ${selectedCell.value.row}, ${selectedCell.value.col}`,
    )
  }
}

const endTurn = () => {
  currentTurn.value++
  actionsLeft.value = INITIAL_ACTIONS
  selectedCell.value = null

  // Increase power of all blocks
  boardState.value.forEach((row) => {
    row.forEach((cell) => {
      if (cell.state !== 'blocked') {
        cell.power += cell.neighbors > 4 ? 2 : 1
      }
    })
  })
}
</script>

<style scoped>
.game-board {
  display: inline-block;
  border: 2px solid #1976d2;
  border-radius: 4px;
}

.board-row {
  display: flex;
}

.board-cell {
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid #e0e0e0;
  box-sizing: border-box;
  font-size: 14px;
  font-weight: 600;
}

.corner-cell {
  background-color: transparent;
  border: none;
}

.header-cell {
  background-color: transparent;
  color: #999;
  font-weight: 700;
  border: none;
  opacity: 0.7;
  font-size: 10px;
}

.game-cell {
  cursor: pointer;
  transition: all 0.2s ease;
  position: relative;
}

.game-cell:hover {
  transform: scale(1.05);
  z-index: 1;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.cell-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.cell-power {
  font-weight: bold;
  font-size: 16px;
}

/* Block state colors */
.cell-neutral {
  background-color: #fafafa;
  color: #333;
}

.cell-player {
  background-color: #e3f2fd;
  color: #1976d2;
  border-color: #1976d2;
}

.cell-enemy {
  background-color: #ffebee;
  color: #d32f2f;
  border-color: #d32f2f;
}

.cell-blocked {
  background-color: #424242;
  color: #fff;
  cursor: not-allowed;
}

.cell-base {
  background: linear-gradient(45deg, #ffd700, #ffed4e);
  color: #333;
  border: 2px solid #ff9800;
  font-weight: 900;
}

.cell-reinforced {
  box-shadow: inset 0 0 0 2px #4caf50;
}

/* Action button styles */
.action-btn:hover:not(.v-btn--disabled) {
  opacity: 0.7 !important;
  transition: opacity 0.2s ease;
}

/* Game stats styles */
.stat-block {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 12px 20px;
  border-radius: 8px;
  min-width: 120px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.stat-primary {
  background-color: #1976d2;
  color: white;
}

.stat-success {
  background-color: #4caf50;
  color: white;
}

.stat-info {
  background-color: #2196f3;
  color: white;
}

.stat-label {
  font-size: 12px;
  opacity: 0.9;
  margin-bottom: 4px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stat-value {
  font-size: 20px;
  font-weight: bold;
}

/* Legend styles */
.legend-block {
  width: 24px;
  height: 24px;
  border: 1px solid #ccc;
  border-radius: 2px;
  margin: 0 auto 4px;
}

.legend-neutral {
  background-color: #fafafa;
}
.legend-player {
  background-color: #e3f2fd;
  border-color: #1976d2;
}
.legend-enemy {
  background-color: #ffebee;
  border-color: #d32f2f;
}
.legend-blocked {
  background-color: #424242;
}
.legend-base {
  background: linear-gradient(45deg, #ffd700, #ffed4e);
  border-color: #ff9800;
}
</style>
