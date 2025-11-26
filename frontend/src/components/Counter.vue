<script setup>
  import { ref } from 'vue';

  const count = ref(0);

  const increment = () => {
    count.value++;
  };
</script>

<template>
  <div class="counter-box">
    <h2>Counter Drill</h2>
    <p>Count is {{ count }}</p>
    <button @click="increment">Increment</button>
  </div>
</template>

<style scoped>
  .counter-box {
    border: 1px solid #ccc;
    padding: 1rem;
    margin-bottom: 1rem;
    border-radius: 0.5rem;
  }
  button {
    background-color: #4CAF50;
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    cursor: pointer;
  }
</style>
