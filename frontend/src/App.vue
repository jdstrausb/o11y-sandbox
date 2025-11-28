<script setup>
import { ref } from 'vue';
import CapstoneDashboard from './components/CapstoneDashboard.vue';

// State for Dark Mode
const isDark = ref(true); // Default to dark for observability tools
</script>

<template>
  <!-- Tailwind 'dark' class applied conditionally -->
  <div :class="{ dark: isDark }" class="min-h-screen">
    
    <!-- Main Background: White in light mode, Slate-900 in dark mode -->
    <main class="min-h-screen bg-gray-50 text-gray-900 dark:bg-slate-900 dark:text-gray-100 p-8 transition-colors duration-300">
      
      <header class="flex justify-between items-center mb-8 max-w-4xl mx-auto">
        <h1 class="text-3xl font-bold tracking-tight">Observability Dashboard</h1>
        <StatusBadge status="down" />
        <!-- Toggle Button -->
        <button 
          @click="isDark = !isDark"
          class="px-4 py-2 rounded-lg bg-gray-200 dark:bg-slate-700 hover:bg-gray-300 dark:hover:bg-slate-600 transition"
        >
          {{ isDark ? '☀️ Light Mode' : '🌙 Dark Mode' }}
        </button>
      </header>

      <CapstoneDashboard />

    </main>
  </div>
</template>
