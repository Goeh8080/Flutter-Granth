<script>
  let granths = ["गीता", "कबीर सागर", "वेद"];
</script>

<ol>
  {#each granths as g, i}
    <li>{i + 1}. {g}</li>
  {/each}
</ol>
<!-- Standalone sample; not part of the app build. -->
<!-- Granth list sample — prints titles in order. -->
