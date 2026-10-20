<template>
  <ol class="granth-list">
    <li v-for="g in granths" :key="g">{{ g }}</li>
  </ol>
</template>

<script>
export default { data: () => ({ granths: ["गीता", "कबीर सागर", "वेद"] }) };
</script>
<!-- Standalone sample; not part of the app build. -->
