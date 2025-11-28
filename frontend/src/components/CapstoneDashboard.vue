<script setup>
import { ref, shallowRef, onMounted } from 'vue';

// Use shallowRef for logs to optimize performance (Vue won't watch every property inside each log object)
const logs = shallowRef([]);

// Loading state
const loading = ref(false);

// Pagination metadata
const pagination = ref({
  current_page: 1,
  total_pages: 1
});

const error = ref(null);

const fetchLogs = async (page = 1) => {
  loading.value = true;
  error.value = null;
  
  try {
    // Note: Ensure your Rails server is running on port 3000
    const response = await fetch(`http://localhost:3000/api/v1/log_entries?page=${page}&per_page=20`);
    
    if (!response.ok) throw new Error('Network response was not ok');
    
    const json = await response.json();
    
    // Assign data to shallowRef (triggers UI update)
    logs.value = json.data;
    
    // Store metadata for pagination controls
    pagination.value = json.meta;
    
  } catch (err) {
    console.error("Failed to fetch logs:", err);
    error.value = "Failed to load logs. Is the backend running?";
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchLogs();
});

</script>

<template>
  <div class="p-6 max-w-6xl mx-auto">
    
    <div class="flex justify-between items-end mb-6">
      <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">Production Logs</h1>
      <span class="text-sm text-gray-500 dark:text-gray-400">
        Page {{ pagination.current_page }} of {{ pagination.total_pages }}
      </span>
    </div>

    <!-- Error State -->
    <div v-if="error" class="bg-red-100 dark:bg-red-900/30 border border-red-400 dark:border-red-700 text-red-700 dark:text-red-300 px-4 py-3 rounded mb-4">
      {{ error }}
    </div>

    <!-- Data Table -->
    <div class="shadow overflow-hidden border-b border-gray-200 dark:border-slate-700 sm:rounded-lg bg-white dark:bg-slate-800">
      <table class="min-w-full divide-y divide-gray-200 dark:divide-slate-700">
        <thead class="bg-gray-50 dark:bg-slate-700">
          <tr>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Time</th>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Severity</th>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Message</th>
          </tr>
        </thead>
        <tbody class="bg-white dark:bg-slate-800 divide-y divide-gray-200 dark:divide-slate-700">
          
          <!-- SKELETON STATE (Shows when loading) -->
          <template v-if="loading">
            <tr v-for="i in 5" :key="i" class="animate-pulse">
              <!-- Timestamp Column -->
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="h-4 bg-gray-200 dark:bg-slate-700 rounded w-24"></div>
              </td>
              <!-- Severity Badge Column -->
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="h-5 bg-gray-200 dark:bg-slate-700 rounded-full w-16"></div>
              </td>
              <!-- Message Column -->
              <td class="px-6 py-4 w-full">
                <div class="h-4 bg-gray-200 dark:bg-slate-700 rounded w-3/4 mb-2"></div>
                <div class="h-4 bg-gray-200 dark:bg-slate-700 rounded w-1/2"></div>
              </td>
            </tr>
          </template>

          <!-- DATA STATE (Shows when NOT loading) -->
          <template v-else>
            <tr v-for="log in logs" :key="log.id" 
                class="transition-colors duration-150"
                :class="{
                  'bg-red-50 dark:bg-red-900/30 hover:bg-red-100 dark:hover:bg-red-900/40': log.severity === 'error' || log.severity === 'fatal',
                  'bg-yellow-50 dark:bg-yellow-900/30 hover:bg-yellow-100 dark:hover:bg-yellow-900/40': log.severity === 'warn',
                  'hover:bg-gray-50 dark:hover:bg-slate-700/50': log.severity === 'info' || log.severity === 'debug'
                }"
            >
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 font-mono">
                {{ new Date(log.timestamp).toLocaleTimeString() }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full uppercase"
                  :class="{
                    'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200': log.severity === 'error' || log.severity === 'fatal',
                    'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200': log.severity === 'warn',
                    'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200': log.severity === 'info',
                    'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300': log.severity === 'debug'
                  }">
                  {{ log.severity }}
                </span>
              </td>
              <td class="px-6 py-4 text-sm text-gray-700 dark:text-gray-300">
                {{ log.message }}
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>

    <!-- Pagination Controls -->
    <div class="py-4 flex justify-between">
      <button 
        @click="fetchLogs(pagination.current_page - 1)" 
        :disabled="pagination.current_page <= 1 || loading"
        class="px-4 py-2 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-slate-700 hover:bg-gray-50 dark:hover:bg-slate-600 disabled:opacity-50"
      >
        Previous
      </button>
      <button 
        @click="fetchLogs(pagination.current_page + 1)" 
        :disabled="pagination.current_page >= pagination.total_pages || loading"
        class="px-4 py-2 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-slate-700 hover:bg-gray-50 dark:hover:bg-slate-600 disabled:opacity-50"
      >
        Next
      </button>
    </div>

  </div>
</template>

