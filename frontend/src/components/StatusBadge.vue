<script setup>
defineProps({
  status: {
    type: String,
    required: true,
    validator: (value) => ['up', 'down', 'maintenance'].includes(value)
  }
});
</script>

<template>
  <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium border shadow-sm bg-white dark:bg-slate-800 border-gray-200 dark:border-slate-700">
    
    <!-- The Dot -->
    <span class="relative flex h-2.5 w-2.5">
      <!-- Ping animation (only if status is down) -->
      <span 
        v-if="status === 'down'" 
        class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"
      ></span>
      
      <!-- Static Color Dot -->
      <span 
        class="relative inline-flex rounded-full h-2.5 w-2.5"
        :class="{
          'bg-green-500': status === 'up',
          'bg-red-500': status === 'down',
          'bg-yellow-500': status === 'maintenance'
        }"
      ></span>
    </span>

    <!-- The Text -->
    <span class="uppercase tracking-wider text-gray-700 dark:text-gray-300">
      {{ status }}
    </span>
  </span>
</template>
