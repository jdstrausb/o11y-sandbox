<script setup>
  import { ref, onMounted, onUnmounted } from 'vue';
  import * as echarts from 'echarts';

  // 1. Create the Template Ref
  // Initialize as null. Vue fills this after the DOM is painted.
  const chartContainer = ref(null);

  let chartInstance = null;
  
  onMounted(() => {
    // 2. Initialize the Chart on the DOM element
    // chartContainer.value is the actual <div class="chart-box"> element
    chartInstance = echarts.init(chartContainer.value);

    // 3. Define the Chart Options (Static dummy data for the drill)
    const options = {
      title: {
        text: 'Avg API Latency (ms)',
        left: 'center',
      },
      tooltip: {
        trigger: 'axis',
      },
      xAxis: {
        type: 'category',
        data: ['10:00', '10:05', '10:10', '10:15', '10:20', '10:25', '10:30'],
      },
      yAxis: {
        type: 'value',
      },
      series: [
        {
          data: [120, 132, 101, 134, 90, 230, 210],
          type: 'line',
          smooth: true,
          lineStyle: { color: '#3b82f6' },
          areaStyle: { color: '#3b82f6', opacity: 0.2 },
        }
      ]
    };

    chartInstance.setOption(options);

    // Optional: Handle window resize to make chart responsive
    window.addEventListener('resize', handleResize);
  });

  onUnmounted(() => {
    // Cleanup to prevent memory leaks
    if (chartInstance) {
      chartInstance.dispose();
    }
    window.removeEventListener('resize', handleResize);
  });

  const handleResize = () => {
    chartInstance && chartInstance.resize();
  };

  const chartData = ref([]);
</script>

<template>
  <!-- 4. Bind the ref to the element -->
  <div ref="chartContainer" class="chart-box"></div>
</template>

<style scoped>
.chart-box {
  width: 100%;
  height: 300px;
  background: white;
  border-radius: 8px;
  padding: 10px;
  border: 1px solid #ccc;
  margin-bottom: 20px;
}
</style>
