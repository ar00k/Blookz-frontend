<script setup lang="ts"></script>

<template>
  <v-app>
    <v-main>
      <v-container>
        <v-row justify="center">
          <v-col cols="12" md="8">
            <v-card class="pa-6">
              <v-card-title class="text-h4 text-center mb-4"> 🎉 You did it! </v-card-title>
              <v-card-text class="text-center">
                <p class="text-h6 mb-4">Your Vue 3 + Vuetify app is ready!</p>
                <v-btn
                  color="primary"
                  variant="elevated"
                  href="https://vuejs.org/"
                  target="_blank"
                  rel="noopener"
                  class="me-2"
                >
                  Vue.js Docs
                </v-btn>
                <v-btn
                  color="secondary"
                  variant="elevated"
                  href="https://vuetifyjs.com/"
                  target="_blank"
                  rel="noopener"
                >
                  Vuetify Docs
                </v-btn>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<style scoped></style>
