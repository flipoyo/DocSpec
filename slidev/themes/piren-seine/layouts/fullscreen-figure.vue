<template>
  <div class="grid grid-cols-2 gap-8 h-full">

    <div class="flex flex-col justify-center">
      <slot />
    </div>

    <div class="flex items-center justify-center">
      <slot name="right" />
    </div>

  </div>
</template>