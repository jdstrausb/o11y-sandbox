<script setup>
  import { ref, shallowRef, onMounted } from 'vue';

  // Use shallowRef because we don't need Vue to watch every property inside every log object
  const logs = shallowRef([]);
  const loading = shallowRef(false);

  const generateDummyLogs = (count) => {
    const levels = ['INFO', 'WARN', 'ERROR', 'DEBUG'];
    const data = [];

    for (let i = 0; i < count; i++) {
      data.push({
        id: i,
        level: levels[Math.floor(Math.random() * levels.length)],
        message: `Request processed for /api/v1/resource/${Math.floor(Math.random() * 1000)}`,
        latency: Math.floor(Math.random() * 500) + 'ms'
      });
    }

    return data;
  };

  const refreshLogs = () => {
    loading.value = true;
    setTimeout(() => {
      logs.value = generateDummyLogs(100000);
      loading.value = false;
    }, 500);
  };

  onMounted(() => {
    refreshLogs();
  });

  const logFontSize = ref(13); // Default 13px
</script>

<template>
  <!-- Card Container -->
  <div class="rounded-lg border shadow-sm bg-white dark:bg-slate-800 border-gray-200 dark:border-slate-700">
    
    <!-- Header -->
    <div class="p-4 flex justify-between items-center border-b border-gray-200 dark:border-slate-700">
      <h2 class="font-semibold text-lg">Live Logs ({{ logs.length }})</h2>
      <div class="flex items-center gap-2 mr-4">
        <label class="text-xs text-gray-600 dark:text-gray-300">Size:</label>
        <input type="range" min="10" max="18" v-model="logFontSize" />
      </div>
      <button 
        @click="refreshLogs" 
        :disabled="loading"
        class="text-sm px-3 py-1 rounded bg-blue-600 text-white hover:bg-blue-700 disabled:opacity-50"
      >
        {{ loading ? 'Loading...' : 'Refresh Stream' }}
      </button>
    </div>

    <!-- Virtual Scroller Wrapper -->
    <!-- Note: We keep a specific class for height, but use Tailwind for the rest -->
    <RecycleScroller
      class="RecycleScroller h-[400px] overflow-hidden" 
      :items="logs"
      :item-size="36" 
      key-field="id"
      v-slot="{ item }"
    >
      <!-- Log Row -->
      <div class="flex items-center gap-4 px-4 h-[36px] border-b border-gray-100 dark:border-slate-700 font-mono hover:bg-gray-50 dark:hover:bg-slate-700/50">
        
        <span class="text-gray-400 w-20 shrink-0">{{ item.timestamp }}</span>
        
        <span 
          class="px-2 py-0.5 rounded text-xs font-bold w-16 text-center"
          :class="{
            'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200': item.level === 'INFO',
            'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200': item.level === 'WARN',
            'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200': item.level === 'ERROR',
            'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300': item.level === 'DEBUG',
          }"
        >
          {{ item.level }}
        </span>
        
        <span class="truncate text-gray-600 dark:text-gray-300 flex-1">{{ item.message }}</span>
        
        <span class="text-green-600 dark:text-green-400 font-bold w-16 text-right">{{ item.latency }}</span>
      </div>
    </RecycleScroller>
  </div>
</template>

<style scoped>
/* 
  Vue magically turns v-bind('logFontSize + "px"') into a CSS variable 
  scoped to this component's root.
*/
.RecycleScroller {
  font-size: v-bind('logFontSize + "px"');
}
</style>
