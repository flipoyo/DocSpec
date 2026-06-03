<template>
  <div
    class="h-full flex flex-col"
    style="background:white"
    
  >

    <div class="flex justify-end p-6">
      <img
        src="/logo/piren-seine-transparent.png"
        style="height:80px"
      />
    </div>

    <div class="flex-1 flex flex-col justify-center px-20">
      <slot />
    </div>

  </div>
</template>